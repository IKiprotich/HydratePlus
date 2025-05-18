//
//  HomeView.swift
//  Hydrate+
//
//  Created by Ian   on 11/04/2025.
//

import SwiftUI
import FirebaseAuth
import Foundation

/// A custom scroll view implementation that hides scroll indicators
/// Used throughout the app for a cleaner, more modern look
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

/// Utility function to execute async tasks with optional priority
/// Used for handling asynchronous operations throughout the app
func executeTask<T>(priority: TaskPriority? = nil, operation: @escaping () async -> T) {
    Task(priority: priority) {
        await operation()
    }
}

/// The main home view of the Hydrate+ app
/// This view serves as the central hub for water tracking and user interaction
/// It displays:
/// - User greeting and profile access
/// - Water consumption progress
/// - Daily statistics
/// - Water intake history
/// - Notifications
struct HomeView: View {
    // MARK: - Properties
    
    /// View model for managing water-related data and operations
    @StateObject private var waterViewModel: WaterViewModel
    
    /// Controls the visibility of the add water sheet
    @State private var showingAddWaterSheet = false
    
    /// Controls the wave animation state
    @State private var animateWave = false
    
    /// View model for managing user-related data
    @StateObject private var userVM = UserViewModel()
    
    /// Observed water view model for real-time updates
    @ObservedObject var viewModel: WaterViewModel
    
    /// Controls the visibility of the profile view
    @State private var showProfile = false
    
    /// Controls the visibility of notifications
    @State private var showNotifications = false
    
    /// Stores the frame of the bell icon for notification positioning
    @State private var bellIconFrame: CGRect = .zero
    
    /// Service for handling notifications
    @StateObject private var notificationService = NotificationService()

    // MARK: - Initialization
    
    init() {
        let userID = Auth.auth().currentUser?.uid ?? ""
        let sharedVM = WaterViewModel(userID: userID)
        _waterViewModel = StateObject(wrappedValue: sharedVM)
        self.viewModel = sharedVM
    }

    // MARK: - Body
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background gradient for visual appeal
                backgroundGradient
                
                // Main scrollable content
                CustomScrollView {
                    VStack(spacing: 24) {
                        let user = userVM.user
                        // User greeting section
                        GreetingHeader(name: user?.fullname)
                            .padding(.horizontal, 20)
                            .padding(.top, 12)
                        
                        // Water progress tracking card
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
                        
                        // Statistics section showing streak and average
                        StatsSection(
                            streak: waterViewModel.currentStreak,
                            dailyAverage: waterViewModel.dailyAverage
                        )
                        .padding(.horizontal)
                        
                        // Water intake history section
                        WaterLogSection(
                            logs: waterViewModel.waterLogs,
                            onViewAll: {},
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

                // MARK: - Overlay Views
                
                // Notification overlay with background tap to dismiss
                if showNotifications {
                    Color.black.opacity(0.001)
                        .ignoresSafeArea()
                        .onTapGesture {
                            withAnimation {
                                showNotifications = false
                            }
                        }

                    NotificationCardView(notificationService: notificationService)
                        .position(
                            x: bellIconFrame.midX - 150,
                            y: bellIconFrame.maxY + 12
                        )
                        .zIndex(999)
                        .transition(.opacity.combined(with: .move(edge: .top)))
                }

                // Navigation link to profile view
                NavigationLink(destination: ProfileView(), isActive: $showProfile) {
                    EmptyView()
                }
                .hidden()
            }
            // MARK: - Navigation Bar
            .navigationBarTitleDisplayMode(.inline)
            .safeAreaInset(edge: .top) {
                // Custom navigation bar with profile, title, and notifications
                HStack {
                    // Profile Button
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
                    
                    // App Title
                    Text("Hydrate+")
                        .font(.system(size: 22, weight: .bold, design: .rounded))
                        .foregroundStyle(Color.deepBlue)
                    
                    Spacer()
                    
                    // Notifications Button with unread count badge
                    Button {
                        withAnimation {
                            showNotifications.toggle()
                        }
                    } label: {
                        ZStack {
                            Image(systemName: "bell.badge.fill")
                                .font(.system(size: 18))
                                .foregroundStyle(Color.deepBlue)
                                .padding(8)
                                .background(Color.lightBlue.opacity(0.5))
                                .clipShape(Circle())
                            
                            if notificationService.unreadCount > 0 {
                                Text("\(notificationService.unreadCount)")
                                    .font(.caption2)
                                    .fontWeight(.bold)
                                    .foregroundStyle(.white)
                                    .padding(4)
                                    .background(.red)
                                    .clipShape(Circle())
                                    .offset(x: 8, y: -8)
                            }
                        }
                    }
                    .overlay(
                        GeometryReader { geo in
                            Color.clear
                                .onAppear {
                                    bellIconFrame = geo.frame(in: .global)
                                }
                                .onChange(of: showNotifications) { _ in
                                    bellIconFrame = geo.frame(in: .global)
                                }
                        }
                    )
                }
                .padding(.horizontal)
                .padding(.top, 8)
                .background(Color.white.opacity(0.7))
            }
            // MARK: - Sheet and Lifecycle
            .sheet(isPresented: $showingAddWaterSheet) {
                AddWaterView(viewModel: waterViewModel)
            }
            .onAppear {
                // Fetch initial data and start animations
                executeTask {
                    await waterViewModel.fetchLogs()
                    try? await notificationService.fetchNotifications()
                }
                withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                    animateWave = true
                }
            }
        }
    }

    // MARK: - Helper Views
    
    /// Background gradient view for the home screen
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

