//
//  SettingsComponents.swift
//  Hydrate+
//
//  Created by Ian   on 05/05/2025.
//
/*
 * SettingsComponents.swift
 * 
 * This file contains reusable SwiftUI components for building settings screens in the Hydrate+ app.
 * It provides consistent styling and layout for settings UI elements including:
 * 
 * - SettingsSection: A container view that groups related settings with a title
 * - SettingsInfoRow: A row displaying a key-value pair of information
 * - SettingsButtonRow: A tappable row with an icon for navigation or actions
 * 
 * The components use the app's visual design system with:
 * - Consistent spacing and padding
 * - Custom background styling with shadows
 * - Typography hierarchy
 * - Accessibility support through semantic content shapes
 */

import SwiftUI

struct SettingsSection<Content: View>: View {
    let title: String
    let content: Content
    
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(title)
                .font(.headline)
                .foregroundStyle(.secondary)
                .padding(.leading, 8)
                .padding(.bottom, 4)
            
            VStack(spacing: 0) {
                content
            }
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(BlueGradientScheme.cardBackground)
                    .shadow(color: BlueGradientScheme.shadow, radius: 2)
            )
        }
    }
}

struct SettingsInfoRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
                .foregroundStyle(.primary)
            Spacer()
            Text(value)
                .foregroundStyle(.secondary)
        }
        .padding()
        .contentShape(Rectangle())
    }
}

struct SettingsButtonRow: View {
    let icon: String
    let iconColor: Color
    let title: String
    var value: String? = nil
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundStyle(iconColor)
                .frame(width: 24)
            
            Text(title)
                .foregroundStyle(.primary)
            
            Spacer()
            
            if let value = value {
                Text(value)
                    .foregroundStyle(.secondary)
            }
            
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding()
        .contentShape(Rectangle())
    }
}

struct SettingsPickerRow: View {
    let title: String
    @Binding var selection: String
    let options: [String]
    let onSelectionChanged: () -> Void
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(title)
                    .foregroundStyle(.primary)
                
                Spacer()
                
                Picker(title, selection: $selection) {
                    ForEach(options, id: \.self) { option in
                        Text(option).tag(option)
                    }
                }
                .pickerStyle(.menu)
                .onChange(of: selection) { _, _ in
                    onSelectionChanged()
                }
            }
            .padding()
        }
        .contentShape(Rectangle())
    }
}
