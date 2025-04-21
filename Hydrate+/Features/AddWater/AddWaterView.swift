//
//  AddWaterView.swift
//  Hydrate+
//
//  Created by Ian   on 11/04/2025.
//

import SwiftUI

struct AddWaterView: View {
    @Binding var waterConsumed: Double
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: WaterViewModel
    
    @State private var selectedAmount: Double = 250
    @State private var customAmount: String = ""
    @State private var isCustomAmount: Bool = false
    
    private let presetAmounts: [Double] = [100, 250, 330, 500, 750, 1000]
    
    // Computed properties to simplify complex expressions
    private var amountToAdd: Double {
        isCustomAmount ? (Double(customAmount) ?? 0) : selectedAmount
    }
    
    private var isAddButtonDisabled: Bool {
        isCustomAmount && (Double(customAmount) ?? 0) <= 0
    }
    
    private var addButtonOpacity: Double {
        isAddButtonDisabled ? 0.5 : 1.0
    }
    
    private var addButtonText: String {
        "Add \(Int(amountToAdd))ml"
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                // Title
                Text("Add Water")
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .foregroundStyle(Color.deepBlue)
                
                // Amount selection
                VStack(spacing: 16) {
                    // Preset amounts
                    if !isCustomAmount {
                        presetAmountsView
                    }
                    
                    // Custom amount
                    if isCustomAmount {
                        customAmountView
                    }
                    
                    // Toggle between preset and custom
                    toggleButton
                }
                
                Spacer()
                
                // Add button - simplified by using computed properties
                Button {
                    if amountToAdd > 0 {
                        waterConsumed += amountToAdd
                        viewModel.logWater(amount: amountToAdd)
                    }
                    dismiss()
                } label: {
                    Text(addButtonText)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(.white)
                        .frame(height: 56)
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                }
                .disabled(isAddButtonDisabled)
                .opacity(addButtonOpacity)

            }
            .padding(24)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 20))
                            .foregroundStyle(Color.gray)
                    }
                }
            }
        }
        .presentationDetents([.medium])
        .presentationDragIndicator(.visible)
    }
    
    // MARK: - Extracted Views
    
    private var presetAmountsView: some View {
        VStack(spacing: 12) {
            Text("Select Amount")
                .font(.headline)
                .foregroundStyle(Color.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                ForEach(presetAmounts, id: \.self) { amount in
                    presetAmountButton(amount)
                }
            }
        }
    }
    
    private func presetAmountButton(_ amount: Double) -> some View {
        Button {
            selectedAmount = amount
        } label: {
            Text("\(Int(amount))ml")
                .font(.system(size: 16, weight: .medium))
                .padding(.vertical, 12)
                .frame(maxWidth: .infinity)
                .background(selectedAmount == amount ? Color.blue : Color.gray.opacity(0.1))
                .foregroundStyle(selectedAmount == amount ? .white : .primary)
                .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }
    
    private var customAmountView: some View {
        VStack(spacing: 12) {
            Text("Enter Custom Amount")
                .font(.headline)
                .foregroundStyle(Color.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            TextField("Amount in ml", text: $customAmount)
                .keyboardType(.numberPad)
                .font(.system(size: 18, weight: .medium))
                .padding()
                .background(Color.gray.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }
    
    private var toggleButton: some View {
        Button {
            isCustomAmount.toggle()
        } label: {
            Text(isCustomAmount ? "Use Preset Amounts" : "Enter Custom Amount")
                .font(.subheadline)
                .foregroundStyle(Color.blue)
        }
    }
}

#Preview {
    AddWaterView(waterConsumed: .constant(1000), viewModel: WaterViewModel(userID: "UserID"))
}

