//
//  HistoryDetailView.swift
//  Hydrate+
//
//  Created by Ian   on 19/04/2025.
//

import SwiftUI

struct HistoryDetailView: View {
    let date: Date
    let logs: [WaterLog]
    let totalAmount: Double
    let dailyGoal: Double
    
    var progress: Int {
        Int(min(totalAmount / dailyGoal * 100, 100))
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Summary card
                summaryCard
                
                // Logs list
                logsListSection
            }
            .padding(.vertical)
        }
        .navigationTitle("Daily Detail")
        .navigationBarTitleDisplayMode(.inline)
        .background(
            LinearGradient(
                gradient: Gradient(colors: [.white, Color.lightBlue.opacity(0.2)]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
        )
    }
    
    // MARK: - Extracted Views
    
    private var summaryCard: some View {
        VStack(spacing: 16) {
            // Date
            Text(date, style: .date)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundStyle(Color.blue)
            
            // Progress circle
            ProgressCircleView(
                progress: progress,
                size: 160,
                lineWidth: 12
            ) {
                VStack(spacing: 4) {
                    Text("\(Int(totalAmount))ml")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundStyle(Color.primary)
                    
                    Text("\(progress)% of goal")
                        .font(.subheadline)
                        .foregroundStyle(Color.secondary)
                }
            }
            .padding(.vertical, 10)
            
            // Summary stats
            HStack(spacing: 20) {
                StatBox(
                    title: "Goal",
                    value: "\(Int(dailyGoal))ml",
                    icon: "target",
                    color: .purple
                )
                
                StatBox(
                    title: "Intake",
                    value: "\(logs.count) times",
                    icon: "drop.fill",
                    color: Color.blue
                )
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
        )
        .padding(.horizontal)
    }
    
    private var logsListSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Water Logs")
                .font(.headline)
                .padding(.horizontal)
            
            ForEach(logs) { log in
                WaterLogDetailItem(log: log)
                    .padding(.horizontal)
            }
        }
    }
}

#Preview {
    NavigationStack {
        HistoryDetailView(
            date: Date(),
            logs: [
                WaterLog(amount: 250, time: Calendar.current.date(bySettingHour: 8, minute: 30, second: 0, of: Date())!),
                WaterLog(amount: 500, time: Calendar.current.date(bySettingHour: 12, minute: 15, second: 0, of: Date())!),
                WaterLog(amount: 350, time: Calendar.current.date(bySettingHour: 15, minute: 45, second: 0, of: Date())!),
                WaterLog(amount: 400, time: Calendar.current.date(bySettingHour: 18, minute: 30, second: 0, of: Date())!)
            ],
            totalAmount: 1500,
            dailyGoal: 2000
        )
    }
}

