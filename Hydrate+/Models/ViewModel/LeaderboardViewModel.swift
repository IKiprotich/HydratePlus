//
//  LeaderboardViewModel.swift
//  Hydrate+
//
//  Created by Ian   on 24/04/2025.
//

import Foundation

class LeaderboardViewModel: ObservableObject {
    @Published var users: [LeaderboardUser] = []
    private let service = LeaderboardService()

    func loadLeaderboard() {
        service.fetchTopUsers { [weak self] users in
            DispatchQueue.main.async {
                self?.users = users.enumerated().map { index, user in
                    var userCopy = user
                    return userCopy
                }
            }
        }
    }
}
