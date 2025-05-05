//
//  AccountSettingsView.swift
//  Hydrate+
//
//  Created by Ian   on 21/04/2025.
//

import SwiftUI

// Color scheme for consistent blue gradient styling
struct BlueGradientScheme {
    static let backgroundStart = Color.blue.opacity(0.1)
    static let backgroundEnd = Color.blue.opacity(0.3)
    static let accentStart = Color.blue
    static let accentEnd = Color.cyan
    static let cardBackground = Color.white
    static let shadow = Color.black.opacity(0.05)
}

// Main Account Settings View
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

// Account Details Section
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

// Preferences Section
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

// Subscription Section
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

// Security Section
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

// Account Actions Section
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
