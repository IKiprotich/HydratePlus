//
//  HomeView.swift
//  Hydrate+
//
//  Created by Ian   on 11/04/2025.
//

import SwiftUI

struct HomeView: View {
    @State private var waterConsumed: Double = 0
    @State private var dailyGoal: Double = 2000
    @State private var showingAddWaterSheet = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Water progress card
                    WaterProgressCard(waterConsumed: waterConsumed, dailyGoal: dailyGoal) {
                        showingAddWaterSheet = true
                    }

                    // Recent water log
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Today's Water Log")
                            .font(.headline)
                            .foregroundColor(Color.waterBlue)
                            .padding(.horizontal)

                        ForEach(getSampleWaterLogs(), id: \.id) { log in
                            WaterLogItem(log: log)
                        }

                        Button {
                            // Navigate to detailed logs view
                        } label: {
                            Text("View All Logs")
                                .font(.subheadline)
                                .foregroundColor(Color.waterBlue)
                                .padding(.vertical, 8)
                                .frame(maxWidth: .infinity)
                                .background(Color.waterBlue.opacity(0.1))
                                .cornerRadius(8)
                        }
                        .padding(.horizontal)
                    }
                    .padding(.bottom, 24)
                }
            }
            .navigationTitle("Hydrate+")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        // Open settings
                    } label: {
                        Image(systemName: "gearshape.fill")
                            .foregroundColor(Color.waterBlue)
                    }
                }
            }
            .sheet(isPresented: $showingAddWaterSheet) {
                AddWaterView(waterConsumed: $waterConsumed)
            }
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [.white, Color.lightBlue.opacity(0.2)]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .edgesIgnoringSafeArea(.all)
            )
        }
    }
}

#Preview {
    HomeView()
}
