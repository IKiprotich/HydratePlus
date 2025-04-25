//
//  HistoryView.swift
//  Hydrate+
//
//  Created by Ian   on 11/04/2025.
//

import SwiftUI
import FirebaseAuth

struct HistoryView: View {
    @State private var selectedTimeFrame: TimeFrame = .week
    @State private var selectedDate: Date = Date()
    @State private var showingDetailView = false
    @State private var selectedHistoryItem: HistoryItem?

    @StateObject private var viewModel: WaterViewModel

    private let dailyGoal: Double = 2000

    init() {
        let userID = Auth.auth().currentUser?.uid ?? "defaultUserID"
        _viewModel = StateObject(wrappedValue: WaterViewModel(userID: userID))
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                TimeFramePicker(selectedTimeFrame: $selectedTimeFrame)

                DateNavigator(
                    timeFrame: selectedTimeFrame,
                    date: selectedDate,
                    onPrevious: moveDateBackward,
                    onNext: moveDateForward
                )

                // Use .constant and compute the grouped data directly
                WaterConsumptionChart(
                    data: viewModel.getGroupedData(for: selectedDate, timeFrame: selectedTimeFrame),
                    dailyGoal: dailyGoal,
                    maxHeight: 200
                )
                .padding(.horizontal)

                List {
                    Section(header: Text("Detailed History")) {
                        ForEach(viewModel.getHistoryItems(for: selectedDate, timeFrame: selectedTimeFrame, dailyGoal: dailyGoal)) { item in
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
                    let logsForDate = viewModel.waterLogs.filter {
                        Calendar.current.isDate($0.time, inSameDayAs: item.date)
                    }

                    HistoryDetailView(
                        date: item.date,
                        logs: logsForDate,
                        totalAmount: item.totalAmount,
                        dailyGoal: item.dailyGoal
                    )
                }
            }
        }
        .task {
            await viewModel.fetchLogs()
        }
    }

    private func moveDateBackward() {
        selectedDate = Calendar.current.date(byAdding: selectedTimeFrame.dateComponent, value: -1, to: selectedDate)!
    }

    private func moveDateForward() {
        selectedDate = Calendar.current.date(byAdding: selectedTimeFrame.dateComponent, value: 1, to: selectedDate)!
    }
}
