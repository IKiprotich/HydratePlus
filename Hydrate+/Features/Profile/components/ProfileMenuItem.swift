//
//  ProfileMenuItem.swift
//  Hydrate+
//
//  Created by Ian   on 19/04/2025.
//

import SwiftUI

struct ProfileMenuItem<Destination: View>: View {
    let icon: String
    let iconColor: Color
    let title: String
    let subtitle: String?
    let destination: Destination
    let showDivider: Bool
    let trailingContent: AnyView?
    
    init(
        icon: String,
        iconColor: Color = .blue,
        title: String,
        subtitle: String? = nil,
        showDivider: Bool = true,
        @ViewBuilder destination: @escaping () -> Destination,
        @ViewBuilder trailingContent: @escaping () -> some View = { EmptyView() }
    ) {
        self.icon = icon
        self.iconColor = iconColor
        self.title = title
        self.subtitle = subtitle
        self.showDivider = showDivider
        self.destination = destination()
        self.trailingContent = AnyView(trailingContent())
    }
    
    var body: some View {
        NavigationLink {
            destination
        } label: {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(iconColor.opacity(0.15))
                        .frame(width: 36, height: 36)
                    
                    Image(systemName: icon)
                        .font(.system(size: 16))
                        .foregroundStyle(iconColor)
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundStyle(Color.primary)
                    
                    if let subtitle = subtitle {
                        Text(subtitle)
                            .font(.caption)
                            .foregroundStyle(Color.secondary)
                    }
                }
                
                Spacer()
                
                if let trailingContent = trailingContent {
                    trailingContent
                }
            }
            .padding(.vertical, 8)
            .contentShape(Rectangle())
        }
        .buttonStyle(PlainButtonStyle())
        
        if showDivider {
            Divider()
                .padding(.leading, 52)
        }
    }
}


struct ProfileMenuToggleItem: View {
    let icon: String
    let iconColor: Color
    let title: String
    let subtitle: String?
    let isOn: Binding<Bool>
    let showDivider: Bool
    let action: ((Bool) -> Void)?
    
    init(
        icon: String,
        iconColor: Color = .blue,
        title: String,
        subtitle: String? = nil,
        isOn: Binding<Bool>,
        showDivider: Bool = true,
        action: ((Bool) -> Void)? = nil
    ) {
        self.icon = icon
        self.iconColor = iconColor
        self.title = title
        self.subtitle = subtitle
        self.isOn = isOn
        self.showDivider = showDivider
        self.action = action
    }
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(iconColor.opacity(0.15))
                    .frame(width: 36, height: 36)
                
                Image(systemName: icon)
                    .font(.system(size: 16))
                    .foregroundStyle(iconColor)
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(Color.primary)
                
                if let subtitle = subtitle {
                    Text(subtitle)
                        .font(.caption)
                        .foregroundStyle(Color.secondary)
                }
            }
            
            Spacer()
            
            // Toggle
            Toggle("", isOn: isOn)
                .labelsHidden()
                .onChange(of: isOn.wrappedValue) { newValue in
                    action?(newValue)
                }
        }
        .padding(.vertical, 8)
        
        if showDivider {
            Divider()
                .padding(.leading, 52)
        }
    }
}


struct ProfileMenuButtonItem: View {
    let icon: String
    let iconColor: Color
    let title: String
    let action: () -> Void
    
    init(
        icon: String,
        iconColor: Color = .red,
        title: String,
        action: @escaping () -> Void
    ) {
        self.icon = icon
        self.iconColor = iconColor
        self.title = title
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(iconColor.opacity(0.15))
                        .frame(width: 36, height: 36)
                    
                    Image(systemName: icon)
                        .font(.system(size: 16))
                        .foregroundStyle(iconColor)
                }
                
                Text(title)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(iconColor)
                
                Spacer()
            }
            .padding(.vertical, 8)
            .contentShape(Rectangle())
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview("Menu Item") {
    VStack {
        ProfileMenuItem(
            icon: "person.fill",
            title: "Account Settings",
            subtitle: "Manage your account details"
        ) {
            Text("Account Settings")
        } trailingContent: {
            Text("Edit")
                .font(.caption)
                .foregroundStyle(Color.blue)
        }
        
        ProfileMenuItem(
            icon: "target",
            iconColor: .purple,
            title: "Daily Goal",
            subtitle: "2500ml"
        ) {
            Text("Daily Goal")
        }
    }
    .padding()
    .previewLayout(.sizeThatFits)
}

#Preview("Toggle Item") {
    VStack {
        ProfileMenuToggleItem(
            icon: "bell.fill",
            iconColor: .orange,
            title: "Notifications",
            subtitle: "Receive hydration reminders",
            isOn: .constant(true)
        )
        
        ProfileMenuToggleItem(
            icon: "moon.fill",
            iconColor: .indigo,
            title: "Dark Mode",
            isOn: .constant(false)
        )
    }
    .padding()
    .previewLayout(.sizeThatFits)
}

#Preview("Button Item") {
    ProfileMenuButtonItem(
        icon: "arrow.right.square.fill",
        title: "Sign Out"
    ) {
        print("Sign out tapped")
    }
    .padding()
    .previewLayout(.sizeThatFits)
}
