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
    @State private var selectedAmount: Double = 250
    @State private var customAmount: String = ""
    @State private var isCustom: Bool = false
    
    let presetAmounts: [Double] = [100, 250, 500, 750, 1000]
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                // Water drop image
                Image(systemName: "drop.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 60, height: 60)
                    .foregroundColor(Color.waterBlue)
                    .padding()
                
                // Preset amounts
                Text("Select Amount (ml)")
                    .font(.headline)
                    .foregroundColor(Color.waterBlue)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(presetAmounts, id: \.self) { amount in
                            Button {
                                selectedAmount = amount
                                isCustom = false
                            } label: {
                                Text("\(Int(amount))")
                                    .font(.headline)
                                    .foregroundColor(selectedAmount == amount && !isCustom ? .white : Color.waterBlue)
                                    .frame(width: 70, height: 70)
                                    .background(
                                        Circle()
                                            .fill(selectedAmount == amount && !isCustom ? Color.waterBlue : Color.waterBlue.opacity(0.1))
                                    )
                            }
                        }
                        
                        // Custom amount button
                        Button {
                            isCustom = true
                        } label: {
                            Image(systemName: "plus")
                                .font(.headline)
                                .foregroundColor(isCustom ? .white : Color.waterBlue)
                                .frame(width: 70, height: 70)
                                .background(
                                    Circle()
                                        .fill(isCustom ? Color.waterBlue : Color.waterBlue.opacity(0.1))
                                )
                        }
                    }
                    .padding(.horizontal)
                }
                
                // Custom amount input
                if isCustom {
                    HStack {
                        TextField("Enter amount", text: $customAmount)
                            .keyboardType(.numberPad)
                            .font(.headline)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(12)
                            .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
                        
                        Text("ml")
                            .font(.headline)
                            .foregroundColor(.secondary)
                    }
                    .padding(.horizontal)
                }
                
                // Water type selection
                Text("Water Type")
                    .font(.headline)
                    .foregroundColor(Color.waterBlue)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                
                HStack(spacing: 16) {
                    WaterTypeButton(icon: "drop.fill", label: "Water", isSelected: true)
                    WaterTypeButton(icon: "mug.fill", label: "Coffee", isSelected: false)
                    WaterTypeButton(icon: "leaf.fill", label: "Tea", isSelected: false)
                }
                
                Spacer()
                
                // Add water button
                Button {
                    let amountToAdd = isCustom ? (Double(customAmount) ?? 0) : selectedAmount
                    waterConsumed += amountToAdd
                    dismiss()
                } label: {
                    Text("Add \(isCustom ? (customAmount.isEmpty ? "0" : customAmount) : "\(Int(selectedAmount))") ml")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.waterBlue)
                        .cornerRadius(16)
                        .shadow(color: Color.waterBlue.opacity(0.4), radius: 5, x: 0, y: 3)
                }
                .padding(.horizontal)
                .disabled(isCustom && (customAmount.isEmpty || Double(customAmount) == 0))
                .opacity(isCustom && (customAmount.isEmpty || Double(customAmount) == 0) ? 0.5 : 1)
            }
            .padding(.top)
            .navigationTitle("Add Water")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Text("Cancel")
                            .foregroundColor(Color.waterBlue)
                    }
                }
            }
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [.white, Color.lightBlue.opacity(0.2)]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .edgesIgnoringSafeArea(.all)
            )
        }
    }
}

struct WaterTypeButton: View {
    let icon: String
    let label: String
    let isSelected: Bool
    
    var body: some View {
        VStack {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(isSelected ? .white : Color.waterBlue)
                .frame(width: 60, height: 60)
                .background(
                    Circle()
                        .fill(isSelected ? Color.waterBlue : Color.waterBlue.opacity(0.1))
                )
            
            Text(label)
                .font(.caption)
                .foregroundColor(isSelected ? Color.waterBlue : .secondary)
        }
    }
}

#Preview {
    AddWaterView()
}
