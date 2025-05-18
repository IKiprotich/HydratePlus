//
//  TimeFramePicker.swift
//  Hydrate+
//
//  Created by Ian   on 19/04/2025.
//

import SwiftUI

/// A view component that provides a segmented control for selecting different time frames
/// in the app's history view. This picker allows users to switch between different
/// time periods (e.g., day, week, month) to view their hydration data.
///
/// The TimeFramePicker is designed to be reusable and can be integrated into any view
/// that needs time frame selection functionality. It uses a binding to communicate
/// the selected time frame back to its parent view.
struct TimeFramePicker: View {
    /// A binding to the selected time frame, allowing two-way communication
    /// between this view and its parent view. When the user selects a new time frame,
    /// this binding ensures the parent view is updated accordingly.
    @Binding var selectedTimeFrame: TimeFrame
    
    var body: some View {
        Picker("Time Frame", selection: $selectedTimeFrame) {
            ForEach(TimeFrame.allCases) { timeFrame in
                Text(timeFrame.rawValue).tag(timeFrame)
            }
        }
        .pickerStyle(SegmentedPickerStyle())
        .padding(.horizontal)
    }
}

/// A preview provider that demonstrates how the TimeFramePicker looks and functions
/// in the Xcode preview canvas. It creates a sample instance with a week time frame
/// selected by default.
#Preview {
    @State var selectedTimeFrame: TimeFrame = .week
    return TimeFramePicker(selectedTimeFrame: $selectedTimeFrame)
        .padding()
}
