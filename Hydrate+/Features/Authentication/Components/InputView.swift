//
//  InputView.swift
//  Hydrate+
//
//  Created by Ian   on 09/04/2025.
//

import SwiftUI

struct InputView: View {
    @Binding var text: String
    let Title: String
    let placeholder: String
    var isSecureField: Bool
    var iconName: String? = nil
    
    var body: some View {
        
        VStack(alignment:.leading, spacing: 6){
            HStack{
                if let iconName = iconName {
                    Image(systemName: iconName)
                        .foregroundColor(Color.waterBlue)
                        .font(.system(size: 12))

                }
                
                Text(Title)
                    .foregroundColor(Color(.darkGray))
                    .fontWeight(.semibold)
                    .font(.footnote)
                
            }
            
//input field with background
                
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.white)
                    .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
                
                if isSecureField {
                    SecureField(placeholder, text: $text)
                        .font(.system(size: 14))
                        .padding(.horizontal, 8)
                }
                else{
                    TextField(placeholder, text: $text)
                        .font(.system(size: 14))
                        .padding(.horizontal, 8)
                }
            }
            .frame(height: 36)
            
//gradient divider
            Rectangle()
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [Color.waterBlue, Color.lightBlue]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .frame(height: 1)
                .cornerRadius(0.5)
        }
        .padding(8)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.lightBlue.opacity(0.1))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.waterBlue.opacity(0.3), lineWidth: 1))
        
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
        
        InputView(
            text: .constant(""),
            Title: "Phone Number",
            placeholder: "+1234567890",
            isSecureField: false,
            iconName: "phone.fill"
        )
    }
    .padding()
    .background(Color.white)
    .previewLayout(.sizeThatFits)
}
