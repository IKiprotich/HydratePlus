//
//  MainTabView.swift
//  Hydrate+
//
//  Created by Ian   on 11/04/2025.
//

import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 0
    var body: some View {
        TabView(selection: $selectedTab) {
            
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "drop.fill")
                }
                .tag(0)
            
            HistoryView()
                           .tabItem {
                               Label("History", systemImage: "calendar")
                           }
                           .tag(1)
            
            LeaderboardView()
                           .tabItem {
                               Label("Leaderboard", systemImage: "trophy.fill")
                           }
                           .tag(2)
            
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.fill")
                }
                .tag(3)
        }
        .tint(Color.waterBlue)
        .onAppear {
           
            let appearance = UITabBarAppearance()
            appearance.backgroundColor = UIColor.white
            appearance.shadowColor = UIColor(Color.waterBlue.opacity(0.2))
            
            UITabBar.appearance().standardAppearance = appearance
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
    }
}

#Preview {
    MainTabView()
        .environmentObject(AuthViewModel())
}
