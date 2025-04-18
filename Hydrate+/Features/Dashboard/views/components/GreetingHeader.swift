//
//  GreetingHeader.swift
//  Hydrate+
//
//  Created by Ian   on 18/04/2025.
//

import SwiftUI

struct GreetingHeader: View {
    let name: String?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Hello, \(name ?? "Hydration Hero")!")
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .foregroundStyle(Color.deepBlue)
            
            Text("Let's track your water intake today")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    GreetingHeader(name: "Sarah")
        .padding()
}
