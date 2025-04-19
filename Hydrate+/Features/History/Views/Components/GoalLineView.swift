//
//  GoalLineView.swift
//  Hydrate+
//
//  Created by Ian   on 19/04/2025.
//

import SwiftUI

struct GoalLineView: View {
    let goalValue: Double
    let maxValue: Double
    let maxHeight: CGFloat
    
    private var offsetY: CGFloat {
        -((goalValue / maxValue) * maxHeight - maxHeight) / 2
    }
    
    var body: some View {
        HStack(spacing: 0) {
            Rectangle()
                .fill(Color.red.opacity(0.2))
                .frame(width: 4)
            
            Text(" Goal")
                .font(.caption)
                .foregroundStyle(Color.red.opacity(0.7))
                .padding(.leading, 4)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .trailing)
        .offset(y: offsetY)
    }
}

#Preview {
    GoalLineView(goalValue: 2000, maxValue: 3000, maxHeight: 200)
        .frame(height: 200)
        .background(Color.gray.opacity(0.1))
        .previewLayout(.sizeThatFits)
}
