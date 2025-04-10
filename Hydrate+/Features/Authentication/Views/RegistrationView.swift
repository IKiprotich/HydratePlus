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
                .shadow(color: Color.waterBlue.opacity(0.5), radius: 10)
            
            
            //Authentication Method toggle
            Picker("Authentication Method", selection: $selectedAuthMethod) {
                Text("Email").tag(AuthMethod.email)
                Text("Phone").tag(AuthMethod.phone)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal, 24)
            .padding(.bottom, 12)
            
            
            //Input fields based on the selected auth method
            if selectedAuthMethod == .email{
                emailRegistrationForm
            }
            else{
                phoneRegistrationForm
            }
            
            //Sign Up Button
            Button {
                if selectedAuthMethod == .email {
                    Task {
                        try await viewModel.createUser(withEmail: email,
                                                       password: password,
                                                       fullname: fullname)
                    }
                }
                
                else {
                    showingPhoneVerification = true //this implements the phone verification logic in the authviewmodel
                }
            } label: {
                HStack{
                    Text("Sign Up")
                        .fontWeight(.semibold)
                    Image(systemName: "arrow.right")
                }
                .foregroundColor(.white)
                .frame(width: UIScreen.main.bounds.width - 32, height: 48)
            }
            .background(Color.waterBlue)
            .disabled(!formIsValid)
            .opacity(!formIsValid ? 1.0 : 0.5)
            .cornerRadius(8.0)
            .padding(.top, 12)
            
            
            //Or Sign up with text
            Text("Or sign up with")
                .font(.footnote)
                .foregroundColor(.secondary)
                .padding(.top, 16)
            
            
            //Social Sign In buttons row
            HStack(spacing:24){
                
                
                //Google button
                Button{
                    Task{//it should implement google authentication
                        try await viewModel.signInWithGoogle()
                    }
                } label: {
                    HStack{
                        Image("google_logo")
                            .resizable()
                            .scaledToFit()
                            .frame(width:20, height: 20)
                        
                        Text("Google")
                            .font(.system(size: 14))
                            .fontWeight(.medium)
                    }
                    .foregroundColor(.black)
                    .frame(width: 112, height: 44)
                    .background(Color.white)
                    .cornerRadius(8)
                    .overlay( RoundedRectangle(cornerRadius:8).stroke(Color.gray.opacity(0.3), lineWidth: 1))
                }
                
                //Apple Button
                Button{
                    Task{//it should implement google authentication
                        try await viewModel.signInWithApple()
                    }
                } label: {
                    HStack{
                        Image("apple_logo")
                            .resizable()
                            .scaledToFit()
                            .frame(width:20, height: 20)
                        
                        Text("Apple")
                            .font(.system(size: 14))
                            .fontWeight(.medium)
                    }
                    .foregroundColor(.black)
                    .frame(width: 112, height: 44)
                    .background(Color.white)
                    .cornerRadius(8)
                }
            }
            .padding(.bottom, 16)
            
            Spacer()
            
            //Link to the sign in view
            Button {
                dismiss()
            }
            label: {
                HStack(spacing: 2){
                    Text("Already have an account?")
                        .foregroundColor(.secondary)
                    Text("Sign In")
                        .fontWeight(.bold)
                        .foregroundColor(Color.waterBlue)
                }
                .font(.system(size: 14))
            }
            .padding(.bottom, 16)
        }
        .background(
            LinearGradient(gradient:Gradient(colors: [.white, Color.lightBlue.opacity(0.3)]),
                           startPoint: .top,
                           endPoint: .bottom
                          )
            .edgesIgnoringSafeArea(.all)
        )
        .sheet(isPresented: $showingPhoneVerification) {
            PhoneVerificationView(phoneNumber: phoneNumber)
        }
    }
    
    //Email registration Form
    private var emailRegistrationForm: some View {
        VStack(spacing: 24){
            InputView(text: $email,
                      Title: "Email Address",
                      placeholder: "name@example.com",
                      isSecureField: false)
            .modifier(InputViewModifier())
            
            InputView(text: $fullname,
                      Title: "Full Name",
                      placeholder: "Enter Your Name",
                      isSecureField: false)
            .modifier(InputViewModifier())
            
            InputView(text: $password,
                      Title: "Password",
                      placeholder: "Enter your password",
                      isSecureField: true)
            .modifier(InputViewModifier())
            
            ZStack(alignment: .trailing){
                InputView(text: $confirmpassword,
                          Title: "Confirm Password",
                          placeholder: "Confirm your password",
                          isSecureField: true)
                .modifier(InputViewModifier())
                
                if !password.isEmpty && !confirmpassword.isEmpty {
                    if password == confirmpassword {
                        Image(systemName: "checkmark.circle.fill")
                            .imageScale(.large)
                            .fontWeight(.bold)
                            .foregroundColor(.green)
                            .padding(.trailing, 8)
                    }else{
                        Image(systemName: "xmark.circle.fill")
                            .imageScale(.large)
                            .fontWeight(.bold)
                            .foregroundColor(.red)
                            .padding(.trailing, 8)
                    }
                }
                
            }
        }
        .padding(.horizontal)
    }
    
    //Phone Registration form
    private var phoneRegistrationForm: some View {
        VStack(spacing: 20) {
            InputView(text: $phoneNumber,
                      Title: "Phone Number",
                      placeholder: "+254712345678",
                      isSecureField: false)
            .modifier(InputViewModifier())
            .keyboardType(.phonePad)
            
            InputView(text: $fullname,
                      Title: "Full Name",
                      placeholder: "Enter Your Name",
                      isSecureField: false)
            .modifier(InputViewModifier())
        }
        .padding(.horizontal)
    }
}
 

