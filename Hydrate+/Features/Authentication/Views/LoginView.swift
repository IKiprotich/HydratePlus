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
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        NavigationStack{
            VStack{
                //Image or Logo
                Image("Hydrate+")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 100, height: 120)
                    .padding(.vertical, 32)
                  
                
                //Form Fields
                VStack(spacing: 24){
                    InputView(text: $email,
                              Title: "Email Address",
                              placeholder: "name@example.com", isSecureField: false)
                    
                    InputView(text: $password,
                              Title: "Password",
                              placeholder: "Enter your password", isSecureField: true)
                    
                }
                .padding(.horizontal)
                .padding(.top, 12)
                
                //Sign In Button
                
                Button {
                    Task{
                        try await viewModel.signIn(withEmail: email, password: password)
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
                .background(Color(.black))
                .disabled(!formIsValid)
                .opacity(formIsValid ? 1.0 : 0.5)
                .cornerRadius(10)
                .padding(.top, 24)
                
                Spacer()
                
                //Sign Up button
                
                NavigationLink {
                    RegistrationView()
                        .navigationBarBackButtonHidden(true)
                    
                } label: {
                    HStack(spacing: 2){
                        Text("Dont have an account?")
                        Text("Sign Up")
                            .fontWeight(.bold)
                    }
                    .font(.system(size: 14))
                    }
                
            }
        }
    }
}
//MARK: - Authentication form protocol
extension LoginView: AuthenticationFormProtocol{
    var formIsValid: Bool {
        return !email.isEmpty && email.contains("@") && !password.isEmpty && password.count > 5
    }
}
#Preview {
    LoginView()
}
