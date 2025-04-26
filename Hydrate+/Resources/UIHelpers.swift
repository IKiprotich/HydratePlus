//
//  UIHelpers.swift
//  Hydrate+
//
//  Created by Ian   on 26/04/2025.
//
//
//  UIHelpers.swift
//  Hydrate+
//
//  Created by Ian on 26/04/2025.
//

import SwiftUI
import UIKit

// Helper functions for UI interactions
struct UIHelpers {
    // Function to add a keyboard dismiss gesture to the view
    static func addKeyboardDismissGesture() {
        let tapGesture = UITapGestureRecognizer(
            target: UIApplication.shared.windows.first { $0.isKeyWindow }?.rootViewController,
            action: #selector(UIViewController.dismissKeyboard)
        )
        tapGesture.cancelsTouchesInView = false
        UIApplication.shared.windows.first { $0.isKeyWindow }?.addGestureRecognizer(tapGesture)
    }
    
    // Returns the screen width for adaptive layouts
    static var screenWidth: CGFloat {
        UIScreen.main.bounds.width
    }
    
    // Returns the screen height for adaptive layouts
    static var screenHeight: CGFloat {
        UIScreen.main.bounds.height
    }
    
    // Function to create a button with the app's standard style
    static func standardButton(title: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack {
                Text(title)
                    .fontWeight(.semibold)
                Image(systemName: "arrow.right")
            }
            .foregroundColor(.white)
            .frame(width: UIScreen.main.bounds.width - 32, height: 48)
            .background(Color.waterBlue)
            .cornerRadius(10)
        }
    }
    
    // Validate email format
    static func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
}

// Extension for keyboard dismissal
extension UIViewController {
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

// Common ViewModifiers
struct InputViewModifier: ViewModifier {
    var isActive: Bool = false
    
    func body(content: Content) -> some View {
        content
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.white)
                    .shadow(
                        color: isActive ? Color.waterBlue.opacity(0.2) : Color.black.opacity(0.05),
                        radius: isActive ? 4 : 2,
                        x: 0,
                        y: isActive ? 2 : 1
                    )
            )
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(
                        isActive ? Color.waterBlue : Color.waterBlue.opacity(0.3),
                        lineWidth: isActive ? 1.5 : 1
                    )
            )
    }
}
