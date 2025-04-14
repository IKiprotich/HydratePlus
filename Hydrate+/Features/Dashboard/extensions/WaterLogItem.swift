//
//  WaterLogItem.swift
//  Hydrate+
//
//  Created by Ian   on 11/04/2025.
//

import SwiftUI

struct WaterLogItem: View {
    let log: WaterLog
    
    var body: some View {
        HStack {
            Image(systemName: log.icon)
                .foregroundColor(.white)
                .frame(width: 36, height: 36)
                .background(Color.waterBlue)
                .cornerRadius(18)
            
            VStack(alignment: .leading) {
                Text("\(log.amount) ml")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                Text(log.time)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Button {
                // Edit log functionality
            } label: {
                Image(systemName: "pencil")
                    .foregroundColor(Color.waterBlue)
            }
        }
        .padding(.vertical, 8)
        .padding(.horizontal)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
        .padding(.horizontal)
    }
}


