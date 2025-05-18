//
//  DailyGoalView.swift
//  Hydrate+
//
//  Created by Ian   on 21/04/2025.
//

import SwiftUI

struct DailyGoalView: View {
    @ObservedObject var userVM: UserViewModel
    @State private var dailyGoal: Double
    @Environment(\.dismiss) var dismiss

    init(userVM: UserViewModel) {
        self.userVM = userVM
        self._dailyGoal = State(initialValue: userVM.user?.dailyGoal ?? 2000)
    }

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Set Daily Goal")) {
                    Slider(value: $dailyGoal, in: 1000...4000, step: 100) {
                        Text("Daily Goal")
                    } minimumValueLabel: {
                        Text("1000 ml")
                    } maximumValueLabel: {
                        Text("4000 ml")
                    }
                    Text("Daily Goal: \(Int(dailyGoal)) ml")
                }
            }
            .navigationTitle("Daily Goal")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        Task {
                            await userVM.updateDailyGoal(dailyGoal)
                            dismiss()
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    DailyGoalView(userVM: UserViewModel())
}
