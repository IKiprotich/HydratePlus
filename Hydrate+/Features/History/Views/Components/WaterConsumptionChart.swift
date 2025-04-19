//
//  WaterConsumptionChart.swift
//  Hydrate+
//
//  Created by Ian   on 19/04/2025.
//

import SwiftUI

struct WaterConsumptionChart: View {
    let data: [WaterConsumptionData]
    let dailyGoal: Double
    let maxHeight: CGFloat
    
    @State private var animateChart = false
    
    // Computed properties to simplify expressions
    private var maxValue: Double {
        max(data.map { $0.amount }.max() ?? 0, dailyGoal * 0.5)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            // Chart header
            chartHeader
            
            // Chart content
            chartContent
            
            // Legend
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
            // Reset animation when data changes
            animateChart = false
            withAnimation(.easeOut(duration: 0.8)) {
                animateChart = true
            }
        }
    }
    
    // MARK: - Extracted Views
    
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
    
    private var chartContent: some View {
        ZStack(alignment: .trailing) {
            // Goal line
            GoalLineView(
                goalValue: dailyGoal,
                maxValue: maxValue,
                maxHeight: maxHeight
            )
            
            // Chart bars
            chartBars
        }
        .frame(height: maxHeight)
        .padding(.top, 10)
    }
    
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

#Preview {
    WaterConsumptionChart(
        data: HistoryDataService.getConsumptionData(for: Date(), timeFrame: .week),
        dailyGoal: 2000,
        maxHeight: 200
    )
    .padding()
    .background(Color.gray.opacity(0.1))
}
