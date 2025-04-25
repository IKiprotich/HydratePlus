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
    @Published var todayWaterLogs: [WaterLog] = [] // New: Logs only for today

    private var userID: String
    private var db = Firestore.firestore()

    init(userID: String) {
        self.userID = userID
    }

    // Fetch all water logs and filter today's logs
    func fetchLogs() async {
        do {
            let logs = try await WaterLogService().fetchWaterLogs(forUserID: userID)
            self.waterLogs = logs

            // Filter today's logs for the main view
            let today = Calendar.current.startOfDay(for: Date())
            self.todayWaterLogs = logs.filter { Calendar.current.isDate($0.time, inSameDayAs: today) }
            
            // Calculate the total consumed for today's water logs
            self.totalConsumed = todayWaterLogs.reduce(0) { $0 + $1.amount }
        } catch {
            print("Error fetching water logs: \(error.localizedDescription)")
        }
    }

    // Adds a new water log and updates the view accordingly
    func addWater(amount: Double) async {
        let newLog = WaterLog(amount: amount, time: Date())
        do {
            try await WaterLogService().addWaterLog(forUserID: userID, log: newLog)
            waterLogs.insert(newLog, at: 0)
            
            // If the log is today, add it to today's logs
            let today = Calendar.current.startOfDay(for: Date())
            if Calendar.current.isDate(newLog.time, inSameDayAs: today) {
                todayWaterLogs.insert(newLog, at: 0)
            }

            totalConsumed += amount
        } catch {
            print("Error adding water log: \(error.localizedDescription)")
        }
    }

    // MARK: - Used in HistoryView
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

    // MARK: - Helpers
    private func getDailyTotals(for referenceDate: Date) -> [WaterConsumptionData] {
        let calendar = Calendar.current
        guard let weekStart = calendar.dateInterval(of: .weekOfYear, for: referenceDate)?.start else { return [] }

        return (0..<7).map { offset in
            let date = calendar.date(byAdding: .day, value: offset, to: weekStart)!
            let dailyLogs = waterLogs.filter { calendar.isDate($0.time, inSameDayAs: date) }
            
            // Create WaterConsumptionData for each day
            let totalAmount = dailyLogs.reduce(0) { $0 + $1.amount }
            return WaterConsumptionData(date: date, amount: totalAmount, label: "\(calendar.shortWeekdaySymbols[offset])") // Adjust label as needed
        }
    }

    private func getTimeSlotTotals(for date: Date) -> [WaterConsumptionData] {
        // 6 time slots: 0-4, 4-8, ..., 20-24
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

        // Create WaterConsumptionData for each time slot
        return slotTotals.enumerated().map { index, totalAmount in
            WaterConsumptionData(date: date, amount: totalAmount, label: "\(index * 4)-\(index * 4 + 4)") // Example: "0-4", "4-8"
        }
    }

    private func getMonthlyTotals(for date: Date) -> [WaterConsumptionData] {
        let calendar = Calendar.current
        guard let range = calendar.range(of: .day, in: .month, for: date),
              let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: date)) else { return [] }

        return range.map { day in
            if let currentDate = calendar.date(byAdding: .day, value: day - 1, to: startOfMonth) {
                let logs = waterLogs.filter { calendar.isDate($0.time, inSameDayAs: currentDate) }
                let totalAmount = logs.reduce(0) { $0 + $1.amount }
                return WaterConsumptionData(date: date, amount: totalAmount, label: "\(day)") // Label is the day number
            }
            return WaterConsumptionData(date: date, amount: 0.0, label: "\(day)") // Return an empty data object for the day
        }
    }
}
