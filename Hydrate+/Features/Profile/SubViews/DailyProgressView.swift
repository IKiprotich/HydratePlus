//
//  DailyProgressView.swift
//  Hydrate+
//
//  Created by Ian   on 21/04/2025.
//

import SwiftUI

struct DailyProgressView: View {
    let dailyGoal: Double
    let currentIntake: Double

    var progress: Double {
        min(currentIntake / dailyGoal, 1.0)
    }

    var body: some View {
        HStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Daily Progress")
                    .font(.headline)
                    .foregroundStyle(.blue)

            }

            Spacer()

            ZStack {
                Circle()
                    .stroke(Color.gray.opacity(0.2), lineWidth: 8)
                    .frame(width: 80, height: 80)

                Circle()
                    .trim(from: 0, to: progress)
                    .stroke(Color.blue, lineWidth: 8)
                    .frame(width: 80, height: 80)
                    .rotationEffect(.degrees(-90))
                
                VStack{
                
                    Text("\(Int(currentIntake)) ml")
                        .font(.title3)
                        .font(.system(size: 10))
                        .fontWeight(.bold)

                    Text("of \(Int(dailyGoal)) ml")
                        .font(.caption)
                        .font(.system(size: 10))
                        .foregroundStyle(.secondary)
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.05), radius: 5)
        )
        .padding(.horizontal)
    }
}

#Preview {
    DailyProgressView(dailyGoal: 2000, currentIntake: 1200)
}
