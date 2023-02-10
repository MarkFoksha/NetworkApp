//
//  AlamofireNetworkRequest.swift
//  Lesson 3.1
//
//  Created by Марк Фокша on 10.02.2023.
//

import Foundation
import Alamofire

class AlamofireNetworkRequest {
    static func sendRequest(withURL url: String) {
        guard let url = URL(string: url) else { return}
        
        AF.request(url).responseJSON { response in
            print(response)
        }
        
    }
}
