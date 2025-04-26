//
//  InputView.swift
//  Hydrate+
//
//  Created by Ian on 09/04/2025.
//

import SwiftUI

// Placeholder UIHelpers to handle keyboard dismissal


struct InputView: View {
    @Binding var text: String
    let Title: String
    let placeholder: String
    var isSecureField: Bool
    var iconName: String? = nil
    @State private var isEditing = false
    @State private var isSecureTextVisible = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
// Title with icon
            HStack(spacing: 6) {
                if let iconName = iconName {
                    Image(systemName: iconName)
                        .foregroundColor(.waterBlue)
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
                
// Text field with dynamic secure entry
                Group {
                    if isSecureField {
                        Group {
                            if isSecureTextVisible {
                                TextField(placeholder, text: $text)
                            } else {
                                SecureField(placeholder, text: $text)
                            }
                        }
                        .onTapGesture {
                            isEditing = true
                        }
                    } else {
                        TextField(placeholder, text: $text)
                            .onTapGesture {
                                isEditing = true
                            }
                    }
                }
                .font(.system(size: 16))
                .foregroundColor(.primary)
                .padding(.vertical, 12)
                .onAppear {
                    UITextField.appearance().clearButtonMode = .whileEditing
                }
                
// Show/hide password button for secure fields
                if isSecureField && !text.isEmpty {
                    Button(action: {
                        isSecureTextVisible.toggle()
                    }) {
                        Image(systemName: isSecureTextVisible ? "eye.slash.fill" : "eye.fill")
                            .foregroundColor(.waterBlue.opacity(0.7))
                            .font(.system(size: 14))
                            .padding(.trailing, 8)
                    }
                }
            }
            .padding(.horizontal, 12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(.white)
                    .shadow(color: isEditing ? .waterBlue.opacity(0.2) : .black.opacity(0.05), radius: isEditing ? 4 : 2, x: 0, y: isEditing ? 2 : 1)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isEditing ? .blue : .blue.opacity(0.2), lineWidth: isEditing ? 1.5 : 1)
            )
            .animation(.easeInOut(duration: 0.2), value: isEditing)
            .frame(height: 50)
            
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
        .onTapGesture {
            isEditing = true
        }
        .onAppear {
            // Add tap gesture recognizer to dismiss keyboard
            UIHelpers.addKeyboardDismissGesture()
        }
        .onChange(of: text) { _ in
            // Keep editing state true while typing
            if !text.isEmpty {
                isEditing = true
            }
        }
    }
    
// Password strength indicator
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
    .previewLayout(.sizeThatFits)
}
