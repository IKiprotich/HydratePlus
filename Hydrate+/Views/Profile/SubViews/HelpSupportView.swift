//
//  HelpSupportView.swift
//  Hydrate+
//
//  Created by Ian   on 21/04/2025.
//

import SwiftUI

struct HelpSupportView: View {
    var body: some View {
        Form {
            Section(header: Text("Support")) {
                Link("Visit Support Website", destination: URL(string: "https://hydrateplus.support")!)
                Link("Email Support", destination: URL(string: "mailto:support@hydrateplus.com")!)
            }
            Section(header: Text("FAQ")) {
                Text("How to track water intake?")
                Text("How to set reminders?")
            }
        }
        .navigationTitle("Help & Support")
    }
}

#Preview {
    HelpSupportView()
}
