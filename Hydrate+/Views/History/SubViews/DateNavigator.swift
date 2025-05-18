//
//  DateNavigator.swift
//  Hydrate+
//
//  Created by Ian   on 19/04/2025.
//

import SwiftUI

/// A reusable navigation component that allows users to move between different time periods
/// in the app's history view. This component is used to navigate through daily, weekly,
/// or monthly views of hydration data.
///
/// The DateNavigator provides a consistent UI pattern for temporal navigation across the app,
/// featuring previous/next buttons and a formatted date display that adapts based on the
/// selected time frame.
struct DateNavigator: View {
    /// The time frame being displayed (e.g., day, week, month)
    let timeFrame: TimeFrame
    
    /// The currently selected date
    let date: Date
    
    /// Callback function triggered when the user wants to view the previous time period
    let onPrevious: () -> Void
    
    /// Callback function triggered when the user wants to view the next time period
    let onNext: () -> Void
    
    var body: some View {
        HStack {
            // Previous period button
            Button {
                onPrevious()
            } label: {
                Image(systemName: "chevron.left")
                    .foregroundStyle(Color.blue)
                    .font(.title3)
                    .padding(8)
                    .background(Color.blue.opacity(0.1))
                    .clipShape(Circle())
            }
            
            Spacer()
            
            // Current time period display
            Text(DateFormatters.formatTimeFrame(date: date, timeFrame: timeFrame))
                .font(.headline)
                .foregroundStyle(Color.blue)
            
            Spacer()
            
            // Next period button
            Button {
                onNext()
            } label: {
                Image(systemName: "chevron.right")
                    .foregroundStyle(Color.blue)
                    .font(.title3)
                    .padding(8)
                    .background(Color.blue.opacity(0.1))
                    .clipShape(Circle())
            }
        }
        .padding(.horizontal, 20)
    }
}

#Preview {
    DateNavigator(
        timeFrame: .week,
        date: Date(),
        onPrevious: {},
        onNext: {}
    )
    .padding()
}
