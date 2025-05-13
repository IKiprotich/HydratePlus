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
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            self.userSession = result.user
            
            // Create user document in Firestore with direct data
            let userData: [String: Any] = [
                "id": result.user.uid,
                "email": email,
                "fullname": fullname,
                "currentIntake": 0,
                "streakDays": 0,
                "memberSince": FieldValue.serverTimestamp(),
                "dailyGoal": 2000,
                "isPremium": false
            ]
            

            var retryCount = 0
            let maxRetries = 3
            
            while retryCount < maxRetries {
                do {
                    try await Firestore.firestore().collection("users").document(result.user.uid).setData(userData)
                    await fetchUser()
                    return
                } catch {
                    retryCount += 1
                    if retryCount == maxRetries {
                        // If Firestore fails, delete the Firebase Auth user
                        try? await result.user.delete()
                        self.errorMessage = "Failed to create user profile. Please try again."
                        throw error
                    }
                    try await Task.sleep(nanoseconds: UInt64(pow(2.0, Double(retryCount)) * 1_000_000_000))
                }
            }
        } catch let error as NSError {
            self.errorMessage = error.localizedDescription
            print("DEBUG: Failed to create user with error \(error.localizedDescription)")
            throw error
        }
    }
    
    //fetching user
    func fetchUser()async{
        guard let uid = Auth.auth().currentUser?.uid else{return}
        
        guard let snapshot = try? await Firestore.firestore().collection("users").document(uid).getDocument() else{return}
        self.currentUser = try? snapshot.data(as:User.self)
        
        print("DEBUG: Current user is \(self.currentUser)")
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
