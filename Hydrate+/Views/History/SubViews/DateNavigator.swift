//
//  DateNavigator.swift
//  Hydrate+
//
//  Created by Ian   on 19/04/2025.
//

import SwiftUI

struct DateNavigator: View {
    let timeFrame: TimeFrame
    let date: Date
    let onPrevious: () -> Void
    let onNext: () -> Void
    
    var body: some View {
        HStack {
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
            
            Text(DateFormatters.formatTimeFrame(date: date, timeFrame: timeFrame))
                .font(.headline)
                .foregroundStyle(Color.blue)
            
            Spacer()
            
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
