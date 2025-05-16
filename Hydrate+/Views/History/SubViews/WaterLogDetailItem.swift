//
//  WaterLogDetailItem.swift
//  Hydrate+
//
//  Created by Ian   on 19/04/2025.
//

import SwiftUI

struct WaterLogDetailItem: View {
    let log: WaterLog
    
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
                
                Text(log.time, style: .time)
                    .font(.caption)
                    .foregroundStyle(Color.secondary)
            }
            
            Spacer()
        }
        .padding()
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
