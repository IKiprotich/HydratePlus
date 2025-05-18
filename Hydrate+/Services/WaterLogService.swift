//
//  WaterLogService.swift
//  Hydrate+
//
//  Created by Ian   on 21/04/2025.
//

/*
 WaterLogService is a crucial service layer component that manages all water intake logging operations
 in the Hydrate+ app. It handles the following key responsibilities:
 
 1. Water Log Management:
    - Fetches user's water intake history
    - Records new water intake entries
    - Maintains chronological order of logs
 
 2. Daily Intake Tracking:
    - Updates user's current daily intake
    - Resets daily intake at appropriate intervals
    - Maintains total intake history
 
 3. Firebase Integration:
    - Manages all Firestore database operations
    - Handles batch writes for atomic operations
    - Maintains data consistency across collections
 
 This service is essential for the core functionality of Hydrate+ as it ensures
 accurate tracking and persistence of user's water consumption data.
 */

import FirebaseFirestore

struct WaterLogService {
    func fetchWaterLogs(forUserID userID: String) async throws -> [WaterLog] {
        let db = Firestore.firestore()

        let snapshot = try await db
            .collection("users")
            .document(userID)
            .collection("waterLogs")
            .order(by: "time", descending: true)
            .getDocuments()

        return snapshot.documents.compactMap { doc in
            try? doc.data(as: WaterLog.self)
        }
    }

    func addWaterLog(forUserID userID: String, log: WaterLog) async throws {
        let db = Firestore.firestore()
        
        // Starts a batch write
        let batch = db.batch()
        
        // Creates a new document with a unique ID
        let waterLogRef = db.collection("users").document(userID).collection("waterLogs").document()
        
        // Adds the water log
        batch.setData([
            "amount": log.amount,
            "time": Timestamp(date: log.time)
        ], forDocument: waterLogRef)
        
        // Gets current user document
        let userRef = db.collection("users").document(userID)
        let userDoc = try await userRef.getDocument()
        let currentIntake = userDoc.data()?["currentIntake"] as? Double ?? 0.0
        
        batch.updateData([
            "currentIntake": FieldValue.increment(log.amount)
        ], forDocument: userRef)

        try await batch.commit()
        
        print("Successfully added water log and updated currentIntake to: \(currentIntake + log.amount)")
    }

    // this function resets the daily intake
    func resetDailyIntake(forUserID userID: String) async throws {
        let db = Firestore.firestore()
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        
        let userDoc = try await db.collection("users").document(userID).getDocument()
        
        // Checks if we've already reset today
        if let lastResetTimestamp = userDoc.data()?["lastResetDate"] as? Timestamp,
           calendar.isDate(lastResetTimestamp.dateValue(), inSameDayAs: today) {
            return
        }
     
        let currentIntake = userDoc.data()?["currentIntake"] as? Double ?? 0.0
        
        try await db.collection("users").document(userID).updateData([
            "currentIntake": 0.0,
            "lastResetDate": Timestamp(date: today),
            "totalIntake": FieldValue.increment(currentIntake)
        ])
    }
}

