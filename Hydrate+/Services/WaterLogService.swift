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
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: Date())
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!

        let snapshot = try await db
            .collection("users")
            .document(userID)
            .collection("waterLogs")
            .whereField("time", isGreaterThanOrEqualTo: Timestamp(date: startOfDay))
            .whereField("time", isLessThan: Timestamp(date: endOfDay))
            .getDocuments()

        return snapshot.documents.compactMap { doc in
            try? doc.data(as: WaterLog.self)
        }
    }

    func addWaterLog(forUserID userID: String, log: WaterLog) async throws {
        let db = Firestore.firestore()
        let _ = try await db.collection("users").document(userID).collection("waterLogs").addDocument(data: [
            "amount": log.amount,
            "time": Timestamp(date: log.time)
        ])
    }
}

