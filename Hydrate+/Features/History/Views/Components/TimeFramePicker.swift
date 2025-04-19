//
//  TimeFramePicker.swift
//  Hydrate+
//
//  Created by Ian   on 19/04/2025.
//

import SwiftUI

struct TimeFramePicker: View {
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

#Preview {
    @State var selectedTimeFrame: TimeFrame = .week
    return TimeFramePicker(selectedTimeFrame: $selectedTimeFrame)
        .padding()
        .previewLayout(.sizeThatFits)
}
