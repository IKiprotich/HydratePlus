//
//  WaterProgressCard.swift
//  Hydrate+
//
//  Created by Ian   on 11/04/2025.
//

import SwiftUI

struct WaterProgressCard: View {
    let waterConsumed: Double
    let dailyGoal: Double
    let onAddWaterTap: () -> Void

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [Color.white, Color.lightBlue.opacity(0.3)]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .shadow(color: Color.waterBlue.opacity(0.2), radius: 10, x: 0, y: 5)

            VStack(spacing: 20) {
                Text(Date().formattedAsDayMonth)
                    .font(.headline)
                    .foregroundColor(.secondary)
                    .padding(.top, 12)

                ZStack {
                    WaterBottleShape()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [Color.white.opacity(0.2), Color.white.opacity(0.05)]),
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .background(
                            WaterBottleShape()
                                .stroke(Color.waterBlue.opacity(0.4), lineWidth: 2)
                        )
                        .shadow(color: Color.waterBlue.opacity(0.1), radius: 6, x: 0, y: 4)

                    WaterBottleShape()
                        .stroke(
                            LinearGradient(
                                gradient: Gradient(colors: [Color.white.opacity(0.6), Color.clear]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1.5
                        )
                        .frame(width: 120, height: 250)

                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.gray.opacity(0.7))
                        .frame(width: 50, height: 15)
                        .offset(y: -135)
                        .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)

                    WaterFillShape(fillLevel: CGFloat(min(waterConsumed / dailyGoal, 1.0)))
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [Color.lightBlue, Color.waterBlue]),
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .frame(width: 120, height: 250)
                        .clipShape(WaterBottleShape())
                        .animation(.spring(), value: waterConsumed)

                    Text("\(Int(min((waterConsumed / dailyGoal), 1.0) * 100))%")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .shadow(color: Color.black.opacity(0.2), radius: 2, x: 0, y: 1)
                }

                Text("\(Int(waterConsumed)) / \(Int(dailyGoal)) ml")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(Color.waterBlue)

                Button(action: onAddWaterTap) {
                    HStack {
                        Image(systemName: "plus")
                        Text("Add Water")
                            .fontWeight(.semibold)
                    }
                    .foregroundColor(.white)
                    .frame(width: 200, height: 50)
                    .background(Color.waterBlue)
                    .cornerRadius(25)
                    .shadow(color: Color.waterBlue.opacity(0.4), radius: 5, x: 0, y: 3)
                }
                .padding(.bottom, 16)
            }
            .padding()
        }
        .frame(height: 450)
        .padding(.horizontal)
    }
}

#Preview {
    WaterProgressCard(waterConsumed: 400, dailyGoal: 2000, onAddWaterTap: {})
}
