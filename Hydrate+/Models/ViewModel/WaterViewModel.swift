//
//  WaterViewModel.swift
//  Hydrate+
//
//  Created by Ian   on 21/04/2025.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

@MainActor
class WaterViewModel: ObservableObject {
    @Published var waterLogs: [WaterLog] = []
    @Published var totalConsumed: Double = 0.0
    private var userID: String
    private var db = Firestore.firestore()

    init(userID: String) {
        self.userID = userID
    }

    // Fetch logs from Firestore
    func fetchLogs() async {
        let logsRef = db.collection("users").document(userID).collection("waterLogs")
        do {
            let logs = try await WaterLogService().fetchWaterLogs(forUserID: userID)
            waterLogs = logs
            totalConsumed = logs.reduce(0) {$0 + $1.amount}
            
        } catch {
            print("Error fetching water logs: \(error.localizedDescription)")
        }
    }

    // Add water log to Firestore
    func addWater(amount: Double) async {
        let newLog = WaterLog(amount: amount, time: Date())
        do {
            try await WaterLogService().addWaterLog(forUserID: userID, log: newLog)
            waterLogs.insert(newLog, at: 0)
            totalConsumed += amount
        } catch {
            print("Error adding water log: \(error.localizedDescription)")
        }
    }
    
    //log water
    func logWater(amount: Double) {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        
        let db = Firestore.firestore()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let today = dateFormatter.string(from: Date())
        
        let logRef = db.collection("users").document(userID).collection("waterLogs").document(today)
        
        // Add to the total and append to entries
        logRef.getDocument { document, error in
            if let document = document, document.exists {
                var data = document.data() ?? [:]
                let currentTotal = data["total"] as? Double ?? 0
                let newTotal = currentTotal + amount
                
                var entries = data["entries"] as? [[String: Any]] ?? []
                let timeFormatter = DateFormatter()
                timeFormatter.dateFormat = "HH:mm"
                let time = timeFormatter.string(from: Date())
                
                let newEntry: [String: Any] = [
                    "amount": amount,
                    "time": time
                ]
                entries.append(newEntry)
                
                logRef.updateData([
                    "total": newTotal,
                    "entries": entries
                ])
            } else {
                // Create new document
                let timeFormatter = DateFormatter()
                timeFormatter.dateFormat = "HH:mm"
                let time = timeFormatter.string(from: Date())
                
                logRef.setData([
                    "date": today,
                    "total": amount,
                    "entries": [
                        [
                            "amount": amount,
                            "time": time
                        ]
                    ]
                ])
            }
        }
    }
}
