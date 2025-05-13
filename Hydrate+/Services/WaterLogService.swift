//
//  WaterLogService.swift
//  Hydrate+
//
//  Created by Ian   on 21/04/2025.
//

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

