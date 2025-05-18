//
//  AccountSettingsView.swift
//  Hydrate+
//
//  Created by Ian   on 21/04/2025.
//

/// Hydrate+ Account Settings Module
///
/// This module provides a comprehensive account management interface for the Hydrate+ app.
/// It allows users to manage their account details, preferences, subscription status,
/// security settings, and perform account actions.
///
/// The module is structured into several key components:
/// - AccountDetailsSection: Displays user's basic information
/// - PreferencesSection: Handles units and language preferences
/// - SubscriptionSection: Manages premium subscription status
/// - SecuritySection: Handles security-related features
/// - AccountActionsSection: Provides account management actions
///
/// The interface uses a consistent blue gradient theme defined in BlueGradientScheme
/// for visual coherence across the app.

import SwiftUI

/// Defines the color scheme used throughout the account settings interface
/// This ensures consistent visual styling across the app
struct BlueGradientScheme {
    static let backgroundStart = Color.blue.opacity(0.1)
    static let backgroundEnd = Color.blue.opacity(0.3)
    static let accentStart = Color.blue
    static let accentEnd = Color.cyan
    static let cardBackground = Color.white
    static let shadow = Color.black.opacity(0.05)
}

/// Main Account Settings View
///
/// This is the primary container view that orchestrates all account-related functionality.
/// It manages the overall layout and navigation of the account settings interface,
/// including the ability to dismiss the view and handle user preferences.
struct AccountSettingsView: View {
    @ObservedObject var userVM: UserViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var showingPasswordChange = false
    @State private var showingDeleteConfirmation = false
    @State private var units = "Metric (ml)"
    @State private var language = "English"
    
    private let availableUnits = ["Metric (ml)", "Imperial (oz)"]
    private let availableLanguages = ["English", "Spanish", "French", "German", "Chinese"]
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [BlueGradientScheme.backgroundStart, BlueGradientScheme.backgroundEnd]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack(spacing: 0) {
                
                ScrollView {
                    VStack(spacing: 16) {
                        AccountDetailsSection(userVM: userVM)
                        PreferencesSection(
                            units: $units,
                            language: $language,
                            availableUnits: availableUnits,
                            availableLanguages: availableLanguages,
                            userVM: userVM
                        )
                        SubscriptionSection(userVM: userVM)
                        SecuritySection(
                            userVM: userVM,
                            showingPasswordChange: $showingPasswordChange
                        )
                        AccountActionsSection(
                            userVM: userVM,
                            showingDeleteConfirmation: $showingDeleteConfirmation
                        )
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 20)
                }
            }
        }
        .navigationTitle("Account Settings")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Done") {
                    dismiss()
                }
                .fontWeight(.medium)
                .foregroundStyle(BlueGradientScheme.accentStart)
            }
        }
        .onAppear {
            if let userUnits = userVM.user?.units {
                units = userUnits
            }
            if let userLanguage = userVM.user?.language {
                language = userLanguage
            }
        }
    }
}

/// Account Details Section
///
/// Displays the user's core account information including:
/// - Email address
/// - Full name
/// - Account creation date
///
/// This section provides users with a quick overview of their account information
/// and serves as a reference point for their account details.
struct AccountDetailsSection: View {
    @ObservedObject var userVM: UserViewModel
    
    var body: some View {
        SettingsSection(title: "Account Details") {
            SettingsInfoRow(title: "Email", value: userVM.user?.email ?? "N/A")
            SettingsInfoRow(title: "Name", value: userVM.user?.fullname ?? "N/A")
            SettingsInfoRow(title: "Member Since", value: userVM.user?.memberSince.formatted(date: .abbreviated, time: .omitted) ?? "N/A")
        }
    }
}

/// Preferences Section
///
/// Manages user preferences for the app, including:
/// - Measurement units (Metric/Imperial)
/// - Language selection
///
/// Changes to preferences are immediately synchronized with the user's account
/// through the UserViewModel.
struct PreferencesSection: View {
    @Binding var units: String
    @Binding var language: String
    let availableUnits: [String]
    let availableLanguages: [String]
    @ObservedObject var userVM: UserViewModel
    
