//
//  AccountSettingsView.swift
//  Hydrate+
//
//  Created by Ian   on 21/04/2025.
//

import SwiftUI

struct AccountSettingsView: View {
    @ObservedObject var userVM: UserViewModel

    var body: some View {
        Form {
            Section(header: Text("Account Details")) {
                Text("Email: \(userVM.user?.email ?? "N/A")")
                Text("Member Since: \(userVM.user?.memberSince.formatted(date: .abbreviated, time: .omitted) ?? "N/A")")
            }
            Section(header: Text("Subscription")) {
                Text(userVM.user?.isPremium == true ? "Premium Member" : "Free Account")
                if userVM.user?.isPremium != true {
                    Button("Upgrade to Premium") {
                        // TO DO: Implement premium subscription flow
                    }
                }
            }
        }
        .navigationTitle("Account Settings")
    }
}

#Preview {
    AccountSettingsView(userVM: UserViewModel())
}
