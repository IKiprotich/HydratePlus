//
//  LeaderBoardView.swift
//  Hydrate+
//
//  Created by Ian   on 11/04/2025.
//

import SwiftUI
import Firebase
import FirebaseAuth

struct LeaderboardView: View {
    @StateObject private var viewModel = LeaderboardViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background gradient
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(red: 0.95, green: 0.95, blue: 1.0),
                        Color(red: 0.9, green: 0.95, blue: 1.0)
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                if viewModel.isLoading {
                    ProgressView()
                        .scaleEffect(1.5)
                } else if let error = viewModel.errorMessage {
                    VStack(spacing: 16) {
                        Image(systemName: "exclamationmark.triangle")
                            .font(.largeTitle)
                            .foregroundColor(.red)
                        Text(error)
                            .multilineTextAlignment(.center)
                            .foregroundColor(.red)
                            .padding()
                        Button("Retry") {
                            Task {
                                await viewModel.refreshLeaderboard()
                            }
                        }
                        .buttonStyle(.bordered)
                    }
                } else {
                    ScrollView {
                        VStack(spacing: 16) {
                            ForEach(Array(viewModel.entries.enumerated()), id: \.element.id) { index, entry in
                                LeaderboardRow(rank: index + 1, entry: entry)
                            }
                        }
                        .padding()
                    }
                    .refreshable {
                        await viewModel.refreshLeaderboard()
                    }
                }
            }
            .navigationTitle("Leaderboard")
        }
    }
}

struct LeaderboardRow: View {
    let rank: Int
    let entry: LeaderboardEntry
    
    var body: some View {
        HStack(spacing: 16) {
            // Rank
            Text("\(rank)")
                .font(.headline)
                .foregroundColor(.secondary)
                .frame(width: 30)
            
            // Trophy icon for top 3
            if rank <= 3 {
                Image(systemName: "trophy.fill")
                    .foregroundColor(rankColor)
                    .font(.title2)
            }
            
            // User info
            VStack(alignment: .leading, spacing: 4) {
                Text(entry.name)
                    .font(.headline)
                Text("\(Int(entry.totalConsumed))ml")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
        )
    }
    
    private var rankColor: Color {
        switch rank {
        case 1: return Color(red: 1.0, green: 0.84, blue: 0.0) // Gold
        case 2: return Color(red: 0.75, green: 0.75, blue: 0.75) // Silver
        case 3: return Color(red: 0.8, green: 0.5, blue: 0.2) // Bronze
        default: return .clear
        }
    }
}

#Preview {
    LeaderboardView()
}
