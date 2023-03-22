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
    
    static func postRequest(withURL url: String, completion: @escaping ([Course]) -> ()) {
        guard let url = URL(string: url) else { return }
        
        let userData: [String: Any] = ["name": "Network request",
                                       "link": "https://swiftbook.ru/contents/our-first-applications/",
                                       "imageUrl": "https://swiftbook.ru/wp-content/uploads/sites/2/2018/08/notifications-course-with-background.png",
                                       "numberOfLessons": 18,
                                       "numberOfTests": 10]
        AF.request(url, method: .post, parameters: userData).responseJSON { responseJSON in
            guard let statusCode = responseJSON.response?.statusCode else { return }
            print("Status code ", statusCode)
            
            switch responseJSON.result {
            case .success(let value):
                print(value)
                
                guard let jsonObject = value as? [String: Any],
                      let course = Course(json: jsonObject) else { return }
                var courses = [Course]()
                courses.append(course)
                completion(courses)
                
            case .failure(let error):
                print(String(describing: error))
            }
        }
    }
    
    static func putRequest(withURL url: String, completion: @escaping ([Course]) -> ()) {
        guard let url = URL(string: url) else { return }
        
        let userData: [String: Any] = ["name": "Network request with Alamofire",
                                       "link": "https://swiftbook.ru/contents/our-first-applications/",
                                       "imageUrl": "https://swiftbook.ru/wp-content/uploads/sites/2/2018/08/notifications-course-with-background.png",
                                       "numberOfLessons": "18",
                                       "numberOfTests": "10"]
        AF.request(url, method: .put, parameters: userData).responseJSON { responseJSON in
            guard let statusCode = responseJSON.response?.statusCode else { return }
            print("Status code ", statusCode)
            
            switch responseJSON.result {
            case .success(let value):
                print(value)
                
                guard let jsonObject = value as? [String: Any],
                      let course = Course(json: jsonObject) else { return }
                var courses = [Course]()
                courses.append(course)
                completion(courses)
                
            case .failure(let error):
                print(String(describing: error))
            }
        }
    }
    
    static func uploadImage(withURL url: String) {
        guard let url = URL(string: url) else { return }
        
        let image = UIImage(named: "networkingIcon")!
        let data = image.pngData()!
        
        let httpHeaders: HTTPHeaders = ["Authorization": "Client-ID 84f03bf655cb681"]
        
        AF.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(data, withName: "image")
        }, to: url, headers: httpHeaders).responseJSON { responseJSON in
            switch responseJSON.result {
            case .success(let value):
                print(value)
            case .failure(let error):
                print(String(describing: error))
            }
        }
    }
}
