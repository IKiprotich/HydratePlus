//
//  LeaderBoardViewModel.swift
//  Hydrate+
//
//  Created by Ian   on 07/05/2025.
//

/*
 * LeaderboardViewModel
 * -------------------
 * This ViewModel is a crucial component of Hydrate+ that manages the real-time leaderboard functionality.
 * It handles:
 * - Real-time synchronization of user water intake data from Firestore
 * - Sorting users by their water consumption
 * - Providing a live-updating list of leaderboard entries
 * - Error handling and loading states for the UI
 * 
 * The ViewModel uses Firebase's real-time listeners to ensure the leaderboard
 * stays current without requiring manual refreshes, while also providing
 * a manual refresh option for users.
 */

import Foundation
import FirebaseFirestore
import Combine

@MainActor
class LeaderboardViewModel: ObservableObject {
    @Published var entries: [LeaderboardEntry] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let db = Firestore.firestore()
    private var listener: ListenerRegistration?
    
    init() {
        setupRealtimeListener()
    }
    
    private func setupRealtimeListener() {
        listener?.remove()
        
        listener = db.collection("users")
            .order(by: "currentIntake", descending: true)
            .addSnapshotListener { [weak self] snapshot, error in
                guard let self = self else { return }
                
                if let error = error {
                    self.errorMessage = "Failed to fetch leaderboard: \(error.localizedDescription)"
                    print("Error fetching leaderboard: \(error.localizedDescription)")
                    return
                }
                
                guard let documents = snapshot?.documents else {
                    self.errorMessage = "No data available"
                    return
                }
                
                print("Fetched \(documents.count) documents from Firestore")
                
                self.entries = documents.compactMap { document in
                    let data = document.data()
                    print("Processing document \(document.documentID) with data: \(data)")
                    let fullname = data["fullname"] as? String ?? data["name"] as? String ?? "Anonymous"
                    let currentIntake = data["currentIntake"] as? Double ?? 0.0
                    
                    return LeaderboardEntry(
                        id: document.documentID,
                        name: fullname,
                        totalConsumed: currentIntake
                    )
                }
                
                print("Updated leaderboard with \(self.entries.count) entries")
            }
    }
    
    func refreshLeaderboard() async {
        isLoading = true
        errorMessage = nil
        
        do {
            let snapshot = try await db.collection("users")
                .order(by: "currentIntake", descending: true)
                .getDocuments()
            
            print("Fetched \(snapshot.documents.count) documents from Firestore")
            
            entries = snapshot.documents.compactMap { document in
                let data = document.data()
                print("Processing document \(document.documentID) with data: \(data)")
                let fullname = data["fullname"] as? String ?? data["name"] as? String ?? "Anonymous"
                let currentIntake = data["currentIntake"] as? Double ?? data["waterIntake"] as? Double ?? 0.0
                
                return LeaderboardEntry(
                    id: document.documentID,
                    name: fullname,
                    totalConsumed: currentIntake
                )
            }
            
            print("Updated leaderboard with \(entries.count) entries")
        } catch {
            errorMessage = "Failed to refresh leaderboard: \(error.localizedDescription)"
            print("Error refreshing leaderboard: \(error.localizedDescription)")
        }
        
        isLoading = false
    }
    
    deinit {
        listener?.remove()
    }
}
