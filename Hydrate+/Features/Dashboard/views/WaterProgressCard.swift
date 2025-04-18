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
    
    @State private var animateWave = false
    @State private var showPercentage = false
    
    // Custom colors
    private let accentBlue = Color(red: 0.0, green: 0.6, blue: 0.9)
    private let deepBlue = Color(red: 0.0, green: 0.4, blue: 0.8)
    private let lightBlue = Color(red: 0.8, green: 0.95, blue: 1.0)
    
    // Computed properties
    private var progressPercentage: Double {
        min(waterConsumed / dailyGoal, 1.0)
    }
    
    private var progressColor: Color {
        if progressPercentage < 0.3 {
            return .red
        } else if progressPercentage < 0.7 {
            return .orange
        } else {
            return accentBlue
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Card content
            ZStack {
                // Card background with gradient
                RoundedRectangle(cornerRadius: 28)
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [.white, lightBlue.opacity(0.5)]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .shadow(color: accentBlue.opacity(0.2), radius: 15, x: 0, y: 8)
                
                // Content
                VStack(spacing: 24) {
                    // Date and goal info
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(Date(), style: .date)
                                .font(.system(size: 16, weight: .medium, design: .rounded))
                                .foregroundStyle(Color.secondary)
                            
                            Text("Goal: \(Int(dailyGoal))ml")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundStyle(Color.secondary.opacity(0.8))
                        }
                        
                        Spacer()
                        
                        // Achievement badge if over 80%
                        if progressPercentage >= 0.8 {
                            Image(systemName: "medal.fill")
                                .font(.system(size: 24))
                                .symbolRenderingMode(.palette)
                                .foregroundStyle(.yellow, .orange)
                                .shadow(color: .orange.opacity(0.3), radius: 2, x: 0, y: 1)
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 24)
                    
                    // Progress visualization
                    ZStack {
                        // Water container
                        Circle()
                            .stroke(Color.blue.opacity(0.1), lineWidth: 10)
                            .frame(width: 220, height: 220)
                        
                        // Water wave effect
                        WaterWaveView(progress: progressPercentage, waveHeight: 5, animatablePhase: animateWave ? 1 : 0)
                            .frame(width: 200, height: 200)
                            .clipShape(Circle())
                            .overlay(
                                Circle()
                                    .stroke(progressColor, lineWidth: 6)
                                    .opacity(0.7)
                            )
                        
                        // Progress indicator
                        Circle()
                            .trim(from: 0, to: progressPercentage)
                            .stroke(
                                AngularGradient(
                                    gradient: Gradient(colors: [progressColor.opacity(0.5), progressColor]),
                                    center: .center,
                                    startAngle: .degrees(0),
                                    endAngle: .degrees(360 * progressPercentage)
                                ),
                                style: StrokeStyle(lineWidth: 10, lineCap: .round)
                            )
                            .rotationEffect(.degrees(-90))
                            .frame(width: 220, height: 220)
                        
                        // Center content
                        VStack(spacing: 8) {
                            Image(systemName: "drop.fill")
                                .font(.system(size: 36))
                                .symbolRenderingMode(.palette)
                                .foregroundStyle(progressColor, progressColor.opacity(0.7))
                                .shadow(color: progressColor.opacity(0.3), radius: 2, x: 0, y: 1)
                                .onTapGesture {
                                    withAnimation(.spring(response: 0.4)) {
                                        showPercentage.toggle()
                                    }
                                }
                            
                            if showPercentage {
                                Text("\(Int(progressPercentage * 100))%")
                                    .font(.system(size: 28, weight: .bold, design: .rounded))
                                    .foregroundStyle(progressColor)
                                    .transition(.scale.combined(with: .opacity))
                            } else {
                                Text("\(Int(waterConsumed))ml")
                                    .font(.system(size: 28, weight: .bold, design: .rounded))
                                    .foregroundStyle(progressColor)
                                    .transition(.scale.combined(with: .opacity))
                            }
                        }
                        .animation(.spring(response: 0.4), value: showPercentage)
                    }
                    .padding(.vertical, 10)
                    
                    // Add water button
                    Button(action: onAddWaterTap) {
                        HStack {
                            Image(systemName: "plus.circle.fill")
                                .font(.system(size: 20))
                            Text("Add Water")
                                .font(.system(size: 18, weight: .semibold, design: .rounded))
                        }
                        .foregroundStyle(.white)
                        .frame(height: 56)
                        .frame(maxWidth: .infinity)
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [accentBlue, deepBlue]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 18))
                        .shadow(color: accentBlue.opacity(0.4), radius: 8, x: 0, y: 4)
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 24)
                }
            }
        }
        .onAppear {
            withAnimation(.linear(duration: 2).repeatForever(autoreverses: false)) {
                animateWave = true
            }
        }
    }
}



#Preview {
    WaterProgressCard(waterConsumed: 1500, dailyGoal: 2000, onAddWaterTap: {})
        .padding()
        .background(Color.gray.opacity(0.1))
}
