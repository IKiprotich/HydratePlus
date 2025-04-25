//
//  HistoryViewModel.swift
//  Hydrate+
//
//  Created by Ian   on 22/04/2025.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class HistoryViewModel: ObservableObject {
    @Published var allLogs: [WaterLog] = []
    
    private var db = Firestore.firestore()
    
    func fetchLogs() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        db.collection("users")
            .document(userId)
            .collection("waterLogs")
            .order(by: "time", descending: true)
            .addSnapshotListener { snapshot, error in
                if let error = error {
                    print("Error fetching logs: \(error.localizedDescription)")
                    return
                }
                
                self.allLogs = snapshot?.documents.compactMap { doc in
                    try? doc.data(as: WaterLog.self)
                } ?? []
            }
    }
    
    func logs(for date: Date) -> [WaterLog] {
        let calendar = Calendar.current
        return allLogs.filter {
            calendar.isDate($0.time, inSameDayAs: date)
        }
    }
}
