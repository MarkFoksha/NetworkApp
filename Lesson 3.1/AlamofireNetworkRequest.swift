//
//  AlamofireNetworkRequest.swift
//  Lesson 3.1
//
//  Created by Марк Фокша on 10.02.2023.
//

import Foundation
import Alamofire

class AlamofireNetworkRequest: Codable {
    static func sendRequest(withURL url: String, completion: @escaping ([Course]) -> ()) {
        guard let url = URL(string: url) else { return}
        
        AF.request(url).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                var courses = [Course]()
                courses = Course.getArray(from: value)!
                completion(courses)
            case .failure(let error): print(error)
            }
            
        }
    }
}
