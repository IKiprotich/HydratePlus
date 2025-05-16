//
//  AuthService.swift
//  Hydrate+
//
//  Created by Ian   on 12/05/2025.
//

/*
 AuthService is a crucial component of the Hydrate+ app that handles all authentication-related functionality.
 
 Key responsibilities:
 - Manages user authentication state using Firebase Authentication
 - Handles user registration and sign-in processes
 - Maintains user session state
 - Stores and retrieves user data from Firestore
 - Manages user profile information including:
   * Basic user details (email, fullname)
   * Hydration tracking data (currentIntake, dailyGoal)
   * User achievements (streakDays)
   * Premium status
   * Profile image
 
 This service acts as the central authentication hub for the app, ensuring secure user management
 and providing real-time updates about the user's authentication state through @Published properties.
 */

import Foundation
import FirebaseAuth
import FirebaseFirestore

enum AuthError: Error {
    case signUpFailed(String)
    case signInFailed(String)
    case userNotFound
    case invalidEmail
    case weakPassword
    case emailAlreadyInUse
    case unknown(String)
    
    var localizedDescription: String {
        switch self {
        case .signUpFailed(let message): return "Sign up failed: \(message)"
        case .signInFailed(let message): return "Sign in failed: \(message)"
        case .userNotFound: return "User not found"
        case .invalidEmail: return "Invalid email address"
        case .weakPassword: return "Password is too weak"
        case .emailAlreadyInUse: return "Email is already in use"
        case .unknown(let message): return "Unknown error: \(message)"
        }
    }
}

class AuthService: ObservableObject {
    @Published var currentUser: User?
    @Published var isAuthenticated = false
    
    private let auth = Auth.auth()
    private let db = Firestore.firestore()
    
    init() {
        setupAuthStateListener()
    }
    
    private func setupAuthStateListener() {
        auth.addStateDidChangeListener { [weak self] _, user in
            guard let self = self else { return }
            self.isAuthenticated = user != nil
            if let user = user {
                self.fetchUserData(userId: user.uid)
            } else {
                self.currentUser = nil
            }
        }
    }
    
    func signUp(email: String, password: String, fullname: String) async throws {
        // Creates a user in Firebase Auth
        let authResult = try await createAuthUser(email: email, password: password)
        
        // Creates the user document in Firestore
        try await createUserDocument(userId: authResult.user.uid, email: email, fullname: fullname)
    }
    
    private func createAuthUser(email: String, password: String) async throws -> AuthDataResult {
        do {
            return try await auth.createUser(withEmail: email, password: password)
        } catch let error as NSError {
            switch error.code {
            case AuthErrorCode.invalidEmail.rawValue:
                throw AuthError.invalidEmail
            case AuthErrorCode.weakPassword.rawValue:
                throw AuthError.weakPassword
            case AuthErrorCode.emailAlreadyInUse.rawValue:
                throw AuthError.emailAlreadyInUse
            default:
                throw AuthError.unknown(error.localizedDescription)
            }
        }
    }
    
    private func createUserDocument(userId: String, email: String, fullname: String) async throws {
        let userData: [String: Any] = [
            "email": email,
            "fullname": fullname,
            "currentIntake": 0,
            "streakDays": 0,
            "memberSince": FieldValue.serverTimestamp(),
            "dailyGoal": 2000,
            "isPremium": false
        ]
        
        do {
            try await db.collection("users").document(userId).setData(userData)
            print("Successfully created user: \(userId)")
        } catch {
            throw AuthError.unknown("Failed to create user document: \(error.localizedDescription)")
        }
    }
    
    private func fetchUserData(userId: String) {
        let userRef = db.collection("users").document(userId)
        
        userRef.getDocument { [weak self] (documentSnapshot: DocumentSnapshot?, error: Error?) in
            guard let self = self else { return }
            
            if let error = error {
                print("Error fetching user data: \(error.localizedDescription)")
                return
            }
            
            guard let documentSnapshot = documentSnapshot,
                  let data = documentSnapshot.data() else {
                print("No user data found")
                return
            }
            
            self.currentUser = self.createUserFromData(userId: userId, data: data)
        }
    }
    
    private func createUserFromData(userId: String, data: [String: Any]) -> User {
        let email = data["email"] as? String ?? ""
        let fullname = data["fullname"] as? String ?? "Unknown"
        let profileImageUrl = data["profileImageUrl"] as? String
        let memberSince = (data["memberSince"] as? Timestamp)?.dateValue() ?? Date()
        let isPremium = data["isPremium"] as? Bool ?? false
        let dailyGoal = data["dailyGoal"] as? Double ?? 2000
        let currentIntake = data["currentIntake"] as? Double ?? 0
        let streakDays = data["streakDays"] as? Int ?? 0
        
        return User(
            id: userId,
            email: email,
            fullname: fullname,
            profileImageUrl: profileImageUrl,
            memberSince: memberSince,
            isPremium: isPremium,
            dailyGoal: dailyGoal,
            currentIntake: currentIntake,
            streakDays: streakDays
        )
    }
    
    func signOut() throws {
        do {
            try auth.signOut()
        } catch {
            throw AuthError.unknown(error.localizedDescription)
        }
    }
}