//MARK: - Input View Modifier
struct InputViewModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(
                RoundedRectangle(cornerRadius: 10)
                .fill(Color.white)
                .shadow(color: Color.waterBlue.opacity(0.1), radius: 5, x: 0, y: 2))
    }
}
            
           
//MARK: - Authentication form protocol
extension RegistrationView: AuthenticationFormProtocol{
    var formIsValid: Bool {
        if selectedAuthMethod == .email {
            return !email.isEmpty
            && email.contains("@")
            && !password.isEmpty
            && password.count > 5
            && confirmpassword == password
            && !fullname.isEmpty
        }
        else{
            return !phoneNumber.isEmpty
            && phoneNumber.count == 10
            && !fullname.isEmpty
        }
    }
}


//MARK: - Phone Verification View
struct PhoneVerificationView: View {
    let phoneNumber: String
    @State private var verificationCode = ""
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(spacing: 24) {
            Text("Verify Your Phone")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(Color.waterBlue)
            
            Text("We sent a verification code to \(phoneNumber)")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            // Verification code input
            HStack(spacing: 12) {
                ForEach(0..<6) { index in
                    OTPTextField(index: index, verificationCode: $verificationCode)
                }
            }
            .padding(.vertical, 24)
            
            Button {
                // to implement verification logic
                dismiss()
            } label: {
                Text("Verify")
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(width: 200, height: 48)
                    .background(Color.waterBlue)
                    .cornerRadius(10)
            }
            .disabled(verificationCode.count < 6)
            .opacity(verificationCode.count < 6 ? 0.5 : 1.0)
            
            Button {
                // to implement resend code logic
                
            } label: {
                Text("Resend Code")
                    .font(.footnote)
                    .fontWeight(.medium)
                    .foregroundColor(Color.waterBlue)
            }
            .padding(.top, 8)
            
            Spacer()
        }
        .padding()
        .background(
            LinearGradient(
                gradient: Gradient(colors: [.white, Color.lightBlue.opacity(0.3)]),
                startPoint: .top,
                endPoint: .bottom
            )
            .edgesIgnoringSafeArea(.all)
        )
    }
}


//MARK: - OTP TextField
struct OTPTextField: View {
    let index: Int
    @Binding var verificationCode: String
    
    var body: some View {
        ZStack {
            if verificationCode.count > index {
                let startIndex = verificationCode.startIndex
                let charIndex = verificationCode.index(startIndex, offsetBy: index)
                Text(String(verificationCode[charIndex]))
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(Color.waterBlue)
            }
        }
        .frame(width: 44, height: 44)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.waterBlue, lineWidth: 1)
                .background(Color.white.cornerRadius(8))
        )
    }
}

#Preview {
    RegistrationView()
        .environmentObject(AuthViewModel())
}