    var body: some View {
        SettingsSection(title: "Preferences") {
            SettingsPickerRow(title: "Units", selection: $units, options: availableUnits) {
                Task { await userVM.updateUnits(units: units) }
            }
            SettingsPickerRow(title: "Language", selection: $language, options: availableLanguages) {
                Task { await userVM.updateLanguage(language: language) }
            }
        }
    }
}

/// Subscription Section
///
/// Handles the user's subscription status and premium features:
/// - Displays current subscription status (Free/Premium)
/// - Shows subscription renewal date for premium users
/// - Provides upgrade option for free users
///
/// This section is crucial for the app's monetization strategy and premium feature access.
struct SubscriptionSection: View {
    @ObservedObject var userVM: UserViewModel
    
    var body: some View {
        SettingsSection(title: "Subscription") {
            VStack(alignment: .leading, spacing: 10) {
                Text(userVM.user?.isPremium == true ? "Premium Member" : "Free Account")
                    .padding(.leading)
                    .font(.headline)
                    .accessibilityLabel(userVM.user?.isPremium == true ? "Premium" : "Free")
                
                if userVM.user?.isPremium == true {
                    Text("Your subscription renews on \(Date().addingTimeInterval(60*60*24*30).formatted(date: .abbreviated, time: .omitted))")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                
                if userVM.user?.isPremium != true {
                    Button {
                        // TO DO: Implement premium subscription flow
                    } label: {
                        HStack {
                            Image(systemName: "star.fill")
                            Text("Upgrade to Premium")
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [BlueGradientScheme.accentStart, BlueGradientScheme.accentEnd]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .padding()
                        .foregroundStyle(.white)
                        .cornerRadius(10)
                        .shadow(radius: 2)
                    }
                    .accessibilityLabel("Upgrade to premium")
                }
            }
            .padding(.vertical, 6)
        }
    }
}

/// Security Section
///
/// Manages account security features:
/// - Password change functionality
/// - Two-factor authentication settings
///
/// This section ensures users can maintain their account security
/// and protect their personal data.
struct SecuritySection: View {
    @ObservedObject var userVM: UserViewModel
    @Binding var showingPasswordChange: Bool
    
    var body: some View {
        SettingsSection(title: "Security") {
            Button {
                showingPasswordChange = true
            } label: {
                SettingsButtonRow(icon: "lock.fill", iconColor: BlueGradientScheme.accentStart, title: "Change Password")
            }
            .sheet(isPresented: $showingPasswordChange) {
                ChangePasswordView(userVM: userVM)
            }
            
            Button {
                //TO DO: Implement two-factor authentication
            } label: {
                SettingsButtonRow(icon: "shield.checkered", iconColor: .green, title: "Two-Factor Authentication", value: userVM.user?.twoFactorEnabled == true ? "Enabled" : "Disabled")
            }
        }
    }
}

/// Account Actions Section
///
/// Provides critical account management actions:
/// - Log out from all devices
/// - Account deletion
///
/// These actions require careful handling and confirmation to prevent
/// accidental data loss or security issues.
struct AccountActionsSection: View {
    @ObservedObject var userVM: UserViewModel
    @Binding var showingDeleteConfirmation: Bool
    
    var body: some View {
        SettingsSection(title: "Account Actions") {
            Button {
                userVM.logOutFromAllDevices()
            } label: {
                SettingsButtonRow(
                    icon: "person.fill.xmark",
                    iconColor: .orange,
                    title: "Log Out From All Devices"
                )
            }
            
            Button {
                showingDeleteConfirmation = true
            } label: {
                SettingsButtonRow(icon: "trash.fill", iconColor: .red, title: "Delete Account")
            }
            .alert("Delete Account", isPresented: $showingDeleteConfirmation) {
                Button("Cancel", role: .cancel) { }
                Button("Delete", role: .destructive) {
                    Task { await userVM.deleteAccount() }
                }
            } message: {
                Text("This will permanently delete your account and all associated data. This action cannot be undone.")
            }
        }
    }
}

struct AccountSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            AccountSettingsView(userVM: UserViewModel())
        }
    }
}
