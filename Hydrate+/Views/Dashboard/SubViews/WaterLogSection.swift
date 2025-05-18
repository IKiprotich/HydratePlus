//
//  WaterLogSection.swift
//  Hydrate+
//
//  Created by Ian   on 18/04/2025.
//

import SwiftUI

/// A SwiftUI view component that displays a user's water intake log for the current day.
/// This section is part of the main dashboard and provides a quick overview of water consumption
/// along with the ability to add new entries.
///
/// The view consists of three main parts:
/// 1. A header with the section title and a "View All" button
/// 2. A scrollable list of water log entries
/// 3. Quick-add buttons for common water amounts
struct WaterLogSection: View {
    /// Array of water log entries to be displayed
    let logs: [WaterLog]
    
    /// Callback function triggered when the "View All" button is pressed
    let onViewAll: () -> Void
    
    /// Callback function triggered when a quick-add amount is selected
    let onAddAmount: (Int) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Section header with title and "View All" button
            HStack {
                Text("Today's Water Log")
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    .foregroundStyle(Color.deepBlue)
                
                Spacer()
                
                Button {
                    onViewAll()
                } label: {
                    Text("View All")
                        .font(.footnote)
                        .fontWeight(.medium)
                        .foregroundStyle(Color.blue)
                }
            }
            .padding(.horizontal, 20)
            
            // Water log entries list
            // Entries are sorted by time in descending order (most recent first)
            VStack(spacing: 12) {
                ForEach(logs.sorted(by: {$0.time > $1.time})) { log in WaterLogItem(log: log)
                }
            }
            .padding(.horizontal, 20)
            
            // Quick-add buttons for common water amounts (250ml, 500ml, 750ml)
            QuickAddButtons(amounts: [250, 500, 750]) { amount in
                onAddAmount(amount)
            }
            .padding(.horizontal, 20)
            .padding(.top, 8)
        }
        .padding(.vertical, 20)
        // Container styling with rounded corners and subtle shadow
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.05), radius: 15, x: 0, y: 5)
        )
    }
}


