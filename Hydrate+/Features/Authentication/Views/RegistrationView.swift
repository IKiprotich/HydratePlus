//
//  RegistrationView.swift
//  Hydrate+
//
//  Created by Ian   on 09/04/2025.
//

import SwiftUI

struct RegistrationView: View {
    @State private var email = ""
    @State private var fullname = ""
    @State private var password = ""
    @State private var confirmpassword = ""
    @State private var phoneNumber = ""
    @State private var selectedAuthMethod = AuthMethod.email
    @State private var showingPhoneVerification = false
    
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: AuthViewModel
    
    
    enum AuthMethod{
        case email
        case phone
    }
    
    
    var body: some View {
        VStack{
            //App logo
            Image("Hydrate+")
                .resizable()
                .scaledToFill()
                .frame(width: 100, height: 120)
                .padding(.vertical, 32)
            
            
            VStack(spacing: 24){
                InputView(text: $email,
                          Title: "Email Address",
                          placeholder: "name@example.com",
                          isSecureField: false)
                
                InputView(text: $fullname,
                          Title: "Full Name",
                          placeholder: "Enter Your Name",
                          isSecureField: false)
                
                InputView(text: $password,
                          Title: "Password",
                          placeholder: "Enter your password",
                          isSecureField: true)
                
                ZStack(alignment: .trailing){
                    InputView(text: $confirmpassword,
                              Title: "Confirm Password",
                              placeholder: "Confirm your password",
                              isSecureField: true)
                    
                    if !password.isEmpty && !confirmpassword.isEmpty {
                        if password == confirmpassword {
                            Image(systemName: "checkmark.circle.fill")
                                .imageScale(.large)
                                .fontWeight(.bold)
                                .foregroundColor(.green)
                        }else{
                            Image(systemName: "xmark.circle.fill")
                                .imageScale(.large)
                                .fontWeight(.bold)
                                .foregroundColor(.red)
                        }
                    }
                    
                }
            }
            .padding(.horizontal)
            .padding(.top, 12)
            
            Button {
                Task{
                    try await viewModel.createUser(withEmail: email,
                                                   password: password,
                                                   fullname: fullname)
                }
            }
            label: {
                HStack {
                    Text("Sign up")
                        .fontWeight(.semibold)
                    Image(systemName: "arrow.right")
                }
                .foregroundColor(.white)
                .frame(width: UIScreen.main.bounds.width - 32, height: 48)
            }
            .background(Color(.black))
            .disabled(!formIsValid)
            .opacity(formIsValid ? 1.0 : 0.5)
            .cornerRadius(10)
            .padding(.top, 24)
            
            
            Spacer()
            
            Button {
                dismiss()
            }
            label: {
                HStack(spacing: 2){
                    Text("Already have an account?")
                    Text("Sign In")
                        .fontWeight(.bold)
                }
                .font(.system(size: 14))
                
            }
        }
    }
}
//MARK: - Authentication form protocol
extension RegistrationView: AuthenticationFormProtocol{
    var formIsValid: Bool {
        return !email.isEmpty
        && email.contains("@")
        && !password.isEmpty
        && password.count > 5
        && confirmpassword == password
        && !fullname.isEmpty
    }
}
#Preview {
    RegistrationView()
}
