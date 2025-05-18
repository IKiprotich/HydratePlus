//
//  WaterProgressCard.swift
//  Hydrate+
//
//  Created by Ian   on 11/04/2025.
//

import SwiftUI

/// WaterProgressCard is a SwiftUI view that displays the user's daily water consumption progress
/// in an engaging and interactive way. It features a circular progress indicator with an animated
/// water wave effect, achievement badges, and a button to add more water.
///
/// The view combines multiple visual elements to create an intuitive water tracking experience:
/// - A circular progress indicator that changes color based on progress
/// - An animated water wave effect that fills the circle
/// - A tap-interactive water drop icon that toggles between ml and percentage
/// - An achievement badge that appears when the user reaches 80% of their goal
/// - A prominent "Add Water" button for quick water intake logging
struct WaterProgressCard: View {
    /// The amount of water consumed in milliliters
    let waterConsumed: Double
    
    /// The daily water intake goal in milliliters
    let dailyGoal: Double
    
    /// Callback function triggered when the user taps the "Add Water" button
    let onAddWaterTap: () -> Void
    
    /// Controls the animation of the water wave effect
    @State private var animateWave = false
    
    /// Controls whether to show the percentage or ml amount in the center
    @State private var showPercentage = false
    
    // MARK: - Custom Colors
    /// Primary blue color used for accents and gradients
    private let accentBlue = Color(red: 0.0, green: 0.6, blue: 0.9)
    
    /// Darker blue used for gradient effects
    private let deepBlue = Color(red: 0.0, green: 0.4, blue: 0.8)
    
    /// Light blue used for background effects
    private let lightBlue = Color(red: 0.8, green: 0.95, blue: 1.0)
    
    // MARK: - Computed Properties
    
    /// Calculates the progress percentage towards the daily goal
    /// Returns a value between 0 and 1, capped at 1.0
    private var progressPercentage: Double {
        min(waterConsumed / dailyGoal, 1.0)
    }
    
    /// Determines the color of the progress indicator based on the current progress
    /// - Red: < 30% of goal
    /// - Orange: 30-70% of goal
    /// - Blue: > 70% of goal
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
            ZStack {
                // Background card with gradient and shadow
                RoundedRectangle(cornerRadius: 28)
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [.white, lightBlue.opacity(0.5)]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .shadow(color: accentBlue.opacity(0.2), radius: 15, x: 0, y: 8)
                
                VStack(spacing: 24) {
                    // Header section with date, goal, and achievement badge
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
                        
                        // Achievement badge appears when user reaches 80% of their goal
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
                    
                    // Main progress circle with multiple layers
                    ZStack {
                        // Background circle
                        Circle()
                            .stroke(Color.blue.opacity(0.1), lineWidth: 10)
                            .frame(width: 220, height: 220)
                        
                        // Animated water wave effect
                        WaterWaveView(progress: progressPercentage, waveHeight: 5, animatablePhase: animateWave ? 1 : 0)
                            .frame(width: 200, height: 200)
                            .clipShape(Circle())
                            .overlay(
                                Circle()
                                    .stroke(progressColor, lineWidth: 6)
                                    .opacity(0.7)
                            )
                        
                        // Progress ring with gradient
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
                        
                        // Center content with interactive water drop
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
                            
                            // Toggle between percentage and ml display
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
                    
                    // Add Water button with gradient background
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
            // Start the continuous wave animation when the view appears
            withAnimation(.linear(duration: 2).repeatForever(autoreverses: false)) {
                animateWave = true
            }
        }
    }
}

// MARK: - Preview Provider
/// Preview provider for development and testing
#Preview {
    WaterProgressCard(waterConsumed: 1500, dailyGoal: 2000, onAddWaterTap: {})
        .padding()
        .background(Color.gray.opacity(0.1))
}
