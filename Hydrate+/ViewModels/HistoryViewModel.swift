
//
//  HistoryViewModel.swift
//  Hydrate+
//
//  Created by Ian   on 22/04/2025.
//

/*
 * HistoryViewModel.swift
 * 
 * This file is a crucial component of the Hydrate+ app that manages the water consumption history
 * functionality. It serves as the ViewModel layer that:
 * 
 * 1. Fetches and maintains real-time water consumption logs from Firebase Firestore
 * 2. Provides filtered access to water logs for specific dates
 * 3. Handles the data transformation between Firestore and the app's data models
 * 
 * The ViewModel uses Firebase Authentication to ensure user-specific data access
 * and implements real-time updates through Firestore's snapshot listener.
 */


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
