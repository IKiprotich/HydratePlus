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


protocol AuthenticationFormProtocol {
    var formIsValid: Bool {get}
}

@MainActor
class AuthViewModel: ObservableObject{
    @Published var userSession: FirebaseAuth.User?
    @Published var currentUser: User?
    
    init(){
        self.userSession = Auth.auth().currentUser
        
        Task {
            await fetchUser()
        }
        
    }
     
    //sign in
    func signIn(withEmail email: String, password: String) async throws{
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            self.userSession = result.user
            await fetchUser()
        }catch{
            print("DEBUG: Failed to log in user with error \(error.localizedDescription)")
        }
        
    }
    
    //create user
    func createUser(withEmail email: String, password: String, fullname: String)async throws{
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            self.userSession = result.user
            let user = User(id: result.user.uid, fullname: fullname, email: email )
            
            let encodedUser = try Firestore.Encoder().encode(user)
            try await Firestore.firestore().collection("users").document(result.user.uid).setData(encodedUser)
            await fetchUser()
        }
        catch{
            print("DEBUG: Failed to create user with error \(error.localizedDescription)")
        }
        
    }
    
    
    //sign in using phone number
    func signInWithPhoneNumber(phoneNumber: String) {
        
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { // i'll need to imprve this in the future as this is a simplified flow
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
        // This is a simplified implementation that i'll to be expanded
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        
        // Create Google Sign In configuration object
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        // Start the sign in flow
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootViewController = windowScene.windows.first?.rootViewController else {
            throw NSError(domain: "Google sign in failed", code: -1)
        }
        
        do {
            let result = try await GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController)
            
            guard let idToken = result.user.idToken?.tokenString else {
                throw NSError(domain: "Failed to get ID token", code: -1)
            }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: result.user.accessToken.tokenString)
            
            let authResult = try await Auth.auth().signIn(with: credential)
            self.userSession = authResult.user
            
            // Create user document if it doesn't exist
            let fullname = result.user.profile?.name ?? ""
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
            try Auth.auth().signOut()//signs out user in the backend
            self.userSession = nil//wipes out user session and takes us back to login screen
            self.currentUser = nil//wipes out current users data model
        }
        catch{
            print("DEBUG: failed to sing out the user")
        }
    }
    func deleteAccount(){
        
    }
    func fetchUser()async{
        guard let uid = Auth.auth().currentUser?.uid else{return}
        
        guard let snapshot = try? await Firestore.firestore().collection("users").document(uid).getDocument() else{return}
        self.currentUser = try? snapshot.data(as:User.self)
        
        print("DEBUG: Current user is \(self.currentUser)")
    }
}
