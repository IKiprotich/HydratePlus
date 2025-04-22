//
//  WaterLogService.swift
//  Hydrate+
//
//  Created by Ian   on 21/04/2025.
//
import FirebaseFirestore
import FirebaseFirestore

class WaterLogService {
    private let db = Firestore.firestore()
    
  
    func addWaterLog(forUserID userID: String, log: WaterLog) async throws {
        let docRef = db.collection("users").document(userID).collection("waterLogs").document()
        
        var newLog = log
        newLog.id = docRef.documentID
        try docRef.setData(from: newLog)
    }
    
    func fetchWaterLogs(forUserID userID: String) async throws -> [WaterLog] {
        let snapshot = try await db.collection("users").document(userID).collection("waterLogs")
            .order(by: "time", descending: true)
            .getDocuments()
        
        return try snapshot.documents.compactMap { doc in
            try doc.data(as: WaterLog.self)
        }
    }
}
