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
            VStack(spacing: 16) {
                // Debug: Display user count
                Text("Users count: \(viewModel.users.count)")
                    .font(.caption)
                    .foregroundColor(.red)

                List {
                    Section(header: Text("Leaderboard")) {
                        ForEach(Array(viewModel.users.enumerated()), id: \.element.id) { index, user in
                            HStack(spacing: 16) {
                                Text("\(index + 1)")
                                    .font(.headline)
                                    .foregroundColor(.secondary)
                                    .frame(width: 30)

                                if let imageUrl = user.profileImageUrl {
                                    AsyncImage(url: URL(string: imageUrl)) { image in
                                        image.resizable().scaledToFit()
                                    } placeholder: {
                                        Image(systemName: "person.circle.fill")
                                    }
                                    .frame(width: 36, height: 36)
                                    .foregroundColor(getRankColor(rank: index + 1))
                                } else {
                                    Image(systemName: "person.circle.fill")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 36, height: 36)
                                        .foregroundColor(getRankColor(rank: index + 1))
                                }

                                VStack(alignment: .leading) {
                                    Text(user.fullname)
                                        .font(.headline)
                                    Text("\(Int(user.currentIntake))ml total intake")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                }

                                Spacer()

                                Text("\(user.streakDays) days")
                                    .font(.subheadline)
                                    .foregroundColor(.blue)
                            }
                            .padding(.vertical, 4)
                            .background(user.id == Auth.auth().currentUser?.uid ? Color.waterBlue.opacity(0.1) : Color.clear)
                            .cornerRadius(8)
                        }
                    }
                }
                .listStyle(InsetGroupedListStyle())
            }
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [.white, Color.lightBlue.opacity(0.2)]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .edgesIgnoringSafeArea(.all)
            )
            .navigationTitle("Leaderboard")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        // Invite action
                    } label: {
                        Image(systemName: "person.badge.plus")
                            .foregroundColor(Color.waterBlue)
                    }
                }
            }
            .onAppear {
                print("Current user: \(Auth.auth().currentUser?.uid ?? "None")")
                viewModel.loadLeaderboard()
            }
        }
    }

    private func getRankColor(rank: Int) -> Color {
        switch rank {
        case 1: return Color.yellow
        case 2: return Color.gray
        case 3: return Color.brown
        default: return Color.gray
        }
    }
}

#Preview {
    LeaderboardView()
}
