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
    
    enum TimeFrame: String, CaseIterable, Identifiable {
        case day = "Day"
        case week = "Week"
        case month = "Month"
        
        var id: String { self.rawValue }
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                // Time frame picker
                Picker("Time Frame", selection: $selectedTimeFrame) {
                    ForEach(TimeFrame.allCases) { timeFrame in
                        Text(timeFrame.rawValue).tag(timeFrame)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)
                
                // Date selector
                HStack {
                    Button {
                        moveDateBackward()
                    } label: {
                        Image(systemName: "chevron.left")
                            .foregroundColor(Color.waterBlue)
                            .font(.title3)
                    }
                    
                    Spacer()
                    
                    Text(formattedTimeFrame)
                        .font(.headline)
                        .foregroundColor(Color.waterBlue)
                    
                    Spacer()
                    
                    Button {
                        moveDateForward()
                    } label: {
                        Image(systemName: "chevron.right")
                            .foregroundColor(Color.waterBlue)
                            .font(.title3)
                    }
                }
                .padding(.horizontal, 30)
                
                // Water consumption chart
                VStack(alignment: .leading, spacing: 10) {
                    Text("Water Consumption")
                        .font(.headline)
                        .foregroundColor(Color.waterBlue)
                    
                    HStack(alignment: .bottom, spacing: 8) {
                        ForEach(0..<getNumberOfBars(), id: \.self) { index in
                            let amount = getSampleDataForBar(index: index)
                            
                            VStack {
                                // Bar
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(
                                        LinearGradient(
                                            gradient: Gradient(colors: [Color.lightBlue, Color.waterBlue]),
                                            startPoint: .top,
                                            endPoint: .bottom
                                        )
                                    )
                                    .frame(height: CGFloat(amount) / 5)
                                
                                // Day/date label
                                Text(getBarLabel(index: index))
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            .frame(maxWidth: .infinity)
                        }
                    }
                    .frame(height: 200)
                    .padding(.top, 10)
                    
                    // Legend
                    HStack {
                        Circle()
                            .fill(Color.waterBlue)
                            .frame(width: 10, height: 10)
                        
                        Text("Water Consumption (ml)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Spacer()
                        
                        Text("Daily Goal: 2000ml")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                .padding()
                .background(Color.white)
                .cornerRadius(16)
                .shadow(color: Color.waterBlue.opacity(0.1), radius: 10, x: 0, y: 5)
                .padding(.horizontal)
                
                // Detailed history list
                List {
                    Section(header: Text("Detailed History")) {
                        ForEach(getHistoryItems()) { item in
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(item.date)
                                        .font(.headline)
                                    
                                    Text("\(item.totalAmount) ml • \(item.progress)% of daily goal")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                }
                                
                                Spacer()
                                
                                Circle()
                                    .trim(from: 0, to: CGFloat(Double(item.progress) / 100))
                                    .stroke(
                                        LinearGradient(
                                            gradient: Gradient(colors: [Color.lightBlue, Color.waterBlue]),
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        ),
                                        style: StrokeStyle(lineWidth: 4, lineCap: .round)
                                    )
                                    .rotationEffect(.degrees(-90))
                                    .frame(width: 40, height: 40)
                                    .overlay(
                                        Text("\(item.progress)%")
                                            .font(.system(size: 10))
                                            .foregroundColor(Color.waterBlue)
                                    )
                            }
                            .padding(.vertical, 4)
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
                .edgesIgnoringSafeArea(.all)
            )
            .navigationTitle("History")
        }
    }
    
    // Helper methods
    private var formattedTimeFrame: String {
        let formatter = DateFormatter()
        
        switch selectedTimeFrame {
        case .day:
            formatter.dateFormat = "MMMM d, yyyy"
            return formatter.string(from: selectedDate)
        case .week:
            let calendar = Calendar.current
            let weekStart = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: selectedDate))!
            let weekEnd = calendar.date(byAdding: .day, value: 6, to: weekStart)!
            
            formatter.dateFormat = "MMM d"
            let startString = formatter.string(from: weekStart)
            let endString = formatter.string(from: weekEnd)
            
            return "\(startString) - \(endString)"
        case .month:
            formatter.dateFormat = "MMMM yyyy"
            return formatter.string(from: selectedDate)
        }
    }
    
    private func moveDateBackward() {
        let calendar = Calendar.current
        switch selectedTimeFrame {
        case .day:
            selectedDate = calendar.date(byAdding: .day, value: -1, to: selectedDate)!
        case .week:
            selectedDate = calendar.date(byAdding: .weekOfYear, value: -1, to: selectedDate)!
        case .month:
            selectedDate = calendar.date(byAdding: .month, value: -1, to: selectedDate)!
        }
    }
    
    private func moveDateForward() {
        let calendar = Calendar.current
        switch selectedTimeFrame {
        case .day:
            selectedDate = calendar.date(byAdding: .day, value: 1, to: selectedDate)!
        case .week:
            selectedDate = calendar.date(byAdding: .weekOfYear, value: 1, to: selectedDate)!
        case .month:
            selectedDate = calendar.date(byAdding: .month, value: 1, to: selectedDate)!
        }
    }
    
    private func getNumberOfBars() -> Int {
        switch selectedTimeFrame {
        case .day:
            return 6  // 6 time slots in a day
        case .week:
            return 7  // 7 days in a week
        case .month:
            return 30 // Approx 30 days in a month
        }
    }
    
    private func getSampleDataForBar(index: Int) -> Int {
        // This would be replaced with actual data in a real app
        // Sample data for demonstration
        switch selectedTimeFrame {
        case .day:
            return [300, 500, 200, 350, 400, 250][index % 6]
        case .week:
            return [1500, 1800, 2100, 1600, 2200, 1900, 1700][index % 7]
        case .month:
            return (index % 4 == 0) ? 1500 : ((index % 3 == 0) ? 2200 : ((index % 2 == 0) ? 1800 : 1900))
        }
    }
    
    private func getBarLabel(index: Int) -> String {
        let formatter = DateFormatter()
        let calendar = Calendar.current
        
        switch selectedTimeFrame {
        case .day:
            let times = ["Morning", "Noon", "Afternoon", "Evening", "Night", "Late"]
            return times[index % times.count]
        case .week:
            formatter.dateFormat = "E"
            let weekStart = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: selectedDate))!
            let day = calendar.date(byAdding: .day, value: index, to: weekStart)!
            return formatter.string(from: day)
        case .month:
            formatter.dateFormat = "d"
            let monthStart = calendar.date(from: calendar.dateComponents([.year, .month], from: selectedDate))!
            let day = calendar.date(byAdding: .day, value: index, to: monthStart)!
            return formatter.string(from: day)
        }
    }
    
    // Sample history items
    private func getHistoryItems() -> [HistoryItem] {
        let calendar = Calendar.current
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        
        var items: [HistoryItem] = []
        
        for i in 0..<7 {
            let date = calendar.date(byAdding: .day, value: -i, to: Date())!
            let amount = (i % 3 == 0) ? 1500 : ((i % 2 == 0) ? 2100 : 1800)
            let progress = amount * 100 / 2000
            
            items.append(HistoryItem(
                id: i,
                date: formatter.string(from: date),
                totalAmount: amount,
                progress: progress
            ))
        }
        
        return items
    }
}

// Model for history items
struct HistoryItem: Identifiable {
    let id: Int
    let date: String
    let totalAmount: Int
    let progress: Int
}

#Preview {
    HistoryView()
}
