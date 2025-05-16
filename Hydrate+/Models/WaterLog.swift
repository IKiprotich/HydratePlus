//
//  WaterLog.swift
//  Hydrate+
//
//  Created by Ian   on 11/04/2025.
//

/*
 * WaterLog.swift
 * 
 * This model represents a single water intake entry in the Hydrate+ app.
 * It stores the amount of water consumed (in milliliters) and the timestamp
 * of when the water was logged. The model conforms to Identifiable and Codable
 * protocols to support unique identification and data persistence.
 * 
 * Key features:
 * - Tracks water intake amount and time
 * - Provides formatted time display
 * - Integrates with Firebase Firestore for cloud storage
 */

import Foundation
import FirebaseFirestore

struct WaterLog: Identifiable, Codable {
    @DocumentID var id: String?
    let amount: Double
    let time: Date
    
    init(amount: Double, time: Date) {
        self.amount = amount
        self.time = time
    }
    
    var timeFormatted: String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: time)
    }
}

