//
//  NotificationCardView.swift
//  Hydrate+
//
//  Created by Ian   on 02/05/2025.
//

import SwiftUI

struct NotificationCardView: View {
    let notifications: [String]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Notifications")
                .font(.headline)
                .padding(.bottom, 4)

            Divider()

            ForEach(notifications, id: \.self) { note in
                Text("• \(note)")
                    .font(.subheadline)
                    .foregroundColor(.primary)
            }
        }
        .padding()
        .frame(width: 260)
        .background(.ultraThinMaterial.opacity(0.9))
        .cornerRadius(14)
        .shadow(radius: 12)
    }
}

