//
//  ImageProperties.swift
//  Lesson 3.1
//
//  Created by Марк Фокша on 08.02.2023.
//

import Foundation
import UIKit

struct ImageProperties {
    let key: String
    let data: Data
    
    init?(withImage image: UIImage, forKey key: String) {
        self.key = key
        guard let data = image.pngData() else { return nil}
        self.data = data
    }
}
