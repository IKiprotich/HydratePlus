//
//  HistoryView.swift
//  Hydrate+
//
//  Created by Ian   on 11/04/2025.
//

import SwiftUI
import FirebaseAuth

/// HistoryView is the main view for displaying water consumption history and statistics.
/// It provides a comprehensive interface for users to view their water intake patterns
/// across different time frames (day, week, month) and access detailed information
/// about their consumption history.
struct HistoryView: View {
    // MARK: - Properties
    
    /// The currently selected time frame for viewing history (day, week, or month)
    @State private var selectedTimeFrame: TimeFrame = .week
    
    /// The currently selected date for viewing history
    @State private var selectedDate: Date = Date()
    
    /// Controls the presentation of the detail view
    @State private var showingDetailView = false
    
    /// The selected history item for detailed view
    @State private var selectedHistoryItem: HistoryItem?
    
    /// View model that manages water consumption data and business logic
    @StateObject private var viewModel: WaterViewModel
    
    /// The daily water consumption goal in milliliters
    private let dailyGoal: Double = 2000
    
    // MARK: - Initialization
    
    /// Initializes the view with the current user's ID from Firebase Auth
    init() {
        let userID = Auth.auth().currentUser?.uid ?? "defaultUserID"
        _viewModel = StateObject(wrappedValue: WaterViewModel(userID: userID))
    }
    
    // MARK: - Body
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                // Time frame selector for switching between day, week, and month views
                TimeFramePicker(selectedTimeFrame: $selectedTimeFrame)
                
                // Date navigation controls for moving between different time periods
                DateNavigator(
                    timeFrame: selectedTimeFrame,
                    date: selectedDate,
                    onPrevious: moveDateBackward,
                    onNext: moveDateForward
                )
                
                // Visual representation of water consumption data
                WaterConsumptionChart(
                    data: viewModel.getGroupedData(for: selectedDate, timeFrame: selectedTimeFrame),
                    dailyGoal: dailyGoal,
                    maxHeight: 200
                )
                .padding(.horizontal)
                
                // List of detailed history entries
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
            // Background gradient for visual appeal
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [.white, Color.lightBlue.opacity(0.2)]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
            )
            .navigationTitle("History")
            // Navigation to detail view when an item is selected
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
        // Fetch water consumption logs when the view appears
        .task {
            await viewModel.fetchLogs()
        }
    }
    
    // MARK: - Helper Methods
    
    /// Moves the selected date backward by one time frame unit
    private func moveDateBackward() {
        selectedDate = Calendar.current.date(byAdding: selectedTimeFrame.dateComponent, value: -1, to: selectedDate)!
    }
    
    /// Moves the selected date forward by one time frame unit
    private func moveDateForward() {
        selectedDate = Calendar.current.date(byAdding: selectedTimeFrame.dateComponent, value: 1, to: selectedDate)!
    }
}
