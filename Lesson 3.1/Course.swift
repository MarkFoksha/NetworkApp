//
//  Course.swift
//  Lesson 3.1
//
//  Created by Марк Фокша on 06.02.2023.
//

import Foundation

struct Course: Codable {
    let id: Int
    let name: String
    let link: String
    let imageUrl: String
    let numberOfLessons: Int
    let numberOfTests: Int
}


struct WebsiteDescription: Codable {
    let websiteDescription: String
    let websiteName: String
    let courses: [Course]
}
