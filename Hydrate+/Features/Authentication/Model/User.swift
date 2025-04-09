//
//  User.swift
//  Hydrate+
//
//  Created by Ian   on 09/04/2025.
//

import Foundation
import Foundation
struct User: Identifiable, Codable {
    let id: String
    let fullname: String
    let email: String
    
    var initials: String {
        let formatter = PersonNameComponentsFormatter()
        if let components = formatter.personNameComponents(from: fullname) {
            formatter.style = .abbreviated
            return formatter.string(from: components)
        }
        
        return ""
    }
}

extension User {
    static var MOCK_USER = User(id: "1", fullname: "Tyreek Hill", email: "tyreekcheetah@gmail.com")
}
