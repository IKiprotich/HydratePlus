//
//  UserViewModel.swift
//  Hydrate+
//
//  Created by Ian   on 21/04/2025.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseAuth

class UserViewModel: ObservableObject {
    @Published var user: User?
    @Published var isLoading = false
    @Published var errorMessage: String?

    private var listener: ListenerRegistration?

    init() {
        fetchUser()
    }

    func fetchUser() {
        guard let uid = Auth.auth().currentUser?.uid else {
            self.errorMessage = "No user is currently logged in."
            return
        }

        isLoading = true

        listener = Firestore.firestore().collection("users").document(uid)
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

    deinit {
        listener?.remove()
    }
}
