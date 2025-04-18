//
//  HomeView.swift
//  Hydrate+
//
//  Created by Ian   on 11/04/2025.
//

import SwiftUI

struct HomeView: View {
    @State private var waterConsumed: Double = 1200
    @State private var dailyGoal: Double = 2000
    @State private var showingAddWaterSheet = false
    @State private var animateWave = false
    
    // Sample data
    private let streak = 7
    private let dailyAverage = "1.8L"
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background gradient
                backgroundGradient
                
                // Main content
                ScrollView {
                    VStack(spacing: 24) {
                        // Header with greeting
                        GreetingHeader(name: nil)
                            .padding(.horizontal, 20)
                            .padding(.top, 12)
                        
                        // Water progress card
                        WaterProgressCard(
                            waterConsumed: waterConsumed,
                            dailyGoal: dailyGoal,
                            onAddWaterTap: {
                                withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
                                    showingAddWaterSheet = true
                                }
                            }
                        )
                        .padding(.horizontal)
                        
                        // Stats cards
                        StatsSection(streak: streak, dailyAverage: dailyAverage)
                            .padding(.horizontal)
                        
                        // Water log section
                        WaterLogSection(
                            logs: SampleData.getSampleWaterLogs(), // Fixed: Added SampleData prefix
                            onViewAll: {
                                // Navigate to logs view
                            },
                            onAddAmount: { amount in
                                withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                                    waterConsumed = min(waterConsumed + Double(amount), dailyGoal * 1.5)
                                }
                            }
                        )
                        .padding(.horizontal)
                    }
                    .padding(.bottom, 32)
                }
                .scrollIndicators(.hidden)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Hydrate+")
                        .font(.system(size: 22, weight: .bold, design: .rounded))
                        .foregroundStyle(Color.deepBlue)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        // Open settings
                    } label: {
                        Image(systemName: "gearshape.fill")
                            .font(.system(size: 18))
                            .foregroundStyle(Color.deepBlue)
                            .padding(8)
                            .background(Color.lightBlue.opacity(0.5))
                            .clipShape(Circle())
                    }
                }
                
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        // Open profile
                    } label: {
                        Image(systemName: "person.crop.circle.fill")
                            .font(.system(size: 18))
                            .foregroundStyle(Color.deepBlue)
                            .padding(8)
                            .background(Color.lightBlue.opacity(0.5))
                            .clipShape(Circle())
                    }
                }
            }
            .sheet(isPresented: $showingAddWaterSheet) {
                AddWaterView(waterConsumed: $waterConsumed)
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                animateWave = true
            }
        }
    }
    
    // MARK: - UI Components
    
    private var backgroundGradient: some View {
        LinearGradient(
            gradient: Gradient(colors: [
                Color.lightBlue.opacity(0.3),
                .white,
                Color.lightBlue.opacity(0.2)
            ]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }
}

#Preview {
    HomeView()
}
