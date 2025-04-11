//
//  HomeView.swift
//  Hydrate+
//
//  Created by Ian   on 11/04/2025.
//

import SwiftUI

struct HomeView: View {
    @State private var waterConsumed: Double = 0
    @State private var dailyGoal: Double = 2000 // ml
    @State private var showingAddWaterSheet = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Water progress card
                    ZStack {
                        // Background card
                        RoundedRectangle(cornerRadius: 16)
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: [Color.white, Color.lightBlue.opacity(0.3)]),
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                            .shadow(color: Color.waterBlue.opacity(0.2), radius: 10, x: 0, y: 5)
                        
                        VStack(spacing: 20) {
                            // Today's date
                            Text(formattedDate)
                                .font(.headline)
                                .foregroundColor(.secondary)
                                .padding(.top, 12)
                            
                            // Water progress visualization
                            ZStack {
                                // Water container shape
                                WaterBottleShape()
                                    .stroke(Color.waterBlue, lineWidth: 3)
                                    .frame(width: 120, height: 250)
                                
                                // Water fill level
                                WaterFillShape(fillLevel: CGFloat(waterConsumed / dailyGoal))
                                    .fill(
                                        LinearGradient(
                                            gradient: Gradient(colors: [Color.lightBlue, Color.waterBlue]),
                                            startPoint: .top,
                                            endPoint: .bottom
                                        )
                                    )
                                    .frame(width: 120, height: 250)
                                    .animation(.spring(), value: waterConsumed)
                                
                                // Percentage text
                                Text("\(Int((waterConsumed / dailyGoal) * 100))%")
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                    .shadow(color: Color.black.opacity(0.2), radius: 2, x: 0, y: 1)
                            }
                            
                            // Water consumed text
                            Text("\(Int(waterConsumed)) / \(Int(dailyGoal)) ml")
                                .font(.title3)
                                .fontWeight(.semibold)
                                .foregroundColor(Color.waterBlue)
                            
                            // Add water button
                            Button {
                                showingAddWaterSheet = true
                            } label: {
                                HStack {
                                    Image(systemName: "plus")
                                    Text("Add Water")
                                        .fontWeight(.semibold)
                                }
                                .foregroundColor(.white)
                                .frame(width: 200, height: 50)
                                .background(Color.waterBlue)
                                .cornerRadius(25)
                                .shadow(color: Color.waterBlue.opacity(0.4), radius: 5, x: 0, y: 3)
                            }
                            .padding(.bottom, 16)
                        }
                        .padding()
                    }
                    .frame(height: 450)
                    .padding(.horizontal)
                    
                    // Recent water log
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Today's Water Log")
                            .font(.headline)
                            .foregroundColor(Color.waterBlue)
                            .padding(.horizontal)
                        
                        ForEach(getSampleWaterLogs(), id: \.id) { log in
                            WaterLogItem(log: log)
                        }
                        
                        // View all logs button
                        Button {
                            // Navigate to detailed logs view
                        } label: {
                            Text("View All Logs")
                                .font(.subheadline)
                                .foregroundColor(Color.waterBlue)
                                .padding(.vertical, 8)
                                .frame(maxWidth: .infinity)
                                .background(Color.waterBlue.opacity(0.1))
                                .cornerRadius(8)
                        }
                        .padding(.horizontal)
                    }
                    .padding(.bottom, 24)
                }
            }
            .navigationTitle("Hydrate+")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        // Open settings
                    } label: {
                        Image(systemName: "gearshape.fill")
                            .foregroundColor(Color.waterBlue)
                    }
                }
            }
            .sheet(isPresented: $showingAddWaterSheet) {
                AddWaterView(waterConsumed: $waterConsumed)
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
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMMM d"
        return formatter.string(from: Date())
    }
    
    // Sample data for water logs
    func getSampleWaterLogs() -> [WaterLog] {
        return [
            WaterLog(id: 1, amount: 250, time: "8:30 AM", icon: "mug.fill"),
            WaterLog(id: 2, amount: 500, time: "10:45 AM", icon: "drop.fill"),
            WaterLog(id: 3, amount: 250, time: "1:15 PM", icon: "mug.fill")
        ]
    }
}

// Water bottle shape for visualization
struct WaterBottleShape: Shape {
    func path(in rect: CGRect) -> Path {
        let width = rect.width
        let height = rect.height
        
        var path = Path()
        path.move(to: CGPoint(x: width * 0.25, y: 0))
        path.addLine(to: CGPoint(x: width * 0.75, y: 0))
        path.addLine(to: CGPoint(x: width * 0.9, y: height * 0.1))
        path.addLine(to: CGPoint(x: width * 0.9, y: height))
        path.addLine(to: CGPoint(x: width * 0.1, y: height))
        path.addLine(to: CGPoint(x: width * 0.1, y: height * 0.1))
        path.closeSubpath()
        
        return path
    }
}

// Water fill shape for visualization
struct WaterFillShape: Shape {
    var fillLevel: CGFloat // 0.0 to 1.0
    
    var animatableData: CGFloat {
        get { fillLevel }
        set { fillLevel = newValue }
    }
    
    func path(in rect: CGRect) -> Path {
        let width = rect.width
        let height = rect.height
        let adjustedFillLevel = max(0, min(fillLevel, 1))
        let waterHeight = height * adjustedFillLevel
        let startY = height - waterHeight
        
        var path = Path()
        path.move(to: CGPoint(x: width * 0.1, y: height))
        path.addLine(to: CGPoint(x: width * 0.9, y: height))
        path.addLine(to: CGPoint(x: width * 0.9, y: startY))
        path.addLine(to: CGPoint(x: width * 0.1, y: startY))
        path.closeSubpath()
        
        return path
    }
}

// Water log model
struct WaterLog: Identifiable {
    let id: Int
    let amount: Int
    let time: String
    let icon: String
}

// Water log item view
struct WaterLogItem: View {
    let log: WaterLog
    
    var body: some View {
        HStack {
            Image(systemName: log.icon)
                .foregroundColor(.white)
                .frame(width: 36, height: 36)
                .background(Color.waterBlue)
                .cornerRadius(18)
            
            VStack(alignment: .leading) {
                Text("\(log.amount) ml")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                
                Text(log.time)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Button {
                // Edit log functionality
            } label: {
                Image(systemName: "pencil")
                    .foregroundColor(Color.waterBlue)
            }
        }
        .padding(.vertical, 8)
        .padding(.horizontal)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
        .padding(.horizontal)
    }
}

#Preview {
    HomeView()
}
