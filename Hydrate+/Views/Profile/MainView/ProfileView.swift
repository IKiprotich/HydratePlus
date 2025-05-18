//
//  ProfileView.swift
//  Hydrate+
//
//  Created by Ian   on 11/04/2025.
//

import SwiftUI

/// ProfileView is the main profile screen of the Hydrate+ app that displays user information
/// and provides access to various settings and features. It's organized into several sections:
/// - Profile header with user information
/// - Settings section for account and app preferences
/// - App information section
/// - Account management section
struct ProfileView: View {
    /// Environment object for handling authentication state and operations
    @EnvironmentObject var viewModel: AuthViewModel
    
    /// State object for managing user data and operations
    @StateObject private var userVM = UserViewModel()
    
    /// State variable to control the edit profile sheet presentation
    @State private var showingEditProfile = false
    
    /// State variable to store any error messages that occur during profile loading
    @State private var errorMessage: String?

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 0) {
                    // MARK: - Profile Header Section
                    /// Displays the user's profile information including their photo and basic details
                    /// Includes an edit button that opens the EditProfileView sheet
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

                    // MARK: - Settings Section
                    /// Contains user preferences and settings including:
                    /// - Account settings for managing user details
                    /// - Daily water intake goal configuration
                    /// - Notification preferences
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

                    // MARK: - App Information Section
                    /// Provides access to app-related information and support:
                    /// - Help and support resources
                    /// - About section with app information
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

                    // MARK: - Account Management Section
                    /// Handles account-related actions:
                    /// - Sign out functionality
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
            // MARK: - View Styling
            /// Applies a subtle gradient background to the entire view
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
            // MARK: - Data Loading
            /// Fetches user data when the view appears
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
