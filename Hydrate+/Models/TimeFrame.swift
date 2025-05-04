//
//  TimeFrame.swift
//  Hydrate+
//
//  Created by Ian   on 19/04/2025.
//

import Foundation

enum TimeFrame: String, CaseIterable, Identifiable {
    case day = "Day"
    case week = "Week"
    case month = "Month"
    
    var id: String { self.rawValue }
    
    var dateComponent: Calendar.Component {
        switch self {
        case .day: return .day
        case .week: return .weekOfYear
        case .month: return .month
        }
    }
    
    var barCount: Int {
        switch self {
        case .day: return 6
        case .week: return 7 
        case .month: return min(Calendar.current.range(of: .day, in: .month, for: Date())?.count ?? 30, 31)
        }
    }
}
