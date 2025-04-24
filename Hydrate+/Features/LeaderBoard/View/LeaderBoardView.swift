//
//  LeaderBoardView.swift
//  Hydrate+
//
//  Created by Ian   on 11/04/2025.
//

import SwiftUI
import Firebase

struct LeaderboardView: View {
    @State private var selectedTimeFrame: TimeFrame = .week
    @State private var selectedScope: LeaderboardScope = .friends
    @StateObject private var viewModel = LeaderboardViewModel()
    
    enum TimeFrame: String, CaseIterable, Identifiable {
        case day = "Day"
        case week = "Week"
        case month = "Month"
        
        var id: String { self.rawValue }
    }
    
    enum LeaderboardScope: String, CaseIterable, Identifiable {
        case friends = "Friends"
        case region = "Region"
        case global = "Global"
        
        var id: String { self.rawValue }
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                Picker("Time Frame", selection: $selectedTimeFrame) {
                    ForEach(TimeFrame.allCases) { timeFrame in
                        Text(timeFrame.rawValue).tag(timeFrame)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)
                
                Picker("Scope", selection: $selectedScope) {
                    ForEach(LeaderboardScope.allCases) { scope in
                        Text(scope.rawValue).tag(scope)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)
                
                // Top 3 Users Placeholder (optional: update with real data logic later)
                if viewModel.users.count >= 3 {
                    HStack(alignment: .bottom, spacing: 0) {
                        leaderboardTopUser(user: viewModel.users[1], rank: 2, color: .gray)
                        leaderboardTopUser(user: viewModel.users[0], rank: 1, color: .yellow)
                            .offset(y: -20)
                        leaderboardTopUser(user: viewModel.users[2], rank: 3, color: .brown)
                    }
                    .padding(.top, 30)
                    .padding(.bottom, 10)
                }

                List {
                    Section(header: Text("Leaderboard")) {
                        ForEach(Array(viewModel.users.enumerated()), id: \.element.id) { index, user in
                            HStack(spacing: 16) {
                                Text("\(index + 1)")
                                    .font(.headline)
                                    .foregroundColor(.secondary)
                                    .frame(width: 30)
                                
                                Image(systemName: "person.circle.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 36, height: 36)
                                    .foregroundColor(getRankColor(rank: index + 1))
                                
                                VStack(alignment: .leading) {
                                    Text(user.fullname)
                                        .font(.headline)
                                    
                                    Text("\(user.progress)% of daily goals")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                }
                                
                                Spacer()
                                
                                Text("\(user.streak) days")
                                    .font(.subheadline)
                                    .foregroundColor(.blue)
                            }
                            .padding(.vertical, 4)
                            .background(user.isCurrentUser ? Color.waterBlue.opacity(0.1) : Color.clear)
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
                viewModel.loadLeaderboard()
            }
        }
    }
    
    private func leaderboardTopUser(user: LeaderboardUser, rank: Int, color: Color) -> some View {
        VStack {
            if rank == 1 {
                Image(systemName: "crown.fill")
                    .foregroundColor(Color.yellow)
                    .offset(y: -10)
            }
            
            Image(systemName: "person.circle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: rank == 1 ? 70 : 50, height: rank == 1 ? 70 : 50)
                .foregroundColor(color)
                .padding(10)
                .background(Color.white)
                .clipShape(Circle())
                .overlay(Circle().stroke(color, lineWidth: rank == 1 ? 3 : 2))
            
            Text(user.fullname)
                .font(.subheadline)
                .fontWeight(.medium)
            
            Text("\(user.progress)%")
                .font(.caption)
                .foregroundColor(.secondary)
            
            Rectangle()
                .fill(
                    rank == 1 ?
                        LinearGradient(
                            gradient: Gradient(colors: [Color.yellow, Color.orange]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                        :
                        LinearGradient(
                            gradient: Gradient(colors: [color, color]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                )
                .frame(width: 80, height: CGFloat(100 + (3 - rank) * 20))
                .cornerRadius(8, corners: [.topLeft, .topRight])
                .overlay(
                    Text("\(rank)")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                )

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

// Extension for specific corner radius
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCornerShape(radius: radius, corners: corners))
    }
}

struct RoundedCornerShape: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

#Preview {
    LeaderboardView()
}
