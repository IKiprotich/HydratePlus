//
//  WaterIntakeService.swift
//  Hydrate+
//
//  Created by Ian   on 12/05/2025.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class WaterIntakeService: ObservableObject {
    private let db = Firestore.firestore()
    
    func logWaterIntake(amount: Double) async throws {
        guard let userId = Auth.auth().currentUser?.uid else {
            throw NSError(domain: "WaterIntakeService", code: 1, userInfo: [NSLocalizedDescriptionKey: "User not authenticated"])
        }
        
        let today = Calendar.current.startOfDay(for: Date())
        let intakeRef = db.collection("users").document(userId)
            .collection("waterIntake").document(today.formatted(date: .numeric, time: .omitted))
        
        // Get current intake for today
        let currentDoc = try await intakeRef.getDocument()
        let currentIntake = currentDoc.exists ? (currentDoc.data()?["amount"] as? Double ?? 0) : 0
        
        // Update today's intake
        try await intakeRef.setData([
            "amount": currentIntake + amount,
            "lastUpdated": FieldValue.serverTimestamp(),
            "date": today
        ], merge: true)
        
        // Update user's total intake
        try await db.collection("users").document(userId).updateData([
            "currentIntake": FieldValue.increment(amount)
        ])
    }
    
    func getWaterIntakeHistory(days: Int = 7) async throws -> [(date: Date, amount: Double)] {
        guard let userId = Auth.auth().currentUser?.uid else {
            throw NSError(domain: "WaterIntakeService", code: 1, userInfo: [NSLocalizedDescriptionKey: "User not authenticated"])
        }
        
        let calendar = Calendar.current
        let endDate = calendar.startOfDay(for: Date())
        let startDate = calendar.date(byAdding: .day, value: -(days - 1), to: endDate)!
        
        let snapshot = try await db.collection("users").document(userId)
            .collection("waterIntake")
            .whereField("date", isGreaterThanOrEqualTo: startDate)
            .whereField("date", isLessThanOrEqualTo: endDate)
            .getDocuments()
        
        return snapshot.documents.compactMap { doc in
            guard let date = doc.data()["date"] as? Date,
                  let amount = doc.data()["amount"] as? Double else {
                return nil
            }
            return (date: date, amount: amount)
        }.sorted { $0.date < $1.date }
    }
}
