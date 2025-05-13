//
//  WaterViewModel.swift
//  Hydrate+
//
//  Created by Ian on 21/04/2025.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

@MainActor
class WaterViewModel: ObservableObject {
    @Published var waterLogs: [WaterLog] = []
    @Published var totalConsumed: Double = 0.0
    @Published var todayWaterLogs: [WaterLog] = []
    @Published var currentIntake: Double = 0.0 {
        didSet {
            totalConsumed = currentIntake
        }
    }
    @Published var currentStreak: Int = 0
    @Published var dailyAverage: Double = 0.0
    
    private var userID: String
    private var db = Firestore.firestore()
    private var lastResetDate: Date?
    private var userListener: ListenerRegistration?
    private var streakData: StreakData?
    
    init(userID: String) {
        self.userID = userID
        setupUserListener()
        Task {
            await checkAndResetDailyIntake()
            await fetchStreakData()
            await calculateDailyAverage()
        }
    }
    
    private func setupUserListener() {
        userListener?.remove()
        
        userListener = db.collection("users").document(userID)
            .addSnapshotListener { [weak self] snapshot, error in
                guard let self = self,
                      let data = snapshot?.data(),
                      let currentIntake = data["currentIntake"] as? Double else {
                    return
                }
                
                DispatchQueue.main.async {
                    self.currentIntake = currentIntake
                    self.totalConsumed = currentIntake
                    print("Updated currentIntake and totalConsumed from Firestore: \(currentIntake)")
                }
            }
    }
    
    private func checkAndResetDailyIntake() async {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        
        // Get the last reset date from Firestore
        do {
            let userDoc = try await db.collection("users").document(userID).getDocument()
            if let lastResetTimestamp = userDoc.data()?["lastResetDate"] as? Timestamp {
                lastResetDate = lastResetTimestamp.dateValue()
            }
            
            // this only resets if it's a new day and we haven't reset yet
            if lastResetDate == nil || !calendar.isDate(lastResetDate!, inSameDayAs: today) {
                try await WaterLogService().resetDailyIntake(forUserID: userID)
                try await db.collection("users").document(userID).updateData([
                    "lastResetDate": Timestamp(date: today)
                ])
                lastResetDate = today
                await fetchLogs()
            }
        } catch {
            print("Error checking/resetting daily intake: \(error.localizedDescription)")
        }
    }
    
    // Fetch all water logs from Firebase for the current user filters out today's logs and calculates total consumption
    func fetchLogs() async {
        do {
            await checkAndResetDailyIntake()
            let logs = try await WaterLogService().fetchWaterLogs(forUserID: userID)
            self.waterLogs = logs
            let today = Calendar.current.startOfDay(for: Date())
            self.todayWaterLogs = logs.filter { Calendar.current.isDate($0.time, inSameDayAs: today) }
            self.totalConsumed = todayWaterLogs.reduce(0) { $0 + $1.amount }
        } catch {
            print("Error fetching water logs: \(error.localizedDescription)")
        }
    }
    
