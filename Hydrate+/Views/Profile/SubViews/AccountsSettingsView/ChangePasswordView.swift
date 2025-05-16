//
//  ChangePasswordView.swift
//  Hydrate+
//
//  Created by Ian   on 05/05/2025.
//

import SwiftUI

struct ChangePasswordView: View {
    @ObservedObject var userVM: UserViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var currentPassword = ""
    @State private var newPassword = ""
    @State private var confirmPassword = ""
    @State private var showError = false
    @State private var errorMessage = ""
    
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [BlueGradientScheme.backgroundStart, BlueGradientScheme.backgroundEnd]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                Form {
                    Section(header: Text("Current Password")) {
                        SecureField("Enter current password", text: $currentPassword)
                            .autocorrectionDisabled()
                            .textContentType(.password)
                    }
                    
                    Section(header: Text("New Password")) {
                        SecureField("Enter new password", text: $newPassword)
                            .autocorrectionDisabled()
                            .textContentType(.newPassword)
                        
                        SecureField("Confirm new password", text: $confirmPassword)
                            .autocorrectionDisabled()
                            .textContentType(.newPassword)
                    }
                    
                    if showError {
                        Section {
                            Text(errorMessage)
                                .foregroundStyle(.red)
                        }
                    }
                    
                    Section {
                        Button("Change Password") {
                            if newPassword != confirmPassword {
                                errorMessage = "New passwords don't match"
                                showError = true
                                return
                            }
                            
                            Task {
                                do {
                                    try await userVM.changePassword(currentPassword: currentPassword, newPassword: newPassword)
                                    dismiss()
                                } catch {
                                    errorMessage = error.localizedDescription
                                    showError = true
                                }
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .disabled(currentPassword.isEmpty || newPassword.isEmpty || confirmPassword.isEmpty)
                        .foregroundStyle(.white)
                        .padding()
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [BlueGradientScheme.accentStart, BlueGradientScheme.accentEnd]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(10)
                    }
                }
                .scrollContentBackground(.hidden)
            }
            .navigationTitle("Change Password")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundStyle(BlueGradientScheme.accentStart)
                }
            }
        }
    }
}

struct ChangePasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ChangePasswordView(userVM: UserViewModel())
    }
}
