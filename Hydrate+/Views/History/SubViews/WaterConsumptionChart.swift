//
//  WaterConsumptionChart.swift
//  Hydrate+
//
//  Created by Ian   on 19/04/2025.
//

import SwiftUI

/// A SwiftUI view component that displays a bar chart visualization of water consumption data.
/// This chart is a key feature of the Hydrate+ app, helping users track their daily water intake
/// against their personal goals through an interactive and animated visualization.
///
/// The chart includes:
/// - Animated bar representation of water consumption
/// - Visual goal line indicator
/// - Clear labeling and legend
/// - Responsive design that adapts to different screen sizes
///
/// This component is typically used in the History view to show water consumption trends
/// over different time periods (daily, weekly, monthly).
struct WaterConsumptionChart: View {
    /// The water consumption data points to be displayed in the chart
    let data: [WaterConsumptionData]
    
    /// The user's daily water intake goal in milliliters
    let dailyGoal: Double
    
    /// The maximum height constraint for the chart visualization
    let maxHeight: CGFloat
    
    /// State variable controlling the animation of the chart bars
    @State private var animateChart = false
    
    /// Computed property that determines the maximum value to be displayed on the chart
    /// Ensures the chart scale is appropriate by comparing the highest consumption value
    /// with at least 50% of the daily goal
    private var maxValue: Double {
        max(data.map { $0.amount }.max() ?? 0, dailyGoal * 0.5)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            chartHeader
            
            chartContent
            
            chartLegend
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
                .shadow(color: Color.blue.opacity(0.1), radius: 10, x: 0, y: 5)
        )
        .onAppear {
            withAnimation(.easeOut(duration: 0.8)) {
                animateChart = true
            }
        }
        .onChange(of: data) { _ in
            animateChart = false
            withAnimation(.easeOut(duration: 0.8)) {
                animateChart = true
            }
        }
    }
    
    // MARK: - Extracted Views
    
    /// Header section of the chart containing the title and daily goal information
    private var chartHeader: some View {
        HStack {
            Text("Water Consumption")
                .font(.headline)
                .foregroundStyle(Color.blue)
            
            Spacer()
            
            Text("Goal: \(Int(dailyGoal))ml")
                .font(.subheadline)
                .foregroundStyle(Color.secondary)
        }
    }
    
    /// Main chart content area containing the bars and goal line
    /// Uses a ZStack to overlay the goal line on top of the consumption bars
    private var chartContent: some View {
        ZStack(alignment: .trailing) {
            GoalLineView(
                goalValue: dailyGoal,
                maxValue: maxValue,
                maxHeight: maxHeight
            )
            
            chartBars
        }
        .frame(height: maxHeight)
        .padding(.top, 10)
    }
    
    /// Collection of individual chart bars representing water consumption data points
    /// Each bar is animated and sized proportionally to the maximum value
    private var chartBars: some View {
        HStack(alignment: .bottom, spacing: 8) {
            ForEach(Array(data.enumerated()), id: \.offset) { index, item in
                ChartBar(
                    amount: item.amount,
                    label: item.label,
                    maxValue: maxValue,
                    maxHeight: maxHeight,
                    isAnimated: animateChart
                )
            }
        }
        .padding(.bottom, 8)
    }
    
    /// Legend explaining the chart's data representation
    /// Helps users understand what the blue bars represent
    private var chartLegend: some View {
        HStack {
            Circle()
                .fill(Color.blue)
                .frame(width: 8, height: 8)
            
            Text("Water Consumption (ml)")
                .font(.caption)
                .foregroundStyle(Color.secondary)
            
            Spacer()
        }
    }
}

// MARK: - Preview
/// Preview provider for development and testing purposes
/// Shows a sample chart with weekly consumption data
#Preview {
    WaterConsumptionChart(
        data: HistoryDataService.getConsumptionData(for: Date(), timeFrame: .week),
        dailyGoal: 2000,
        maxHeight: 200
    )
    .padding()
    .background(Color.gray.opacity(0.1))
}
