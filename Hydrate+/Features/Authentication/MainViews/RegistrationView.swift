//
//  RegistrationView.swift
//  Hydrate+
//
//  Created by Ian on 09/04/2025.
//

import SwiftUI

// MARK: - Authentication Form Protocol
protocol AuthenticationFormProtocol {
    var formIsValid: Bool { get }
}

// MARK: - Placeholder SocialSignInButton (Assumed Component)
struct SocialSignInButton: View {
    let imageName: String
    let serviceName: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(imageName) 
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                Text(serviceName)
            }
            .frame(width: 120, height: 44)
            .background(Color.gray.opacity(0.1))
            .cornerRadius(8)
        }
        .accessibilityLabel("Sign in with \(serviceName)")
    }
}

struct RegistrationView: View {
    @State private var email = ""
    @State private var fullname = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var agreeToTerms = false
    @State private var showingPasswordRequirements = false
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
// App logo with animation
                LogoView()
                    .scaleEffect(0.8)
                    .padding(.vertical, 10)
                
// Header text
                Text("Create Your Account")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.waterBlue)
                
// Input fields for email registration
                emailRegistrationForm
                    .padding(.top, 10)
                
                // Terms and conditions checkbox
                Button(action: {
                    agreeToTerms.toggle()
                }) {
                    HStack(alignment: .top, spacing: 8) {
                        Image(systemName: agreeToTerms ? "checkmark.square.fill" : "square")
                            .foregroundColor(agreeToTerms ? .waterBlue : .gray)
                            .font(.system(size: 16))
                        
                        Text("I agree to the Terms of Service and Privacy Policy")
                            .font(.footnote)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.leading)
                    }
                    .padding(.horizontal, 26)
                }
                .accessibilityLabel("Agree to terms and conditions")
                
// Sign Up Button
                Button {
                    Task {
                        try await viewModel.createUser(
                            withEmail: email,
                            password: password,
                            fullname: fullname
                        )
                    }
                } label: {
                    HStack {
                        Text("Create Account")
                            .fontWeight(.semibold)
                        Image(systemName: "person.crop.circle.badge.plus")
                            .font(.system(size: 16))
                    }
                    .frame(width: UIScreen.main.bounds.width - 48, height: 54)
                }
                .foregroundColor(.white)
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [.waterBlue, .waterBlue.opacity(0.8)]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .cornerRadius(12)
                .shadow(color: .waterBlue.opacity(0.4), radius: 6, x: 0, y: 3)
                .disabled(!formIsValid || !agreeToTerms)
                .opacity((formIsValid && agreeToTerms) ? 1.0 : 0.6)
                .padding(.vertical, 10)
                .accessibilityLabel("Create account button")
                
// Divider with text
                HStack {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(height: 1)
                    
                    Text("Or sign up with")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                        .padding(.horizontal, 10)
                    
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(height: 1)
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 10)
                
// Social Sign Up buttons row
                HStack(spacing: 24) {
                    // Google button
                    SocialSignInButton(
                        imageName: "google_logo",
                        serviceName: "Google",
                        action: {
                            Task {
                                try await viewModel.signInWithGoogle()
                            }
                        }
                    )
                    
                    // Apple Button
                    SocialSignInButton(
                        imageName: "Apple_logo",
                        serviceName: "Apple",
                        action: {
                            Task {
                                try await viewModel.signInWithApple()
                            }
                        }
                    )
                }
                
                Spacer()
                
