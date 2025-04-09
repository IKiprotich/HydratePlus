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
    
    var body: some View {
        
        VStack(alignment:.leading, spacing: 12){
            Text(Title)
                .foregroundColor(Color(.darkGray))
                .fontWeight(.semibold)
                .font(.footnote)
            if isSecureField {
                SecureField(placeholder, text: $text)
                    .font(.system(size: 14))
            }
            else{
                TextField(placeholder, text: $text)
                    .font(.system(size: 14))
            }
            Divider()
            
        }
        
    }
    
}

#Preview {
    InputView(text: .constant(""), Title: "Email Adress", placeholder: "name@example.com", isSecureField: false)
}
