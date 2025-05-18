//
//  QuickAddButtons.swift
//  Hydrate+
//
//  Created by Ian   on 18/04/2025.
//

import SwiftUI

/// A SwiftUI view that displays a row of quick-add buttons for water intake tracking.
///
/// This view creates a horizontal stack of buttons, each representing a predefined amount of water
/// that can be quickly added to the user's daily intake. Each button displays a water drop icon
/// and the amount in milliliters.
///
/// The view is designed to be reusable and customizable through its parameters:
/// - `amounts`: An array of integers representing the different water amounts (in ml) to display
/// - `onAdd`: A closure that handles the action when a button is tapped
struct QuickAddButtons: View {
    /// Array of water amounts (in milliliters) to display as quick-add buttons
    let amounts: [Int]
    
    /// Closure that handles the action when a button is tapped
    /// - Parameter amount: The amount of water (in ml) that was selected
    let onAdd: (Int) -> Void
    
    var body: some View {
        HStack(spacing: 12) {
            ForEach(amounts, id: \.self) { amount in
                Button {
                    // Animate the button press with a spring animation for better user feedback
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                        onAdd(amount)
                    }
                } label: {
                    // Button content layout
                    VStack(spacing: 4) {
                        // Water drop icon
                        Image(systemName: "drop.fill")
                            .font(.system(size: 16))
                        
                        // Amount text
                        Text("\(amount)ml")
                            .font(.system(size: 14, weight: .medium))
                    }
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(Color.blue)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                }
            }
        }
    }
}

#Preview {
    QuickAddButtons(amounts: [250, 500, 750]) { amount in
        print("Added \(amount)ml")
    }
    .padding()
}
