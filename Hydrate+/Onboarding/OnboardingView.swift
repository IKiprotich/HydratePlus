//
//  OnboardingView.swift
//  Hydrate+
//
//  Created by Ian   on 19/05/2025.
//

import SwiftUI

struct OnboardingView: View {
    @StateObject private var viewModel = OnboardingViewModel()
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                gradient: Gradient(colors: [Color.blue.opacity(0.1), Color.blue.opacity(0.05)]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            // Content
            VStack {
                switch viewModel.currentStep {
                case .welcome:
                    WelcomeView(viewModel: viewModel)
                case .features:
                    FeaturesView(viewModel: viewModel)
                case .permissions:
                    PermissionsView(viewModel: viewModel)
                case .complete:
                    CompletionView(viewModel: viewModel, dismiss: dismiss)
                }
            }
            .animation(.easeInOut, value: viewModel.currentStep)
            .transition(.opacity)
        }
    }
}

// MARK: - Welcome View
struct WelcomeView: View {
    @ObservedObject var viewModel: OnboardingViewModel
    
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            // Animated water drop
            Image(systemName: "drop.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 100)
                .foregroundColor(.blue)
                .symbolEffect(.bounce, options: .repeating)
            
            Text("Welcome to Hydrate+")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("Your personal hydration coach")
                .font(.title2)
                .foregroundColor(.secondary)
            
            Spacer()
            
            Button(action: { viewModel.moveToNextStep() }) {
                Text("Get Started")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(15)
            }
            .padding(.horizontal, 40)
            .padding(.bottom, 50)
        }
    }
}

// MARK: - Features View
struct FeaturesView: View {
    @ObservedObject var viewModel: OnboardingViewModel
    @State private var currentPage = 0
    
    var body: some View {
        VStack {
            TabView(selection: $currentPage) {
                ForEach(Array(viewModel.features.enumerated()), id: \.offset) { index, feature in
                    FeatureCard(feature: feature)
                        .tag(index)
                }
            }
            .tabViewStyle(.page)
            .indexViewStyle(.page(backgroundDisplayMode: .always))
            
            Button(action: {
                if currentPage < viewModel.features.count - 1 {
                    withAnimation {
                        currentPage += 1
                    }
                } else {
                    viewModel.moveToNextStep()
                }
            }) {
                Text(currentPage < viewModel.features.count - 1 ? "Next" : "Continue")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(15)
            }
            .padding(.horizontal, 40)
            .padding(.bottom, 50)
        }
    }
}

struct FeatureCard: View {
    let feature: OnboardingFeature
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: feature.iconName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 80, height: 80)
                .foregroundColor(.blue)
            
            Text(feature.title)
                .font(.title2)
                .fontWeight(.bold)
            
            Text(feature.description)
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .padding()
    }
}

// MARK: - Permissions View
struct PermissionsView: View {
    @ObservedObject var viewModel: OnboardingViewModel
    
    var body: some View {
        VStack(spacing: 30) {
            Image(systemName: "bell.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 80, height: 80)
                .foregroundColor(.blue)
            
            Text("Stay on Track")
                .font(.title)
                .fontWeight(.bold)
            
            Text("Hydrate+ will send you hourly reminders if you haven't hit your goal.")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Spacer()
            
            VStack(spacing: 15) {
                Button(action: {
                    viewModel.requestNotificationPermissions()
                    viewModel.moveToNextStep()
                }) {
                    Text("Enable Reminders")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(15)
                }
                
                Button(action: { viewModel.moveToNextStep() }) {
                    Text("Skip for now")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
            .padding(.horizontal, 40)
            .padding(.bottom, 50)
        }
    }
}

// MARK: - Completion View
struct CompletionView: View {
    @ObservedObject var viewModel: OnboardingViewModel
    let dismiss: DismissAction
    
    var body: some View {
        VStack(spacing: 30) {
            Image(systemName: "checkmark.circle.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 100)
                .foregroundColor(.green)
            
            Text("You're all set!")
                .font(.title)
                .fontWeight(.bold)
            
            Text("Let's start your hydration journey!")
                .font(.title2)
                .foregroundColor(.secondary)
            
            Spacer()
            
            Button(action: {
                viewModel.completeOnboarding()
                dismiss()
            }) {
                Text("Start Tracking")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(15)
            }
            .padding(.horizontal, 40)
            .padding(.bottom, 50)
        }
    }
}
