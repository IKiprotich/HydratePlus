//
//  Date+Extensions.swift
//  Hydrate+
//
//  Created by Ian   on 11/04/2025.
//

import Foundation

extension Date {
    var formattedAsDayMonth: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMMM d"
        return formatter.string(from: self)
    }
}
