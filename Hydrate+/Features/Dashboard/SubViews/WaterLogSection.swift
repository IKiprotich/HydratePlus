//
//  WaterLogSection.swift
//  Hydrate+
//
//  Created by Ian   on 18/04/2025.
//

import SwiftUI

struct WaterLogSection: View {
    let logs: [WaterLog]
    let onViewAll: () -> Void
    let onAddAmount: (Int) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Section header
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
            
            // Water log items
            VStack(spacing: 12) {
                ForEach(logs.sorted(by: {$0.time > $1.time})) { log in WaterLogItem(log: log)
                }
            }
            .padding(.horizontal, 20)
            
            QuickAddButtons(amounts: [250, 500, 750]) { amount in
                onAddAmount(amount)
            }
            .padding(.horizontal, 20)
            .padding(.top, 8)
        }
        .padding(.vertical, 20)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.05), radius: 15, x: 0, y: 5)
        )
    }
}

#Preview {
    WaterLogSection(
        logs: SampleData.getSampleWaterLogs(), 
        onViewAll: {},
        onAddAmount: { _ in }
    )
    .padding()
}

