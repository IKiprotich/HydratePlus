//
//  LeaderBoardView.swift
//  Hydrate+
//
//  Created by Ian   on 11/04/2025.
//

import SwiftUI

struct LeaderboardView: View {
    @State private var selectedTimeFrame: TimeFrame = .week
    @State private var selectedScope: LeaderboardScope = .friends
    
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
                // Time frame picker
                Picker("Time Frame", selection: $selectedTimeFrame) {
                    ForEach(TimeFrame.allCases) { timeFrame in
                        Text(timeFrame.rawValue).tag(timeFrame)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)
                
                // Scope picker
                Picker("Scope", selection: $selectedScope) {
                    ForEach(LeaderboardScope.allCases) { scope in
                        Text(scope.rawValue).tag(scope)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)
                
                // Top 3 users
                HStack(alignment: .bottom, spacing: 0) {
                    // Second place
                    VStack {
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 50)
                            .foregroundColor(Color.gray)
                            .padding(10)
                            .background(Color.white)
                            .clipShape(Circle())
                            .overlay(
                                Circle()
                                    .stroke(Color.gray, lineWidth: 2)
                            )
                        
                        Text("Emma")
                            .font(.subheadline)
                            .fontWeight(.medium)
                        
                        Text("92%")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Rectangle()
                            .fill(Color.gray)
                            .frame(width: 80, height: 120)
                            .cornerRadius(8, corners: [.topLeft, .topRight])
                            .overlay(
                                Text("2")
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                            )
                    }
                    
                    // First place
                    VStack {
                        Image(systemName: "crown.fill")
                            .foregroundColor(Color.yellow)
                            .offset(y: -10)
                        
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 70, height: 70)
                            .foregroundColor(Color.waterBlue)
                            .padding(10)
                            .background(Color.white)
                            .clipShape(Circle())
                            .overlay(
                                Circle()
                                    .stroke(Color.yellow, lineWidth: 3)
                            )
                        
                        Text("You")
                            .font(.subheadline)
                            .fontWeight(.medium)
                        
                        Text("98%")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Rectangle()
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: [Color.yellow, Color.orange]),
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                            .frame(width: 80, height: 150)
                            .cornerRadius(8, corners: [.topLeft, .topRight])
                            .overlay(
                                Text("1")
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                            )
                    }
                    .offset(y: -20)
                    
                    // Third place
                    VStack {
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 50)
                            .foregroundColor(Color.brown)
                            .padding(10)
                            .background(Color.white)
                            .clipShape(Circle())
                            .overlay(
                                Circle()
                                    .stroke(Color.brown, lineWidth: 2)
                            )
                        
                        Text("Michael")
                            .font(.subheadline)
                            .fontWeight(.medium)
                        
                        Text("85%")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Rectangle()
                            .fill(Color.brown)
                            .frame(width: 80, height: 100)
                            .cornerRadius(8, corners: [.topLeft, .topRight])
                            .overlay(
                                Text("3")
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                            )
                    }
                }
                .padding(.top, 30)
                .padding(.bottom, 10)
                
                // Leaderboard list
                List {
                    Section(header: Text("Leaderboard")) {
                        ForEach(getLeaderboardItems()) { item in
                            HStack(spacing: 16) {
                                Text("\(item.rank)")
                                    .font(.headline)
                                    .foregroundColor(.secondary)
                                    .frame(width: 30)
                                
                                Image(systemName: "person.circle.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 36, height: 36)
                                    .foregroundColor(item.rank <= 3 ? getRankColor(rank: item.rank) : Color.gray)
                                
                                VStack(alignment: .leading) {
                                    Text(item.name)
                                        .font(.headline)
                                    
                                    Text("\(item.progress)% of daily goals")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                }
                                
                                Spacer()
                                
                                Text("\(item.streak) days")
                                    .font(.subheadline)
                                    .foregroundColor(Color.waterBlue)
                            }
                            .padding(.vertical, 4)
                            .background(item.isCurrentUser ? Color.waterBlue.opacity(0.1) : Color.clear)
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
                        // Add friend or invite
                    } label: {
                        Image(systemName: "person.badge.plus")
                            .foregroundColor(Color.waterBlue)
                    }
                }
            }
        }
    }
    
    // Helper methods
    private func getRankColor(rank: Int) -> Color {
        switch rank {
        case 1:
            return Color.yellow
        case 2:
            return Color.gray
        case 3:
            return Color.brown
        default:
            return Color.gray
        }
    }
    
    // Sample leaderboard items
    private func getLeaderboardItems() -> [LeaderboardItem] {
        return [
            LeaderboardItem(id: 1, rank: 4, name: "James", progress: 83, streak: 5, isCurrentUser: false),
            LeaderboardItem(id: 2, rank: 5, name: "Sophia", progress: 80, streak: 12, isCurrentUser: false),
            LeaderboardItem(id: 3, rank: 6, name: "William", progress: 78, streak: 3, isCurrentUser: false),
            LeaderboardItem(id: 4, rank: 7, name: "Olivia", progress: 75, streak: 8, isCurrentUser: false),
            LeaderboardItem(id: 5, rank: 8, name: "Noah", progress: 72, streak: 2, isCurrentUser: false),
            LeaderboardItem(id: 6, rank: 9, name: "Isabella", progress: 70, streak: 7, isCurrentUser: false),
            LeaderboardItem(id: 7, rank: 10, name: "Liam", progress: 68, streak: 4, isCurrentUser: false)
        ]
    }
}

// Model for leaderboard items
struct LeaderboardItem: Identifiable {
    let id: Int
    let rank: Int
    let name: String
    let progress: Int
    let streak: Int
    let isCurrentUser: Bool
}

// Extension to create rounded corners on specific sides
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCornerShape(radius: radius, corners: corners))
    }
}

struct RoundedCornerShape: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect,
                                byRoundingCorners: corners,
                                cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

#Preview {
    LeaderboardView()
}
