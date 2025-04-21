//
//  HomeView.swift
//  Hydrate+
//
//  Created by Ian   on 11/04/2025.
//

//
//  HomeView.swift
//  Hydrate+
//
//  Created by Ian   on 11/04/2025.
//

import SwiftUI
import FirebaseAuth
import Foundation

// a custom scroll view wrapper to avoid ambiguity
struct CustomScrollView<Content: View>: View {
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        SwiftUI.ScrollView {
            content
        }
        .scrollIndicators(.hidden)
    }
}

// Custom Task wrapper to avoid ambiguity
func executeTask<T>(priority: TaskPriority? = nil, operation: @escaping () async -> T) {
    Task(priority: priority) {
        await operation()
    }
}

struct HomeView: View {
    @StateObject private var waterViewModel: WaterViewModel
    @State private var showingAddWaterSheet = false
    @State private var animateWave = false
    @State private var waterConsumed: Double = 0
    @StateObject private var userVM = UserViewModel()
    @ObservedObject var viewModel: WaterViewModel


    init() {
        // Get the current authenticated user's ID
        let userID = Auth.auth().currentUser?.uid ?? ""
        let sharedVM = WaterViewModel(userID: userID)
        _waterViewModel = StateObject(wrappedValue: sharedVM)
        
        self.viewModel = sharedVM

    }

    var body: some View {
        NavigationStack {
            ZStack {
                backgroundGradient
                
                // Main content
                CustomScrollView {
                    VStack(spacing: 24) {
                        let user = userVM.user
                        GreetingHeader(name: user?.fullname)
                            .padding(.horizontal, 20)
                            .padding(.top, 12)

                        // Water progress card
                        WaterProgressCard(
                            waterConsumed: waterViewModel.totalConsumed,
                            dailyGoal: 2000, // Set dynamic daily goal if needed
                            onAddWaterTap: {
                                withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
                                    showingAddWaterSheet = true
                                }
                            }
                        )
                        .padding(.horizontal)

                        // Stats cards (use data from `waterViewModel`)
                        StatsSection(streak: 0, dailyAverage: "0")
                            .padding(.horizontal)

                        // Water log section (use real logs)
                        WaterLogSection(
                            logs: waterViewModel.waterLogs,
                            onViewAll: {
                                // Navigate to logs view if needed
                            },
                            onAddAmount: { amount in
                                withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                                    executeTask {
                                        await waterViewModel.addWater(amount: Double(amount))
                                    }
                                }
                            }
                        )
                        .padding(.horizontal)
                    }
                    .padding(.bottom, 32)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .safeAreaInset(edge: .top) {
                HStack {
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
                    
                    Spacer()
                    
                    Text("Hydrate+")
                        .font(.system(size: 22, weight: .bold, design: .rounded))
                        .foregroundStyle(Color.deepBlue)
                    
                    Spacer()
                    
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
                .padding(.horizontal)
                .padding(.top, 8)
                .background(Color.white.opacity(0.7))
            }
            .sheet(isPresented: $showingAddWaterSheet) {
                AddWaterView(viewModel: waterViewModel)
            }

        }
        .onAppear {
            executeTask {
                await waterViewModel.fetchLogs() // Fetch logs when the view appears
            }
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
