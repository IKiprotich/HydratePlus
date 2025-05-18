//
//  AddWaterView.swift
//  Hydrate+
//
//  Created by Ian   on 11/04/2025.
//

/// AddWaterView is a SwiftUI view that provides an interface for users to add water intake to their daily tracking.
/// This view is presented as a modal sheet and allows users to either select from preset amounts or enter a custom amount.
///
/// Key Features:
/// - Preset water amounts (100ml, 250ml, 330ml, 500ml, 750ml, 1000ml)
/// - Custom amount input option
/// - Real-time validation of input
/// - Smooth transitions between preset and custom modes
///
/// The view integrates with WaterViewModel to persist the water intake data.
import SwiftUI

struct AddWaterView: View {
    // MARK: - Environment & Properties
    
    /// Environment variable to handle view dismissal
    @Environment(\.dismiss) private var dismiss
    
    /// ViewModel that handles water intake data and business logic
    @ObservedObject var viewModel: WaterViewModel
    
    /// State variables to manage the view's UI state
    @State private var selectedAmount: Double = 250
    @State private var customAmount: String = ""
    @State private var isCustomAmount: Bool = false
    
    /// Predefined water amounts available for quick selection
    private let presetAmounts: [Double] = [100, 250, 330, 500, 750, 1000]
    
    // MARK: - Computed Properties
    
    /// Calculates the final amount to be added based on whether custom or preset amount is selected
    private var amountToAdd: Double {
        isCustomAmount ? (Double(customAmount) ?? 0) : selectedAmount
    }
    
    /// Determines if the add button should be disabled based on input validation
    private var isAddButtonDisabled: Bool {
        isCustomAmount && (Double(customAmount) ?? 0) <= 0
    }
    
    /// Controls the opacity of the add button based on its disabled state
    private var addButtonOpacity: Double {
        isAddButtonDisabled ? 0.5 : 1.0
    }
    
    /// Generates the text for the add button showing the current amount
    private var addButtonText: String {
        "Add \(Int(amountToAdd))ml"
    }
    
    // MARK: - Body
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                // Title section
                Text("Add Water")
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .foregroundStyle(Color.deepBlue)
                
                // Main content section containing amount selection
                VStack(spacing: 16) {
                    // Shows either preset amounts or custom input based on mode
                    if !isCustomAmount {
                        presetAmountsView
                    }
                    
                    if isCustomAmount {
                        customAmountView
                    }
                    
                    // Mode toggle button
                    toggleButton
                }
                
                Spacer()
                
                // Add button section
                Button {
                    if amountToAdd > 0 {
                        Task {
                            await viewModel.addWater(amount: amountToAdd)
                        }
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
    
    // MARK: - Subviews
    
    /// Displays a grid of preset water amounts for quick selection
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
    
    /// Creates a button for each preset amount with appropriate styling
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
    
    /// Provides a text field for entering custom water amounts
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
    
    /// Toggle button to switch between preset and custom amount modes
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
    AddWaterView(viewModel: WaterViewModel(userID: "UserID"))
}

