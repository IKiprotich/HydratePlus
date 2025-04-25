//
//  AboutView.swift
//  Hydrate+
//
//  Created by Ian   on 21/04/2025.
//

import SwiftUI

struct AboutView: View {
    var body: some View {
        Form {
            Section(header: Text("About Hydrate+")) {
                Text("Version 1.0.0")
                Text("Developed by Ian Kiprotich")
                Link("Terms of Service", destination: URL(string: "https://hydrateplus.com/terms")!)
                Link("Privacy Policy", destination: URL(string: "https://hydrateplus.com/privacy")!)
            }
        }
        .navigationTitle("About")
    }
}

#Preview {
    AboutView()
}
