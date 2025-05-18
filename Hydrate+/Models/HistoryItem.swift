//
//  HistoryItem.swift
//  Hydrate+
//
//  Created by Ian   on 19/04/2025.
//

/// Represents a daily water intake record in the Hydrate+ app.
/// This model stores the total amount of water consumed for a specific date,
/// tracks progress towards the daily goal, and provides formatted strings
/// for displaying the date and amount in the UI.

import Foundation

struct HistoryItem: Identifiable {
    let id: UUID = UUID()
    let date: Date
    let totalAmount: Double
    let dailyGoal: Double
    
    var progress: Int {
        Int(min(totalAmount / dailyGoal * 100, 100))
    }
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        return formatter.string(from: date)
    }
    
    var formattedAmount: String {
        "\(Int(totalAmount)) ml"
    }
}
