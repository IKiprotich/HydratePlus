//
//  LoginView.swift
//  Hydrate+
//
//  Created by Ian on 09/04/2025.
//

/// LoginView.swift
/// This view handles the user authentication flow, providing multiple sign-in options
/// including email/password and social authentication methods (Google and Apple).
/// The view is designed with a modern, animated UI that provides a seamless login experience.

import SwiftUI

/// Main login view that handles user authentication
/// - Manages email/password authentication
/// - Provides social sign-in options (Google and Apple)
/// - Includes "Remember Me" functionality
/// - Offers password recovery option
/// - Links to registration for new users
struct LoginView: View {
    // MARK: - Properties
    /// State variables for form inputs and user preferences
    @State private var email = ""
    @State private var password = ""
    @State private var rememberMe = false
    /// Environment object that handles authentication logic
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Logo with animation
                    LogoView()
                        .frame(height: 200)
                    
                    // Input fields for email login
                    emailLoginForm
                        .padding(.vertical, 10)
                    
                    // Remember me and forgot password
                    HStack {
                        Button(action: {
                            rememberMe.toggle()
                        }) {
                            HStack(alignment: .center, spacing: 8) {
                                Image(systemName: rememberMe ? "checkmark.square.fill" : "square")
                                    .foregroundColor(rememberMe ? .waterBlue : .gray)
                                    .font(.system(size: 16))
                                
                                Text("Remember me")
                                    .font(.footnote)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .accessibilityLabel("Remember me checkbox")
                        
                        Spacer()
                        
                        // Forgot password link
                        Button {
                            // TODO: Implement forgot password functionality
                        } label: {
                            Text("Forgot Password?")
                                .font(.footnote)
                                .fontWeight(.medium)
                                .foregroundColor(.waterBlue)
                        }
                        .accessibilityLabel("Forgot password link")
                    }
                    .padding(.horizontal, 24)
                    
                    // Sign In Button
                    Button {
                        Task {
                            try await viewModel.signIn(withEmail: email, password: password)
                        }
                    } label: {
                        HStack {
                            Text("Sign In")
                                .fontWeight(.semibold)
                            Image(systemName: "arrow.right.circle.fill")
                                .font(.system(size: 16))
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 54)
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
                    .disabled(!formIsValid)
                    .opacity(formIsValid ? 1.0 : 0.6)
                    .padding(.horizontal, 24)
                    .padding(.top, 10)
                    .accessibilityLabel("Sign in button")
                    
                    // Divider with text
                    HStack {
                        Rectangle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(height: 1)
                        
                        Text("Or sign in with")
                            .font(.footnote)
                            .foregroundColor(.secondary)
                            .padding(.horizontal, 10)
                        
                        Rectangle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(height: 1)
                    }
                    .padding(.horizontal, 24)
                    .padding(.vertical, 16)
                    
                    // Social sign-in buttons
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
                        
                        // Apple button
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
                    
                    // Sign Up link
                    NavigationLink {
                        RegistrationView()
                            .navigationBarBackButtonHidden(true)
                    } label: {
                        HStack(spacing: 4) {
                            Text("Don't have an account?")
                                .foregroundColor(.secondary)
                            Text("Sign Up")
                                .fontWeight(.bold)
                                .foregroundColor(.waterBlue)
                        }
                        .font(.system(size: 15))
                    }
                    .padding(.vertical, 20)
                    .accessibilityLabel("Sign up link")
                }
                .padding(.vertical)
            }
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [.white, .lightBlue.opacity(0.3)]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
            )
        }
    }
    
    // MARK: - Email Login Form
    /// Creates the email and password input fields with validation
    /// - Returns: A VStack containing styled input fields for email and password
    private var emailLoginForm: some View {
        VStack(spacing: 16) {
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
        }
        .padding(.horizontal, 24)
    }
}

// MARK: - Logo View
/// Animated logo component that provides visual branding
/// - Displays the app logo with a pulsing animation effect
/// - Uses multiple layered circles for a modern, dynamic appearance
struct LogoView: View {
    @State private var isAnimating = false
    
    var body: some View {
        ZStack {
            Circle()
                .fill(Color.waterBlue.opacity(0.1))
                .frame(width: 140, height: 140)
                .scaleEffect(isAnimating ? 1.05 : 1.0)
            
            Circle()
                .fill(Color.waterBlue.opacity(0.2))
                .frame(width: 120, height: 120)
                .scaleEffect(isAnimating ? 1.1 : 1.0)
            
            Image("Hydrate+")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .shadow(color: Color.waterBlue.opacity(0.6), radius: isAnimating ? 8 : 6)
        }
        .onAppear {
            withAnimation(
                Animation
                    .easeInOut(duration: 1.5)
                    .repeatForever(autoreverses: true)
            ) {
                isAnimating = true
            }
        }
    }
}

// MARK: - Authentication Form Protocol
/// Protocol conformance for form validation
/// - Validates email format and password length
/// - Controls the sign-in button's enabled state
extension LoginView: AuthenticationFormProtocol {
    /// Validates the login form inputs
    /// - Returns: Boolean indicating if the form is valid
    /// - Requirements:
    ///   - Email must not be empty and contain '@'
    ///   - Password must not be empty and be longer than 5 characters
    var formIsValid: Bool {
        return !email.isEmpty &&
               email.contains("@") &&
               !password.isEmpty &&
               password.count > 5
    }
}

#Preview {
    LoginView()
        .environmentObject(AuthViewModel())
}
