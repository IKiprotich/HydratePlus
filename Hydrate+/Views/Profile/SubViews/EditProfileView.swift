//
//  EditProfileView.swift
//  Hydrate+
//
//  Created by Ian   on 21/04/2025.
//

import SwiftUI

struct EditProfileView: View {
    let user: User
    @ObservedObject var userVM: UserViewModel
    @State private var fullname: String
    @State private var profileImageUrl: String
    @Environment(\.dismiss) var dismiss

    init(user: User, userVM: UserViewModel) {
        self.user = user
        self.userVM = userVM
        self._fullname = State(initialValue: user.fullname)
        self._profileImageUrl = State(initialValue: user.profileImageUrl ?? "")
    }

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Personal Information")) {
                    TextField("Full Name", text: $fullname)
                    TextField("Profile Image URL", text: $profileImageUrl)
                        .autocapitalization(.none)
                }
            }
            .navigationTitle("Edit Profile")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        Task {
                            await userVM.updateUser(fullname: fullname, profileImageUrl: profileImageUrl)
                            dismiss()
                        }
                    }
                    .disabled(fullname.isEmpty)
                }
            }
        }
    }
}

#Preview {
    EditProfileView(
        user: User(
            id: "user123",
            email: "user@example.com",
            fullname: "Sarah Johnson",
            profileImageUrl: nil,
            memberSince: Date(),
            isPremium: true,
            dailyGoal: 2000,
            currentIntake: 14,
            streakDays: 7,
            achievementsCount: 1200,
            notificationsEnabled: true
        ),
        userVM: UserViewModel()
    )
}
