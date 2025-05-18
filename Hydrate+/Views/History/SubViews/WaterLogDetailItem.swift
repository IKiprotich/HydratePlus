//
//  WaterLogDetailItem.swift
//  Hydrate+
//
//  Created by Ian   on 19/04/2025.
//

import SwiftUI

/// A view component that displays a single water intake log entry in a detailed format.
/// This component is used in the history view to show individual water consumption records
/// with their amount and timestamp in a visually appealing card format.
struct WaterLogDetailItem: View {
    /// The water log entry containing the amount consumed and timestamp
    let log: WaterLog
    
    var body: some View {
        HStack {
            // Water drop icon with a light blue background
            Image(systemName: "drop.fill")
                .font(.system(size: 16))
                .foregroundStyle(Color.blue)
                .frame(width: 32, height: 32)
                .background(Color.blue.opacity(0.1))
                .clipShape(Circle())
            
            // Main content stack showing amount and time
            VStack(alignment: .leading, spacing: 2) {
                // Displays the amount of water consumed in milliliters
                Text("\(Int(log.amount))ml")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(Color.primary)
                
                // Shows the time when the water was consumed
                Text(log.time, style: .time)
                    .font(.caption)
                    .foregroundStyle(Color.secondary)
            }
            
            Spacer()
        }
        .padding()
        // Card-like appearance with subtle shadow
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.03), radius: 5, x: 0, y: 2)
        )
    }
}

#Preview {
    WaterLogDetailItem(
        log: WaterLog(amount: 350, time: Date())
    )
    .padding()
}
