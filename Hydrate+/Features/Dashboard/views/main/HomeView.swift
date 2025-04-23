//
//  HomeView.swift
//  Hydrate+
//
//  Created by Ian   on 11/04/2025.
//

import SwiftUI
import FirebaseAuth
import Foundation

struct CustomScrollView<Content: View>: View {
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        ScrollView {
            content
        }
        .scrollIndicators(.hidden)
    }
}

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
    @State private var showProfile = false
    @State private var showNotifications = false

    init() {
        let userID = Auth.auth().currentUser?.uid ?? ""
        let sharedVM = WaterViewModel(userID: userID)
        _waterViewModel = StateObject(wrappedValue: sharedVM)
        
        self.viewModel = sharedVM
    }

    var body: some View {
        NavigationStack {
            ZStack {
                backgroundGradient
                
                CustomScrollView {
                    VStack(spacing: 24) {
                        let user = userVM.user
                        GreetingHeader(name: user?.fullname)
                            .padding(.horizontal, 20)
                            .padding(.top, 12)
                        
                        WaterProgressCard(
                            waterConsumed: waterViewModel.totalConsumed,
                            dailyGoal: 2000,
                            onAddWaterTap: {
                                withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
                                    showingAddWaterSheet = true
                                }
                            }
                        )
                        .padding(.horizontal)
                        
                        StatsSection(streak: 0, dailyAverage: "0")
                            .padding(.horizontal)
                        
                        WaterLogSection(
                            logs: waterViewModel.waterLogs,
                            onViewAll: {
                                // TO DO: Navigate to logs view if built
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
                
                NavigationLink(destination: ProfileView(), isActive: $showProfile) {
                    EmptyView()
                }.hidden()
            }
            .navigationBarTitleDisplayMode(.inline)
            .safeAreaInset(edge: .top) {
                HStack {
                    Button {
                        showProfile = true
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
                        showNotifications.toggle()
                    } label: {
                        Image(systemName:"bell.badge.fill")
                            .font(.system(size: 18))
                            .foregroundStyle(Color.deepBlue)
                            .padding(8)
                            .background(Color.lightBlue.opacity(0.5))
                            .clipShape(Circle())
                    }
                    .popover(isPresented: $showNotifications, arrowEdge: .top) {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Notifications")
                                .font(.headline)
                            Divider()
                            Text("• Drink some water 💧")
                            Text("• You hit your goal yesterday 🎉")
                            Text("• Remember to hydrate today!")
                        }
                        .padding()
                        .frame(width: 250)
                    }
                }
                .padding(.horizontal)
                .padding(.top, 8)
                .background(Color.white.opacity(0.7))
            }
            .sheet(isPresented: $showingAddWaterSheet) {
                AddWaterView(viewModel: waterViewModel)
            }
            .onAppear {
                executeTask {
                    await waterViewModel.fetchLogs()
                }
                withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                    animateWave = true
                }
            }
        }
    }

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
