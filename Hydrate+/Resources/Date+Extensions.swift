
//
//  Date+Extensions.swift
//  Hydrate+
//
//  Created by Ian   on 11/04/2025.
//

/*
 This file contains extensions to the Date class that provide custom formatting
 functionality. It adds convenience methods to format dates in specific ways,
 making it easier to display dates throughout the Hydrate+ app.
 */


import Foundation

extension Date {
    var formattedAsDayMonth: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMMM d"
        return formatter.string(from: self)
    }
}
