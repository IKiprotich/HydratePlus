//
//  QuickAddButtons.swift
//  Hydrate+
//
//  Created by Ian   on 18/04/2025.
//

import SwiftUI

struct QuickAddButtons: View {
    let amounts: [Int]
    let onAdd: (Int) -> Void
    
    var body: some View {
        HStack(spacing: 12) {
            ForEach(amounts, id: \.self) { amount in
                Button {
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                        onAdd(amount)
                    }
                } label: {
                    VStack(spacing: 4) {
                        Image(systemName: "drop.fill")
                            .font(.system(size: 16))
                        
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
