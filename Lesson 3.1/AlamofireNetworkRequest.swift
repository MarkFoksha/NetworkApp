//
//  AlamofireNetworkRequest.swift
//  Lesson 3.1
//
//  Created by Марк Фокша on 10.02.2023.
//

import Foundation
import Alamofire

class AlamofireNetworkRequest: Codable {
    
    static var onProgress: ((Double) -> ())?
    static var completed: ((String) -> ())?
    
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
    
    static func downloadImage(withURL url: String, completion: @escaping (UIImage) -> ()) {
        AF.request(url).responseData { responseData in
            switch responseData.result {
            case .success(let data):
                guard let image = UIImage(data: data) else { return }
                
                DispatchQueue.main.async {
                    completion(image)
                }
            case .failure(let error):
                print(String(describing: error))
            }
        }
    }
    
    //MARK: - Types of response
    
    //MARK: With data method
    
    static func responseData(url: String) {
        AF.request(url).responseData { responseData in
            switch responseData.result {
            case .success(let data):
                guard let string = String(data: data, encoding: .utf8) else { return }
                print(string)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    //MARK: with string method
    static func responseString(url: String) {
        AF.request(url).responseString { responseString in
            switch responseString.result {
            case .success(let string):
                print(string)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    //MARK: with simple response method
    static func response(url: String) {
        AF.request(url).response { response in
            guard
                let data = response.data,
                let string = String(data: data, encoding: .utf8)
            else { return }
            print(string)
        }
    }
    
    // MARK: - Download big image file
    
    static func downloadLargeImageAlamofire(withURL url: String, completion: @escaping (_ image: UIImage) -> ()) {
        guard let url = URL(string: url) else { return print("Problem") }
        
        AF.request(url).validate().downloadProgress { progress in
            print("Total unit count:\n", progress.totalUnitCount)
            print("Completed unit count:\n",progress.completedUnitCount)
            print("Fraction completed:\n", progress.fractionCompleted)
            print("Description:\n", progress.localizedDescription!)
            print("----------------------------------------------------------------------")
            
            self.onProgress?(progress.fractionCompleted)
            self.completed?(progress.localizedDescription)
            
        }.response { response in
            guard let data = response.data, let image = UIImage(data: data) else { return }
            
            DispatchQueue.main.async {
                completion(image)
            }
        }
    }
}
