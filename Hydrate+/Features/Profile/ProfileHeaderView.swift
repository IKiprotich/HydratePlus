//
//  ProfileHeaderView.swift
//  Hydrate+
//
//  Created by Ian   on 19/04/2025.
//

import SwiftUI

struct ProfileHeaderView: View {
    let user: User
    
    var body: some View {
        VStack(spacing: 16) {
            // Profile image with premium badge
            ZStack(alignment: .bottomTrailing) {
                // Profile image
                if let imageUrl = user.profileImageUrl, !imageUrl.isEmpty {
                    AsyncImage(url: URL(string: imageUrl)) { image in
                        image
                            .resizable()
                            .scaledToFill()
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.white, lineWidth: 4))
                    .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
                } else {
                    Image(systemName: "person.crop.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .foregroundStyle(Color.blue)
                        .overlay(Circle().stroke(Color.white, lineWidth: 4))
                        .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
                }
                
                // Premium badge if applicable
                if user.isPremium {
                    Image(systemName: "checkmark.seal.fill")
                        .font(.title3)
                        .foregroundStyle(.white, .yellow)
                        .background(Circle().fill(Color.blue).padding(-2))
                        .shadow(color: Color.black.opacity(0.2), radius: 2, x: 0, y: 1)
                }
            }
            
            // User name and status
            VStack(spacing: 4) {
                Text(user.fullname)
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text(user.isPremium ? "Premium Member" : "Free Account")
                    .font(.subheadline)
                    .foregroundStyle(user.isPremium ? Color.blue : Color.secondary)
            }
            
            // User stats
            HStack(spacing: 24) {
                // Streak stat
                VStack {
                    Text("\(user.streakDays)")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundStyle(Color.blue)
                    
                    Text("Day Streak")
                        .font(.caption)
                        .foregroundStyle(Color.secondary)
                }
                
                // Divider
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 1, height: 30)
                
                // Achievements stat
                VStack {
                    Text("\(user.achievementsCount)")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundStyle(Color.blue)
                    
                    Text("Achievements")
                        .font(.caption)
                        .foregroundStyle(Color.secondary)
                }
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.white)
                    .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
            )
        }
        .padding(.vertical, 24)
        .padding(.horizontal)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [Color.lightBlue.opacity(0.2), .white]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
        )
        .padding(.horizontal)
    }
}

#Preview {
    ProfileHeaderView(
        user: User(
            id: "user123",
            email: "user@example.com",
            fullname: "Sarah Johnson",
            profileImageUrl: nil,
            memberSince: Date(),
            isPremium: true,
            streakDays: 14,
            achievementsCount: 7
        )
    )
    .padding(.vertical)
    .background(Color.gray.opacity(0.1))
}