// Link to the sign-in view
                Button {
                    dismiss()
                } label: {
                    HStack(spacing: 4) {
                        Text("Already have an account?")
                            .foregroundColor(.secondary)
                        Text("Sign In")
                            .fontWeight(.bold)
                            .foregroundColor(.waterBlue)
                    }
                    .font(.system(size: 15))
                }
                .padding(.vertical, 20)
                .accessibilityLabel("Sign in link")
            }
            .padding(.horizontal)
        }
        .background(
            LinearGradient(
                gradient: Gradient(colors: [.white, .lightBlue.opacity(0.3)]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
        )
        .sheet(isPresented: $showingPasswordRequirements) {
            PasswordRequirementsView()
        }
    }
    
// Email Registration Form
    private var emailRegistrationForm: some View {
        VStack(spacing: 16) {
            InputView(
                text: $fullname,
                Title: "Full Name",
                placeholder: "Enter your name",
                isSecureField: false,
                iconName: "person.fill"
            )
            
            InputView(
                text: $email,
                Title: "Email Address",
                placeholder: "name@example.com",
                isSecureField: false,
                iconName: "envelope.fill"
            )
            
            InputView(
                text: $password,
                Title: "Password",
                placeholder: "Enter your password",
                isSecureField: true,
                iconName: "lock.fill"
            )
            .overlay(
                Group {
                    if !password.isEmpty {
                        HStack {
                            Spacer()
                            Button(action: {
                                showingPasswordRequirements = true
                            }) {
                                Image(systemName: "info.circle")
                                    .foregroundColor(.waterBlue)
                                    .padding(.trailing, 12)
                            }
                            .accessibilityLabel("Password requirements info")
                        }
                    }
                }
            )
            
            ZStack(alignment: .trailing) {
                InputView(
                    text: $confirmPassword,
                    Title: "Confirm Password",
                    placeholder: "Confirm your password",
                    isSecureField: true,
                    iconName: "lock.shield.fill"
                )
                
                if !password.isEmpty && !confirmPassword.isEmpty {
                    if password == confirmPassword {
                        Image(systemName: "checkmark.circle.fill")
                            .imageScale(.large)
                            .fontWeight(.bold)
                            .foregroundColor(.green)
                            .padding(.trailing, 12)
                    } else {
                        Image(systemName: "xmark.circle.fill")
                            .imageScale(.large)
                            .fontWeight(.bold)
                            .foregroundColor(.red)
                            .padding(.trailing, 12)
                    }
                }
            }
        }
        .padding(.horizontal, 24)
    }
}

// MARK: - Password Requirements View
struct PasswordRequirementsView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                Text("Password Requirements")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.waterBlue)
                
                Spacer()
                
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title3)
                        .foregroundColor(.gray)
                }
                .accessibilityLabel("Close password requirements")
            }
            .padding()
            
            VStack(alignment: .leading, spacing: 12) {
                requirement(text: "At least 6 characters long", isMet: true)
                requirement(text: "Contains at least one uppercase letter", isMet: true)
                requirement(text: "Contains at least one number", isMet: true)
                requirement(text: "Contains at least one special character", isMet: true)
            }
            .padding()
            
            Spacer()
            
            Button {
                dismiss()
            } label: {
                Text("Got it")
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(.blue)
                    .cornerRadius(10)
            }
            .padding()
            .accessibilityLabel("Dismiss password requirements")
        }
        .background(Color.white)
        .cornerRadius(20)
        .padding()
    }
    
    private func requirement(text: String, isMet: Bool) -> some View {
        HStack(spacing: 10) {
            Image(systemName: isMet ? "checkmark.circle.fill" : "xmark.circle.fill")
                .foregroundColor(isMet ? .green : .red)
            
            Text(text)
                .font(.subheadline)
                .foregroundColor(.primary)
            
            Spacer()
        }
    }
}

// MARK: - Authentication Form Protocol Conformance
extension RegistrationView: AuthenticationFormProtocol {
    var formIsValid: Bool {
        return !email.isEmpty &&
               email.contains("@") &&
               !password.isEmpty &&
               password.count >= 6 &&
               password.contains(where: { $0.isUppercase }) &&
               password.contains(where: { $0.isNumber }) &&
               password.contains(where: { "!@#$%^&*()_+-=[]{}|;:,.<>?".contains($0) }) &&
               confirmPassword == password &&
               !fullname.isEmpty
    }
}

// MARK: - Preview
#Preview {
    RegistrationView()
        .environmentObject(AuthViewModel())
}
