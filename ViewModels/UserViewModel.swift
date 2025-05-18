//
//  UserViewModel.swift
//  Hydrate+
//
//  Created by Ian on 11/04/2025.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

/// ViewModel responsible for managing user data and authentication state
class UserViewModel: ObservableObject {
    // MARK: - Published Properties
    
    /// The current user's data
    @Published var user: User?
    
    /// Authentication state
    @Published var isAuthenticated = false
    
    /// Loading state
    @Published var isLoading = false
    
    /// Error message if any
    @Published var errorMessage: String?
    
    // MARK: - Private Properties
    
    private let db = Firestore.firestore()
    
    // MARK: - Initialization
    
    init() {
        setupAuthStateListener()
    }
    
    // MARK: - Public Methods
    
    /// Signs in a user with email and password
    /// - Parameters:
    ///   - email: User's email address
    ///   - password: User's password
    @MainActor
    func signIn(email: String, password: String) async {
        isLoading = true
        errorMessage = nil
        
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            await fetchUserData(userId: result.user.uid)
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    /// Signs up a new user
    /// - Parameters:
    ///   - email: User's email address
    ///   - password: User's password
    ///   - fullname: User's full name
    @MainActor
    func signUp(email: String, password: String, fullname: String) async {
        isLoading = true
        errorMessage = nil
        
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            let user = User(id: result.user.uid, email: email, fullname: fullname)
            try await db.collection("users").document(user.id).setData(from: user)
            self.user = user
            isAuthenticated = true
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    /// Signs out the current user
    func signOut() {
        do {
            try Auth.auth().signOut()
            user = nil
            isAuthenticated = false
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    /// Updates the user's profile information
    /// - Parameters:
    ///   - fullname: New full name
    ///   - dailyGoal: New daily water goal
    @MainActor
    func updateProfile(fullname: String, dailyGoal: Double) async {
        guard let userId = user?.id else { return }
        
        do {
            try await db.collection("users").document(userId).updateData([
                "fullname": fullname,
                "dailyGoal": dailyGoal
            ])
            
            user?.fullname = fullname
            user?.dailyGoal = dailyGoal
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    // MARK: - Private Methods
    
    private func setupAuthStateListener() {
        Auth.auth().addStateDidChangeListener { [weak self] _, user in
            guard let self = self else { return }
            
            if let user = user {
                Task {
                    await self.fetchUserData(userId: user.uid)
                }
            } else {
                self.user = nil
                self.isAuthenticated = false
            }
        }
    }
    
    @MainActor
    private func fetchUserData(userId: String) async {
        do {
            let document = try await db.collection("users").document(userId).getDocument()
            user = try document.data(as: User.self)
            isAuthenticated = true
        } catch {
            errorMessage = error.localizedDescription
        }
    }
} 