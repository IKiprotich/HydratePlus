//
//  ProfileView.swift
//  Hydrate+
//
//  Created by Ian   on 11/04/2025.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @StateObject private var userVM = UserViewModel()
    @State private var showingEditProfile = false
    @State private var errorMessage: String?

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 0) {
// Profile Header
                    if let user = userVM.user {
                        ProfileHeaderView(user: user)
                            .overlay(
                                Button(action: { showingEditProfile = true }) {
                                    Image(systemName: "pencil.circle.fill")
                                        .font(.title2)
                                        .foregroundStyle(.white, .blue)
                                        .background(Circle().fill(.white).padding(-2))
                                }
                                .offset(x: 40, y: 40)
                                , alignment: .topTrailing
                            )
                            .sheet(isPresented: $showingEditProfile) {
                                EditProfileView(user: user, userVM: userVM)
                            }
                    } else if userVM.isLoading {
                        ProgressView("Loading Profile...")
                            .padding(.vertical, 50)
                    } else {
                        Text(errorMessage ?? "Failed to load profile")
                            .foregroundStyle(.red)
                            .padding(.vertical, 50)
                    }

// Daily Progress
                    if let user = userVM.user {
                        DailyProgressView(dailyGoal: user.dailyGoal, currentIntake: user.currentIntake)
                            .padding(.vertical, 16)
                    }

// Settings Section
                    ProfileMenuSection(title: "Settings", icon: "gearshape.fill") {
                        ProfileMenuItem(
                            icon: "person.fill",
                            iconColor: .blue,
                            title: "Account Settings",
                            subtitle: "Manage your account details"
                        ) {
                            AccountSettingsView(userVM: userVM)
                        }

                        ProfileMenuItem(
                            icon: "target",
                            iconColor: .purple,
                            title: "Daily Goal",
                            subtitle: "\(Int(userVM.user?.dailyGoal ?? 2000)) ml"
                        ) {
                            DailyGoalView(userVM: userVM)
                        }

                        ProfileMenuToggleItem(
                            icon: "bell.fill",
                            iconColor: .orange,
                            title: "Notifications",
                            subtitle: userVM.user?.notificationsEnabled == true ? "On" : "Off",
                            isOn: Binding(
                                get: { userVM.user?.notificationsEnabled ?? false },
                                set: { newValue in
                                    Task { await userVM.updateNotifications(enabled: newValue) }
                                }
                            )
                        )
                    }

// App Section
                    ProfileMenuSection(title: "App", icon: "info.circle.fill") {
                        ProfileMenuItem(
                            icon: "questionmark.circle.fill",
                            iconColor: .green,
                            title: "Help & Support",
                            subtitle: "Get assistance with Hydrate+"
                        ) {
                            HelpSupportView()
                        }

                        ProfileMenuItem(
                            icon: "info.circle.fill",
                            iconColor: .blue,
                            title: "About",
                            subtitle: "Learn more about Hydrate+"
                        ) {
                            AboutView()
                        }
                    }

// Sign Out
                    ProfileMenuSection(title: "Account", icon: "person.crop.circle.fill") {
                        ProfileMenuButtonItem(
                            icon: "arrow.right.square.fill",
                            title: "Sign Out"
                        ) {
                            Task {
                                try await viewModel.signOut()
                            }
                        }
                    }
                }
                .padding(.bottom, 20)
            }
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [.white, Color.blue.opacity(0.2)]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .edgesIgnoringSafeArea(.all)
            )
            .navigationTitle("Profile")
            .animation(.easeInOut, value: userVM.user)
            .onAppear {
                Task {
                    do {
                        try await userVM.fetchUser()
                    } catch {
                        errorMessage = "Error loading profile: \(error.localizedDescription)"
                    }
                }
            }
        }
    }
}

#Preview {
    ProfileView()
        .environmentObject(AuthViewModel())
}
