//
//  WaterViewModel.swift
//  Hydrate+
//
//  Created by Ian on 11/04/2025.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

/// ViewModel responsible for managing water consumption data and related business logic
class WaterViewModel: ObservableObject {
    // MARK: - Published Properties
    
    /// The total amount of water consumed today
    @Published var totalConsumed: Double = 0
    
    /// The current streak of days meeting water goals
    @Published var currentStreak: Int = 0
    
    /// The daily average water consumption
    @Published var dailyAverage: Double = 0
    
    /// List of water consumption logs
    @Published var waterLogs: [WaterLog] = []
    
    // MARK: - Private Properties
    
    private let userID: String
    private let db = Firestore.firestore()
    
    // MARK: - Initialization
    
    init(userID: String) {
        self.userID = userID
    }
    
    // MARK: - Public Methods
    
    /// Fetches water consumption logs for the current user
    @MainActor
    func fetchLogs() async {
        do {
            let snapshot = try await db.collection("users")
                .document(userID)
                .collection("waterLogs")
                .whereField("date", isGreaterThanOrEqualTo: Calendar.current.startOfDay(for: Date()))
                .getDocuments()
            
            waterLogs = snapshot.documents.compactMap { document in
                try? document.data(as: WaterLog.self)
            }
            
            updateStats()
        } catch {
            print("Error fetching water logs: \(error)")
        }
    }
    
    /// Adds a new water consumption entry
    /// - Parameter amount: The amount of water consumed in milliliters
    @MainActor
    func addWater(amount: Double) async {
        let log = WaterLog(
            amount: amount,
            time: Date(),
            date: Date()
        )
        
        do {
            try await db.collection("users")
                .document(userID)
                .collection("waterLogs")
                .addDocument(from: log)
            
            waterLogs.append(log)
            updateStats()
        } catch {
            print("Error adding water log: \(error)")
        }
    }
    
    /// Gets grouped water consumption data for charts
    /// - Parameters:
    ///   - date: The reference date for the data
    ///   - timeFrame: The time frame to group data by
    /// - Returns: Array of WaterConsumptionData points
    func getGroupedData(for date: Date, timeFrame: TimeFrame) -> [WaterConsumptionData] {
        // Implementation details...
        return []
    }
    
    /// Gets history items for a specific date and time frame
    /// - Parameters:
    ///   - date: The reference date
    ///   - timeFrame: The time frame to get history for
    ///   - dailyGoal: The daily water consumption goal
    /// - Returns: Array of HistoryItem objects
    func getHistoryItems(for date: Date, timeFrame: TimeFrame, dailyGoal: Double) -> [HistoryItem] {
        // Implementation details...
        return []
    }
    
    // MARK: - Private Methods
    
    private func updateStats() {
        totalConsumed = waterLogs.reduce(0) { $0 + $1.amount }
        // Additional stats calculations...
    }
} 