//
//  AuthViewModel.swift
//  Hydrate+
//
//  Created by Ian   on 09/04/2025.
//
import Foundation
import FirebaseAuth
import FirebaseFirestore
import AuthenticationServices
import FirebaseCore
import GoogleSignIn
import Network




@MainActor
class AuthViewModel: ObservableObject{
    @Published var userSession: FirebaseAuth.User?
    @Published var currentUser: User?
    @Published var errorMessage: String?
    
    init(){
        self.userSession = Auth.auth().currentUser
        
        Task {
            await fetchUser()
        }
        
    }
     
    //sign in
    func signIn(withEmail email: String, password: String) async throws {
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            self.userSession = result.user
            await fetchUser()
        } catch {
            self.errorMessage = error.localizedDescription
            print("DEBUG: Failed to log in user with error \(error.localizedDescription)")
            throw error
        }
    }
    
    //create user
    func createUser(withEmail email: String, password: String, fullname: String) async throws {
        print("DEBUG: Starting user creation process")
        
        // Validate input
        guard !email.isEmpty, email.contains("@") else {
            print("DEBUG: Invalid email format")
            self.errorMessage = "Please enter a valid email address"
            throw AuthError.invalidEmail
        }
        
        guard password.count >= 6,
              password.contains(where: { $0.isUppercase }),
              password.contains(where: { $0.isNumber }),
              password.contains(where: { "!@#$%^&*()_+-=[]{}|;:,.<>?".contains($0) }) else {
            print("DEBUG: Password validation failed")
            self.errorMessage = "Password must be at least 6 characters and contain uppercase, number, and special character"
            throw AuthError.weakPassword
        }
        
        guard !fullname.isEmpty else {
            print("DEBUG: Full name is empty")
            self.errorMessage = "Please enter your full name"
            throw AuthError.unknown("Full name is required")
        }
        
        do {
            print("DEBUG: Attempting to create Firebase Auth user")
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            print("DEBUG: Firebase Auth user created successfully with UID: \(result.user.uid)")
            self.userSession = result.user
            
            // Create user document in Firestore with direct data
            let userData: [String: Any] = [
                "id": result.user.uid,
                "email": email,
                "fullname": fullname,
                "memberSince": FieldValue.serverTimestamp(),
                "isPremium": false,
                "dailyGoal": 2000,
                "currentIntake": 0,
                "streakDays": 0,
                "dailyAverage": 0,
                "achievementsCount": 0,
                "notificationsEnabled": true,
                "darkModeEnabled": false
            ]
            
            print("DEBUG: Attempting to create Firestore user document")
            var retryCount = 0
            let maxRetries = 3
            
            while retryCount < maxRetries {
                do {
                    // Create the main user document
                    try await Firestore.firestore().collection("users").document(result.user.uid).setData(userData)
                    print("DEBUG: Firestore user document created successfully")
                    
                    // Create streak subcollection
                    try await Firestore.firestore()
                        .collection("users")
                        .document(result.user.uid)
                        .collection("streak")
                        .document("current")
                        .setData([
                            "currentStreak": 0,
                            "lastUpdated": FieldValue.serverTimestamp(),
                            "longestStreak": 0
                        ])
                    print("DEBUG: Streak document created successfully")
                    
                    // Create notifications subcollection
                    try await Firestore.firestore()
                        .collection("users")
                        .document(result.user.uid)
                        .collection("notifications")
                        .document("settings")
                        .setData([
                            "enabled": true,
                            "reminderInterval": 60, // minutes
                            "lastReminder": FieldValue.serverTimestamp()
                        ])
                    print("DEBUG: Notifications document created successfully")
                    
                    await fetchUser()
                    return
                } catch {
                    retryCount += 1
                    print("DEBUG: Firestore attempt \(retryCount) failed with error: \(error.localizedDescription)")
                    if retryCount == maxRetries {
                        print("DEBUG: All Firestore attempts failed, deleting Firebase Auth user")
                        // If Firestore fails, delete the Firebase Auth user
                        try? await result.user.delete()
                        self.errorMessage = "Failed to create user profile. Please try again."
                        throw error
                    }
                    try await Task.sleep(nanoseconds: UInt64(pow(2.0, Double(retryCount)) * 1_000_000_000))
                }
            }
        } catch let error as NSError {
            print("DEBUG: Firebase Auth error: \(error.localizedDescription), code: \(error.code)")
            switch error.code {
            case AuthErrorCode.invalidEmail.rawValue:
                self.errorMessage = "Please enter a valid email address"
                throw AuthError.invalidEmail
            case AuthErrorCode.weakPassword.rawValue:
                self.errorMessage = "Password must be at least 6 characters and contain uppercase, number, and special character"
                throw AuthError.weakPassword
            case AuthErrorCode.emailAlreadyInUse.rawValue:
                self.errorMessage = "This email is already registered. Please sign in or use a different email."
                throw AuthError.emailAlreadyInUse
            case AuthErrorCode.networkError.rawValue:
                self.errorMessage = "Network error. Please check your internet connection."
                throw AuthError.unknown("Network error")
            case AuthErrorCode.tooManyRequests.rawValue:
                self.errorMessage = "Too many attempts. Please try again later."
                throw AuthError.unknown("Too many requests")
            default:
                self.errorMessage = "An error occurred: \(error.localizedDescription)"
                throw AuthError.unknown(error.localizedDescription)
            }
        }
    }
    
    //fetching user
    func fetchUser() async {
        print("DEBUG: Starting user fetch")
        guard let uid = Auth.auth().currentUser?.uid else {
            print("DEBUG: No current user UID found")
            return
        }
        
        do {
            let snapshot = try await Firestore.firestore().collection("users").document(uid).getDocument()
            guard let data = snapshot.data() else {
                print("DEBUG: No data found in user document")
                return
            }
            
            print("DEBUG: Raw user data: \(data)")
            
            do {
                self.currentUser = try snapshot.data(as: User.self)
                print("DEBUG: User decoded successfully: \(String(describing: self.currentUser))")
            } catch {
                print("DEBUG: Error decoding user data: \(error)")
                // Fallback to manual decoding
                self.currentUser = User(
                    id: uid,
                    email: data["email"] as? String ?? "",
                    fullname: data["fullname"] as? String ?? "Unknown",
                    profileImageUrl: data["profileImageUrl"] as? String,
                    memberSince: (data["memberSince"] as? Timestamp)?.dateValue() ?? Date(),
                    isPremium: data["isPremium"] as? Bool ?? false,
                    dailyGoal: data["dailyGoal"] as? Double ?? 2000,
                    currentIntake: data["currentIntake"] as? Double ?? 0,
                    streakDays: data["streakDays"] as? Int ?? 0,
                    dailyAverage: data["dailyAverage"] as? Double ?? 0,
                    achievementsCount: data["achievementsCount"] as? Int ?? 0,
                    notificationsEnabled: data["notificationsEnabled"] as? Bool ?? true,
                    darkModeEnabled: data["darkModeEnabled"] as? Bool ?? false
                )
                print("DEBUG: User created manually: \(String(describing: self.currentUser))")
            }
            
            // Fetch streak data
            do {
                let streakSnapshot = try await Firestore.firestore()
                    .collection("users")
                    .document(uid)
                    .collection("streak")
                    .document("current")
                    .getDocument()
                print("DEBUG: Streak data fetched successfully")
            } catch {
                print("DEBUG: Error fetching streak data: \(error.localizedDescription)")
            }
            
            // Fetch notification settings
            do {
                let notificationSnapshot = try await Firestore.firestore()
                    .collection("users")
                    .document(uid)
                    .collection("notifications")
                    .document("settings")
                    .getDocument()
                print("DEBUG: Notification settings fetched successfully")
            } catch {
                print("DEBUG: Error fetching notification settings: \(error.localizedDescription)")
            }
        } catch {
            print("DEBUG: Error fetching user: \(error.localizedDescription)")
            self.errorMessage = "Error loading user data: \(error.localizedDescription)"
        }
    }
    
    
    //sign in using phone number
    func signInWithPhoneNumber(phoneNumber: String) {
        
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { // i'll need to improve this in the future as this is a simplified flow
            verificationID, error in
            if let error = error {
                print("DEBUG: Failed to start phone number auth \(error.localizedDescription)")
                return
            }
            
            UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
        }
    }
    
    //Phone verification
    func verifyPhone(code: String, fullname: String) async throws {
        guard let verificationID = UserDefaults.standard.string(forKey: "authVerificationID") else {
            throw NSError(domain: "Phone verification failed", code: -1)
        }
        
        let credential = PhoneAuthProvider.provider().credential(
            withVerificationID: verificationID,
            verificationCode: code
        )
        
        do {
            let result = try await Auth.auth().signIn(with: credential)
            self.userSession = result.user
            
            // Create user document if it doesn't exist
            let user = User(id: result.user.uid, fullname: fullname, email: result.user.phoneNumber ?? "")
            let encodedUser = try Firestore.Encoder().encode(user)
            try await Firestore.firestore().collection("users").document(user.id).setData(encodedUser)
            await fetchUser()
        } catch {
            print("DEBUG: Failed to verify phone with error \(error.localizedDescription)")
            throw error
        }
    }
    
    
    //sign in with google
    func signInWithGoogle() async throws {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootViewController = windowScene.windows.first?.rootViewController else {
            throw NSError(domain: "Google sign-in failed", code: -1, userInfo: [NSLocalizedDescriptionKey: "No root view controller available"])
        }

        do {
            // Start the Google Sign-In flow
            let result = try await GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController)
            
            guard let idToken = result.user.idToken?.tokenString else {
                throw NSError(domain: "Google sign-in failed", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to get ID token"])
            }

            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: result.user.accessToken.tokenString)
            
            // Sign in with Firebase
            let authResult = try await Auth.auth().signIn(with: credential)
            self.userSession = authResult.user
            let fullname = result.user.profile?.name ?? "Unknown"
            let email = result.user.profile?.email ?? ""
            let user = User(id: authResult.user.uid, fullname: fullname, email: email)
            
            let encodedUser = try Firestore.Encoder().encode(user)
            try await Firestore.firestore().collection("users").document(user.id).setData(encodedUser, merge: true)
            
            await fetchUser()
        } catch {
            print("DEBUG: Failed to sign in with Google: \(error.localizedDescription)")
            throw error
        }
    }
     
    
    //apple sign in
    func signInWithApple() async throws {//a placeholder
        
        
        // what to do
        // request an Apple Sign In credential
        // use that credential with firebase Auth
        // create a user document in firestore
    }
    
    //sign out
    func signOut(){
        do{
            try Auth.auth().signOut()
            self.userSession = nil
            self.currentUser = nil
        }
        catch{
            print("DEBUG: failed to sing out the user")
        }
    }
    
    
    
    //realtime updates
    

    
    //deleting user
    func deleteAccount(){
        
    }
   
}
