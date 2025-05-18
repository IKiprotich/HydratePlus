//
//  HistoryDetailView.swift
//  Hydrate+
//
//  Created by Ian   on 19/04/2025.
//

import SwiftUI

/// A view that displays detailed information about water intake for a specific day.
/// This view shows a summary of the day's water consumption, progress towards the daily goal,
/// and a chronological list of all water intake logs for that day.
struct HistoryDetailView: View {
    /// The date for which the history is being displayed
    let date: Date
    /// Array of water intake logs for the selected date
    let logs: [WaterLog]
    /// Total amount of water consumed for the day in milliliters
    let totalAmount: Double
    /// Daily water intake goal in milliliters
    let dailyGoal: Double
    
    /// Calculates the progress percentage towards the daily goal
    /// Returns a value between 0 and 100
    var progress: Int {
        Int(min(totalAmount / dailyGoal * 100, 100))
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                summaryCard
                

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
    
    /// A card view that displays the summary of the day's water intake
    /// Includes:
    /// - The date
    /// - A circular progress indicator showing goal completion
    /// - Total amount consumed
    /// - Key statistics (goal amount and number of intake sessions)
    private var summaryCard: some View {
        VStack(spacing: 16) {
            Text(date, style: .date)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundStyle(Color.blue)
            
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
    
    /// A section that displays all water intake logs for the day
    /// Each log entry shows the time and amount of water consumed
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

