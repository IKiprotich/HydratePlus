//
//  WaterLog.swift
//  Hydrate+
//
//  Created by Ian   on 11/04/2025.
//

import Foundation
import FirebaseFirestore

struct WaterLog: Identifiable, Codable {
    @DocumentID var id: String?  // Firestore will handle the document ID automatically
    let amount: Double
    let time: Date
    
    var timeFormatted: String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: time)
    }
}

