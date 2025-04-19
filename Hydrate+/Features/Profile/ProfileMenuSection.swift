//
//  ProfileMenuSection.swift
//  Hydrate+
//
//  Created by Ian   on 19/04/2025.
//

import SwiftUI

struct ProfileMenuSection<Content: View>: View {
    let title: String
    let icon: String?
    let content: Content
    
    init(
        title: String,
        icon: String? = nil,
        @ViewBuilder content: () -> Content
    ) {
        self.title = title
        self.icon = icon
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Section header
            HStack(spacing: 8) {
                if let icon = icon {
                    Image(systemName: icon)
                        .font(.system(size: 14))
                        .foregroundStyle(Color.blue)
                }
                
                Text(title)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(Color.blue)
            }
            .padding(.horizontal, 16)
            .padding(.top, 8)
            
            // Section content
            VStack(spacing: 0) {
                content
            }
            .padding(.horizontal, 16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.white)
                    .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
            )
        }
        .padding(.horizontal)
        .padding(.bottom, 16)
    }
}

#Preview {
    ProfileMenuSection(title: "Settings", icon: "gear") {
        ProfileMenuItem(
            icon: "person.fill",
            title: "Account Settings"
        ) {
            Text("Account Settings")
        }
        
        ProfileMenuItem(
            icon: "target",
            iconColor: .purple,
            title: "Daily Goal",
            subtitle: "2500ml"
        ) {
            Text("Daily Goal")
        }
        
        ProfileMenuToggleItem(
            icon: "bell.fill",
            iconColor: .orange,
            title: "Notifications",
            isOn: .constant(true)
        )
    }
    .padding(.vertical)
    .background(Color.gray.opacity(0.1))
}