    // Adds a new water log and updates the appropriate state
    func addWater(amount: Double) async {
        let newLog = WaterLog(amount: amount, time: Date())
        do {
            try await WaterLogService().addWaterLog(forUserID: userID, log: newLog)
            await fetchLogs()
            await updateStreak()
            await calculateDailyAverage()
        } catch {
            print("Error adding water log: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Used in HistoryView
    
    // Returns chart data for the selected time frame and date
    func getGroupedData(for date: Date, timeFrame: TimeFrame) -> [WaterConsumptionData] {
        switch timeFrame {
        case .week:
            return getDailyTotals(for: date)
        case .day:
            return getTimeSlotTotals(for: date)
        case .month:
            return getMonthlyTotals(for: date)
        }
    }
    
    // Generates a list of HistoryItem objects for a given timeframe (used in list view)
    func getHistoryItems(for date: Date, timeFrame: TimeFrame, dailyGoal: Double) -> [HistoryItem] {
        let calendar = Calendar.current
        var items: [HistoryItem] = []
        
        switch timeFrame {
        case .day:
            let logs = waterLogs.filter { calendar.isDate($0.time, inSameDayAs: date) }
            let total = logs.reduce(0) { $0 + $1.amount }
            if total > 0 {
                items.append(HistoryItem(date: date, totalAmount: total, dailyGoal: dailyGoal))
            }
            
        case .week:
            guard let startOfWeek = calendar.dateInterval(of: .weekOfYear, for: date)?.start else { return [] }
            for i in 0..<7 {
                let day = calendar.date(byAdding: .day, value: i, to: startOfWeek)!
                let logs = waterLogs.filter { calendar.isDate($0.time, inSameDayAs: day) }
                let total = logs.reduce(0) { $0 + $1.amount }
                if total > 0 {
                    items.append(HistoryItem(date: day, totalAmount: total, dailyGoal: dailyGoal))
                }
            }
            
        case .month:
            guard let range = calendar.range(of: .day, in: .month, for: date),
                  let monthStart = calendar.date(from: calendar.dateComponents([.year, .month], from: date)) else { return [] }
            
            for day in range {
                if let dayDate = calendar.date(byAdding: .day, value: day - 1, to: monthStart) {
                    let logs = waterLogs.filter { calendar.isDate($0.time, inSameDayAs: dayDate) }
                    let total = logs.reduce(0) { $0 + $1.amount }
                    if total > 0 {
                        items.append(HistoryItem(date: dayDate, totalAmount: total, dailyGoal: dailyGoal))
                    }
                }
            }
        }
        
        return items
    }
    
    // MARK: - Chart Data Helpers
    
    // Returns water totals for each day of the selected week
    private func getDailyTotals(for referenceDate: Date) -> [WaterConsumptionData] {
        let calendar = Calendar.current
        guard let weekStart = calendar.dateInterval(of: .weekOfYear, for: referenceDate)?.start else { return [] }
        
        var result: [WaterConsumptionData] = []
        
        for offset in 0..<7 {
            if let currentDate = calendar.date(byAdding: .day, value: offset, to: weekStart) {
                let dailyLogs = waterLogs.filter {
                    calendar.isDate($0.time, inSameDayAs: currentDate)
                }
                let totalAmount = dailyLogs.reduce(0) { $0 + $1.amount }
                
                let weekdayIndex = calendar.component(.weekday, from: currentDate) - 1
                let label = calendar.shortWeekdaySymbols[weekdayIndex]
                
                result.append(WaterConsumptionData(date: currentDate, amount: totalAmount, label: label))
            }
        }
        
        return result
    }
    
    // Splits a day into 6 slots (4-hour chunks) and returns consumption per slot
    private func getTimeSlotTotals(for date: Date) -> [WaterConsumptionData] {
        var slotTotals = Array(repeating: 0.0, count: 6)
        let calendar = Calendar.current
        
        for log in waterLogs {
            if calendar.isDate(log.time, inSameDayAs: date) {
                let hour = calendar.component(.hour, from: log.time)
                let slotIndex = hour / 4
                if slotIndex < 6 {
                    slotTotals[slotIndex] += log.amount
                }
            }
        }
        
        return slotTotals.enumerated().map { index, totalAmount in
            WaterConsumptionData(date: date, amount: totalAmount, label: "\(index * 4)-\(index * 4 + 4)")
        }
    }
    
    // Calculates water totals for each day of the selected month
    private func getMonthlyTotals(for date: Date) -> [WaterConsumptionData] {
        let calendar = Calendar.current
        guard let range = calendar.range(of: .day, in: .month, for: date),
              let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: date)) else { return [] }
        
        return range.map { day in
            if let currentDate = calendar.date(byAdding: .day, value: day - 1, to: startOfMonth) {
                let logs = waterLogs.filter { calendar.isDate($0.time, inSameDayAs: currentDate) }
                let totalAmount = logs.reduce(0) { $0 + $1.amount }
                return WaterConsumptionData(date: date, amount: totalAmount, label: "\(day)")
            }
            return WaterConsumptionData(date: date, amount: 0.0, label: "\(day)")
        }
    }
    
    private func fetchStreakData() async {
        do {
            let streakDoc = try await db.collection("users").document(userID).collection("streak").document("current").getDocument()
            
            if let streakData = try? streakDoc.data(as: StreakData.self) {
                self.streakData = streakData
                self.currentStreak = streakData.currentStreak
            }
        } catch {
            print("Error fetching streak data: \(error.localizedDescription)")
        }
    }
    
    // This updates the streak with logic
    
    private func updateStreak() async {
        do {
            let streakDoc = try await db.collection("users").document(userID).collection("streak").document("current").getDocument()
            var streakData = try? streakDoc.data(as: StreakData.self) ?? StreakData()
            
            let calendar = Calendar.current
            let today = calendar.startOfDay(for: Date())
            
            if let lastUpdated = streakData?.lastUpdated,
               !calendar.isDate(lastUpdated, inSameDayAs: today) {
                
                if totalConsumed >= streakData?.dailyGoal ?? 2000 {
                    streakData?.currentStreak += 1
                } else {
                    streakData?.currentStreak = 0
                }
                
                streakData?.lastUpdated = today
                
                try await db.collection("users").document(userID).collection("streak").document("current").setData([
                    "currentStreak": streakData?.currentStreak ?? 0,
                    "lastUpdated": Timestamp(date: today),
                    "dailyGoal": streakData?.dailyGoal ?? 2000
                ])
                
                self.currentStreak = streakData?.currentStreak ?? 0
            }
        } catch {
            print("Error updating streak: \(error.localizedDescription)")
        }
    }
    
    private func calculateDailyAverage() async {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let sevenDaysAgo = calendar.date(byAdding: .day, value: -7, to: today)!
        
        do {
            let logs = try await WaterLogService().fetchWaterLogs(forUserID: userID)
            let recentLogs = logs.filter { $0.time >= sevenDaysAgo }
            
            // Group logs by day
            var dailyTotals: [Date: Double] = [:]
            for log in recentLogs {
                let day = calendar.startOfDay(for: log.time)
                dailyTotals[day, default: 0] += log.amount
            }
            
            // Calculate average
            if !dailyTotals.isEmpty {
                let total = dailyTotals.values.reduce(0, +)
                self.dailyAverage = total / Double(dailyTotals.count)
                
                // Update the user's daily average in Firestore
                try await db.collection("users").document(userID).updateData([
                    "dailyAverage": self.dailyAverage
                ])
            } else {
                self.dailyAverage = 0
            }
        } catch {
            print("Error calculating daily average: \(error.localizedDescription)")
        }
    }
    
    deinit {
    }
}
