//
//  InputView.swift
//  Hydrate+
//
//  Created by Ian on 09/04/2025.
//

import SwiftUI

/// A reusable input field component that provides a consistent and interactive text input experience
/// throughout the Hydrate+ app. This view supports both regular text input and secure password input
/// with additional features like password strength indication and visibility toggle.
///
/// The component is designed to be highly customizable and provides visual feedback for user interaction,
/// making it ideal for forms, authentication screens, and any other input scenarios in the app.
struct InputView: View {
    /// The text content of the input field
    @Binding var text: String
    
    /// The label displayed above the input field
    let Title: String
    
    /// The placeholder text shown when the input is empty
    let placeholder: String
    
    /// Determines if the input should be treated as a secure field (password)
    var isSecureField: Bool
    
    /// Optional SF Symbol name for the icon to be displayed
    var iconName: String? = nil
    
    /// Tracks whether the field is currently being edited
    @State private var isEditing = false
    
    /// Controls the visibility of the password text in secure fields
    @State private var isSecureTextVisible = false
    
    /// Manages the focus state of the input field
    @FocusState private var isFocused: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Title with icon
            HStack(spacing: 6) {
                if let iconName = iconName {
                    Image(systemName: iconName)
                        .foregroundColor(isEditing ? .waterBlue : .gray)
                        .font(.system(size: 14))
                }
                
                Text(Title)
                    .foregroundColor(isEditing ? .waterBlue : .gray)
                    .fontWeight(.medium)
                    .font(.subheadline)
                    .animation(.easeInOut(duration: 0.2), value: isEditing)
            }
            
            // Input field
            HStack(spacing: 10) {
                if let iconName = iconName {
                    Image(systemName: iconName)
                        .foregroundColor(isEditing ? .waterBlue : .gray.opacity(0.7))
                        .font(.system(size: 16))
                        .frame(width: 20)
                        .animation(.easeInOut(duration: 0.2), value: isEditing)
                }
                
                if isSecureField {
                    if isSecureTextVisible {
                        TextField(placeholder, text: $text)
                            .textContentType(.password)
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                            .focused($isFocused)
                    } else {
                        SecureField(placeholder, text: $text)
                            .textContentType(.password)
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                            .focused($isFocused)
                    }
                    
                    Button(action: {
                        isSecureTextVisible.toggle()
                    }) {
                        Image(systemName: isSecureTextVisible ? "eye.slash.fill" : "eye.fill")
                            .foregroundColor(.gray)
                    }
                } else {
                    TextField(placeholder, text: $text)
                        .textContentType(Title.lowercased().contains("email") ? .emailAddress : .name)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        .focused($isFocused)
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.gray.opacity(0.1))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(isEditing ? Color.waterBlue : Color.clear, lineWidth: 1)
            )
            
            // Password strength indicator
            if !text.isEmpty && isSecureField {
                HStack {
                    Text(passwordStrength)
                        .font(.caption)
                        .foregroundColor(passwordStrengthColor)
                    
                    Spacer()
                    
                    Text("\(text.count) characters")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal, 4)
                .padding(.top, 2)
            }
        }
        .onChange(of: isFocused) { newValue in
            withAnimation {
                isEditing = newValue
            }
        }
        .onAppear {
            UIHelpers.addKeyboardDismissGesture()
        }
        .onChange(of: text) { _ in
            if !text.isEmpty {
                isEditing = true
            }
        }
    }
    
    /// Calculates and returns the password strength message based on the input length
    /// - Returns: A string indicating the password strength level
    private var passwordStrength: String {
        guard isSecureField && !text.isEmpty else { return "" }
        
        if text.count < 6 {
            return "Weak password"
        } else if text.count < 10 {
            return "Moderate password"
        } else {
            return "Strong password"
        }
    }
    
    /// Determines the color to display for the password strength indicator
    /// - Returns: A Color value representing the strength level
    private var passwordStrengthColor: Color {
        guard isSecureField && !text.isEmpty else { return .secondary }
        
        if text.count < 6 {
            return .red
        } else if text.count < 10 {
            return .orange
        } else {
            return .green
        }
    }
}

/// Preview provider for the InputView component
/// Shows examples of both regular text input and password input configurations
#Preview {
    VStack(spacing: 20) {
        InputView(
            text: .constant(""),
            Title: "Email Address",
            placeholder: "name@example.com",
            isSecureField: false,
            iconName: "envelope.fill"
        )
        
        InputView(
            text: .constant("password123"),
            Title: "Password",
            placeholder: "Enter your password",
            isSecureField: true,
            iconName: "lock.fill"
        )
    }
    .padding()
    .background(Color.white)
}
