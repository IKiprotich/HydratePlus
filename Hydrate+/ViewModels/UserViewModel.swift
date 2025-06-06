
//
//  UserViewModel.swift
//  Hydrate+
//
//  Created by Ian   on 21/04/2025.
//


/*
 * UserViewModel.swift
 * 
 * This file serves as the core user management system for the Hydrate+ app. It handles:
 * - User profile data management and synchronization with Firebase
 * - Real-time user data updates using Firestore listeners
 * - User preferences management (daily goals, notifications, units, language)
 * - Account management operations (password changes, account deletion)
 * 
 * The ViewModel follows the MVVM pattern and uses @MainActor to ensure all UI updates
 * happen on the main thread. It maintains a single source of truth for user data
 * throughout the application and provides a clean interface for views to interact
 * with user-related functionality.
 */


import Foundation
import Firebase
import FirebaseFirestore
import FirebaseAuth

@MainActor
class UserViewModel: ObservableObject {
    @Published var user: User?
    @Published var isLoading = false
    @Published var errorMessage: String?

    private var listener: ListenerRegistration?
    private let db = Firestore.firestore()

    init() {
        fetchUser()
    }

    func fetchUser() {
        guard let uid = Auth.auth().currentUser?.uid else {
            self.errorMessage = "No user is currently logged in."
            return
        }

        isLoading = true

        listener = db.collection("users").document(uid)
            .addSnapshotListener { [weak self] snapshot, error in
                guard let self = self else { return }
                self.isLoading = false

                if let error = error {
                    self.errorMessage = "Error fetching user: \(error.localizedDescription)"
                    return
                }

                guard let document = snapshot else {
                    self.errorMessage = "User document does not exist."
                    return
                }

                do {
                    let fetchedUser = try document.data(as: User.self)
                    self.user = fetchedUser
                } catch {
                    self.errorMessage = "Error decoding user: \(error.localizedDescription)"
                }
            }
    }

    func updateUser(fullname: String, profileImageUrl: String) async {
        guard let uid = Auth.auth().currentUser?.uid else {
            self.errorMessage = "No user is currently logged in."
            return
        }

        do {
            let data: [String: Any] = [
                "fullname": fullname,
                "profileImageUrl": profileImageUrl.isEmpty ? nil : profileImageUrl
            ]
            try await db.collection("users").document(uid).updateData(data)
        } catch {
            self.errorMessage = "Error updating user: \(error.localizedDescription)"
        }
    }

    func updateDailyGoal(_ goal: Double) async {
        guard let uid = Auth.auth().currentUser?.uid else {
            self.errorMessage = "No user is currently logged in."
            return
        }

        do {
            try await db.collection("users").document(uid).updateData(["dailyGoal": goal])
        } catch {
            self.errorMessage = "Error updating daily goal: \(error.localizedDescription)"
        }
    }

    func updateDailyAverage(_ average: Double) async {
        guard let uid = Auth.auth().currentUser?.uid else {
            self.errorMessage = "No user is currently logged in."
            return
        }

        do {
            try await db.collection("users").document(uid).updateData(["dailyAverage": average])
        } catch {
            self.errorMessage = "Error updating daily average: \(error.localizedDescription)"
        }
    }

    func updateNotifications(enabled: Bool) async {
        guard let uid = Auth.auth().currentUser?.uid else {
            self.errorMessage = "No user is currently logged in."
            return
        }

        do {
            try await db.collection("users").document(uid).updateData(["notificationsEnabled": enabled])
        } catch {
            self.errorMessage = "Error updating notifications: \(error.localizedDescription)"
        }
    }
    
    // TO DO: Implement the following
    func updateUnits(units: String) async {
        print("Updating units to: \(units)")
    }
    
    func updateLanguage(language: String) async {
        print("Updating language to: \(language)")
    }
    
    func logOutFromAllDevices() {
        print("Logging out from all devices")
    }
    
    func deleteAccount() async {
        print("Deleting account")
    }
    
    func changePassword(currentPassword: String, newPassword: String) async throws {
        print("Changing password")
    }

    

    deinit {
        listener?.remove()
    }
}










    
   
