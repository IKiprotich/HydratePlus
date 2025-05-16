
//
//  WaterLogItem.swift
//  Hydrate+
//
//  Created by Ian   on 11/04/2025.
//


/*
 * WaterLogItem.swift
 * 
 * A SwiftUI view component that displays individual water intake log entries in the Hydrate+ app.
 * This component renders a single water log entry with:
 * - A water drop icon
 * - The amount of water consumed in milliliters
 * - The time of consumption
 * - An edit button for modifying the entry
 * 
 * The component is styled with a clean, modern design featuring:
 * - Circular icons with subtle backgrounds
 * - Card-like appearance with shadow
 * - Clear typography hierarchy
 * - Interactive edit functionality
 */



import SwiftUI

struct WaterLogItem: View {
    let log: WaterLog
    var onEdit: (() -> Void)? = nil
    
    var body: some View {
        HStack {
            Image(systemName: "drop.fill")
                .font(.system(size: 16))
                .foregroundStyle(Color.blue)
                .frame(width: 32, height: 32)
                .background(Color.blue.opacity(0.1))
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 2) {
                Text("\(Int(log.amount))ml")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(Color.primary)
                
                Text(log.timeFormatted)
                    .font(.caption)
                    .foregroundStyle(Color.secondary)
            }
            
            Spacer()
            
            Button {
                onEdit?()
            } label: {
                Image(systemName: "pencil")
                    .font(.system(size: 14))
                    .foregroundStyle(Color.gray)
                    .padding(8)
                    .background(Color.gray.opacity(0.1))
                    .clipShape(Circle())
            }
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.03), radius: 5, x: 0, y: 2)
        )
    }
}

#Preview {
    WaterLogItem(log: WaterLog(amount: 250, time: Date()))
        .padding()
}
