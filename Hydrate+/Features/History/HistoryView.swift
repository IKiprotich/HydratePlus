//
//  HistoryView.swift
//  Hydrate+
//
//  Created by Ian   on 11/04/2025.
//

import SwiftUI

struct HistoryView: View {
    @State private var selectedTimeFrame: TimeFrame = .week
    @State private var selectedDate: Date = Date()
    @State private var showingDetailView = false
    @State private var selectedHistoryItem: HistoryItem?
    
    // In a real app, this would be fetched from user settings
    private let dailyGoal: Double = 2000
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                // Time frame picker
                TimeFramePicker(selectedTimeFrame: $selectedTimeFrame)
                
                // Date selector
                DateNavigator(
                    timeFrame: selectedTimeFrame,
                    date: selectedDate,
                    onPrevious: moveDateBackward,
                    onNext: moveDateForward
                )
                
                // Water consumption chart
                WaterConsumptionChart(
                    data: HistoryDataService.getConsumptionData(
                        for: selectedDate,
                        timeFrame: selectedTimeFrame
                    ),
                    dailyGoal: dailyGoal,
                    maxHeight: 200
                )
                .padding(.horizontal)
                
                // Detailed history list
                List {
                    Section(header: Text("Detailed History")) {
                        ForEach(HistoryDataService.getHistoryItems(dailyGoal: dailyGoal)) { item in
                            HistoryListItem(item: item) {
                                selectedHistoryItem = item
                                showingDetailView = true
                            }
                        }
                    }
                }
                .listStyle(InsetGroupedListStyle())
            }
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [.white, Color.lightBlue.opacity(0.2)]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
            )
            .navigationTitle("History")
            .navigationDestination(isPresented: $showingDetailView) {
                if let item = selectedHistoryItem {
                    // In a real app, you would fetch the actual logs for this date
                    let sampleLogs = [
                        WaterLog(amount: 250, time: Calendar.current.date(bySettingHour: 8, minute: 30, second: 0, of: item.date)!),
                        WaterLog(amount: 500, time: Calendar.current.date(bySettingHour: 12, minute: 15, second: 0, of: item.date)!),
                        WaterLog(amount: 350, time: Calendar.current.date(bySettingHour: 15, minute: 45, second: 0, of: item.date)!),
                        WaterLog(amount: 400, time: Calendar.current.date(bySettingHour: 18, minute: 30, second: 0, of: item.date)!)
                    ]
                    
                    HistoryDetailView(
                        date: item.date,
                        logs: sampleLogs,
                        totalAmount: item.totalAmount,
                        dailyGoal: item.dailyGoal
                    )
                }
            }
        }
    }
    
    // Helper methods
    private func moveDateBackward() {
        let calendar = Calendar.current
        selectedDate = calendar.date(byAdding: selectedTimeFrame.dateComponent, value: -1, to: selectedDate)!
    }
    
    private func moveDateForward() {
        let calendar = Calendar.current
        selectedDate = calendar.date(byAdding: selectedTimeFrame.dateComponent, value: 1, to: selectedDate)!
    }
}

#Preview {
    HistoryView()
}
