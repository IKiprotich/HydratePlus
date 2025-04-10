//
//  LoginView.swift
//  Hydrate+
//
//  Created by Ian   on 09/04/2025.
//

import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var phoneNumber = ""
    @State private var selectedAuthMethod = AuthMethod.email
    @State private var showingPhoneVerification = false
    @EnvironmentObject var viewModel: AuthViewModel
    
    enum AuthMethod{
        case email
        case phone
    }
    
    var body: some View {
        NavigationStack{
            VStack{
//Logo
                Image("Hydrate+")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 100, height: 120)
                    .padding(.vertical, 24)
                    .shadow(color: Color.waterBlue.opacity(0.5), radius: 10)
                
                
//Authentication method toggle
                Picker("Authentication Method", selection: $selectedAuthMethod){
                    Text("Email").tag(AuthMethod.email)
                    Text("Phone").tag(AuthMethod.phone)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal, 24)
                .padding(.bottom, 12)
                
                
//input fields based on the selected auth method
                if selectedAuthMethod == .email{
                    emailLoginForm
                }
                else {
                    phoneLoginForm
                }
                
                
    
//Sign In Button
                Button {
                    if selectedAuthMethod == .email{
                        Task {
                            try await viewModel.signIn(withEmail: email, password: password)
                        }
                    }
                    else{
                        showingPhoneVerification = true
                        Task {
                            try await viewModel.signInWithPhoneNumber(phoneNumber: phoneNumber)
                        }
                    }
                }
                label: {
                    HStack {
                        Text("Sign In")
                            .fontWeight(.semibold)
                        Image(systemName: "arrow.right")
                    }
                    .foregroundColor(.white)
                    .frame(width: UIScreen.main.bounds.width - 32, height: 48)
                }
                .background(Color.waterBlue)
                .disabled(!formIsValid)
                .opacity(formIsValid ? 1.0 : 0.5)
                .cornerRadius(10)
                .padding(.top, 16)
                
                
//forgot passwprd link
                Button{
//I'll have to implement logic from here
                } label: {
                    Text("Forgot Password?")
                        .font(.system(size: 14))
                        .fontWeight(.medium)
                        .foregroundColor(Color.waterBlue)
                }
                .padding(.top, 16)
                
                
//or sign in with
                Text("Or sign in with")
                    .font(.footnote)
                    .foregroundColor(.secondary)
                    .padding(.vertical, 16)
                
                
//row for other ways to sign in
                HStack(spacing:24){
//google button
                    Button{
                        Task{
                            try await viewModel.signInWithGoogle()
                        }
                    } label: {
                        HStack{
                            Image("google_logo")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 20, height: 20)
                            
                            Text("Google")
                                .font(.system(size: 14))
                                .fontWeight(.medium)
                        }
                        .foregroundColor(.black)
                        .frame(width:140, height: 44)
                        .background(Color.white)
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray.opacity(0.2), lineWidth: 1))
                        
                    }
                    
                    
//apple button
                    Button{
                        Task{
                            try await viewModel.signInWithApple()
                        }
                    } label: {
                        HStack{
                            Image("Apple_logo")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 20, height: 20)
                            
                            Text("Apple")
                                .font(.system(size: 14))
                                .fontWeight(.medium)
                        }
                        .foregroundColor(.black)
                        .frame(width:140, height: 44)
                        .background(Color.white)
                        .cornerRadius(8)
                        
                    }
                }
                
                Spacer()
                
//Sign Up link
                
                NavigationLink {
                    RegistrationView()
                        .navigationBarBackButtonHidden(true)
                    
                } label: {
                    HStack(spacing: 2){
                        Text("Dont have an account?")
                            .foregroundColor(.secondary)
                        Text("Sign Up")
                            .fontWeight(.bold)
                            .foregroundColor(Color.waterBlue)
                    }
                    .font(.system(size: 14))
                    }
                .padding(.bottom, 16)
            }
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [.white, Color.lightBlue.opacity(0.3)]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .edgesIgnoringSafeArea(.all)
            )
            .sheet(isPresented: $showingPhoneVerification){
                PhoneVerificationView(phoneNumber: phoneNumber)
            }
        }
    }
    
    
//Email Login Form
    private var emailLoginForm: some View {
        VStack(spacing: 20) {
            InputView(text:$email,
                      Title: "Email Address",
                      placeholder: "name@example.com",
                      isSecureField: false,
                      iconName: "envelope.fill")
            .modifier(InputViewModifier())
                      
            InputView(text:$password,
                      Title: "Password",
                      placeholder: "Enter Your Password",
                      isSecureField: true)
                .modifier(InputViewModifier())
        }
        .padding(.horizontal)
    }
    
    
//Phone login form
    private var phoneLoginForm: some View {
        VStack(spacing: 20) {
            InputView(text:$phoneNumber,
                      Title: "Phone Number",
                      placeholder: "+1234567890",
                      isSecureField: false)
            .modifier(InputViewModifier())
            .keyboardType(.phonePad)
        }
        .padding(.horizontal)
    }
}


//MARK: - Authentication form protocol
extension LoginView: AuthenticationFormProtocol{
    var formIsValid: Bool {
        if selectedAuthMethod == .email {
            return !email.isEmpty && email.contains("@") && !password.isEmpty && password.count > 5
        }
        else{
            return !phoneNumber.isEmpty && phoneNumber.count == 10 && !password.isEmpty && password.count > 5
        }
    }
}

#Preview {
    LoginView()
}
