//
//  ProfileView.swift
//  Hydrate+
//
//  Created by Ian   on 11/04/2025.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        NavigationStack {
            VStack {
                // Profile header
                VStack {
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .foregroundColor(Color.waterBlue)
                        .padding()
                    
                    Text(viewModel.currentUser?.fullname ?? "User")
                        .font(.title2)
                        .fontWeight(.semibold)
                }
                .padding(.top)
                
                // Profile options list
                List {
                    Section(header: Text("Settings")) {
                        Button {
                            // TO DO: add navigation to account settings
                        } label: {
                            Label("Account Settings", systemImage: "person.fill")
                                .foregroundColor(.primary)
                        }
                        
                        Button {
                            // TO DO: Navigate to daily goal settings
                        } label: {
                            Label("Daily Goal", systemImage: "target")
                                .foregroundColor(.primary)
                        }
                        
                        Button {
                            // TO DO: Navigate to notification settings
                        } label: {
                            Label("Notifications", systemImage: "bell.fill")
                                .foregroundColor(.primary)
                        }
                    }
                    
                    Section(header: Text("App")) {
                        Button {
                            // TO DO:Navigate to help & support
                        } label: {
                            Label("Help & Support", systemImage: "questionmark.circle.fill")
                                .foregroundColor(.primary)
                        }
                        
                        Button {
                            // TO DO: Navigate to about page
                        } label: {
                            Label("About", systemImage: "info.circle.fill")
                                .foregroundColor(.primary)
                        }
                    }
                    
                    Section {
                        Button {
                            Task {
                                try await viewModel.signOut()
                            }
                        } label: {
                            Label("Sign Out", systemImage: "arrow.right.square.fill")
                                .foregroundColor(.red)
                        }
                    }
                }
                .listStyle(InsetGroupedListStyle())
            }
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [.white, Color.lightBlue.opacity(0.2)]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .edgesIgnoringSafeArea(.all)
            )
            .navigationTitle("Profile")
        }
    }
}
#Preview {
    ProfileView()
        .environmentObject(AuthViewModel() )
}
