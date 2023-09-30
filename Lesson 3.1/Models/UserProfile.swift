//
//  UserProfile.swift
//  Lesson 3.1
//
//  Created by Марк Фокша on 28.03.2023.
//

import Foundation

struct UserProfile {
    let id: Int?
    let name: String?
    let email: String?
    
    init(data: [String: Any]) {
        let id = data["id"] as? Int
        let name = data["name"] as? String
        let email = data["email"] as? String
        
        self.id = id
        self.name = name
        self.email = email
    }
}
