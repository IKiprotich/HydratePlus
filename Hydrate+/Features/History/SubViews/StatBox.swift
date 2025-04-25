//
//  StatBox.swift
//  Hydrate+
//
//  Created by Ian   on 19/04/2025.
//

import SwiftUI

struct StatBox: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundStyle(color)
            
            Text(value)
                .font(.system(size: 18, weight: .bold))
                .foregroundStyle(Color.primary)
            
            Text(title)
                .font(.caption)
                .foregroundStyle(Color.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(color.opacity(0.1))
        )
    }
}

#Preview {
    StatBox(
        title: "Goal",
        value: "2000ml",
        icon: "target",
        color: .purple
    )
    .frame(width: 150)
    .padding()
    .previewLayout(.sizeThatFits)
}
