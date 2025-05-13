//
//  StatsSection.swift
//  Hydrate+
//
//  Created by Ian   on 18/04/2025.
//

import SwiftUI

struct StatsSection: View {
    let streak: Int
    let dailyAverage: Double
    
    var body: some View {
        HStack(spacing: 24) {
            VStack {
                Text("\(streak)")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundStyle(Color.blue)
                
                Text("Day Streak")
                    .font(.caption)
                    .foregroundStyle(Color.secondary)
            }
            
            Rectangle()
                .fill(Color.gray.opacity(0.3))
                .frame(width: 1, height: 30)
            
            VStack {
                Text("\(Int(dailyAverage))")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundStyle(Color.blue)
                
                Text("Daily Average")
                    .font(.caption)
                    .foregroundStyle(Color.secondary)
            }
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
        )
    }
}

#Preview {
    StatsSection(streak: 3, dailyAverage: 1850)
        .padding()
        .previewLayout(.sizeThatFits)
}
