//
//  NetworkManager.swift
//  Lesson 3.1
//
//  Created by Марк Фокша on 07.02.2023.
//

import Foundation
import UIKit

class NetworkManager {
    
    static func getRequest(withURL url: String) {
        guard let url = URL(string: url) else { return }
        let session = URLSession.shared
        session.dataTask(with: url) { data, response, error in
            guard let response = response, let data = data else { return }
            print(response)
            print(data)
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                print(json)
            } catch {
                print(String(describing: error))
            }
        }.resume()
    }
    
    static func postRequest(withURL url: String) {
        guard let url = URL(string: url) else { return }
        let usersData = ["Course": "Networking", "Lesson": "GET and POST requests"]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        
        guard let httpBody = try? JSONSerialization.data(withJSONObject: usersData, options: []) else { return }
        request.httpBody = httpBody
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let session = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let response = response, let data = data else { return }
            print(response)
            
            do {
                let json = try JSONSerialization.jsonObject(with: data)
                print(json)
            } catch {
                print(String(describing: error))
            }
        }
        session.resume()
    }
    
    static func downloadImage(url: String, completion: @escaping (_ image: UIImage)-> ()) {
        guard let url = URL(string: url) else { return }
        
        let session = URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                guard let image = UIImage(data: data) else { return }
                DispatchQueue.main.async {
                    completion(image)
                }
            }
        }
        session.resume()
    }
    
    static func fetchData(withURL url: String, completion: @escaping (_ courses: [Course]) -> ()) {
        guard let url = URL(string: url) else { return }
        
        let session = URLSession.shared
        
        session.dataTask(with: url) { data, _, _ in
            guard let data = data else { return }
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            do {
                let courses = try decoder.decode([Course].self, from: data)
                completion(courses)
            } catch let error {
                print(String(describing: error))
            }
        }.resume()
    }
    
    static func uploadImage(withURL url: String) {
        let image = UIImage(named: "networkingIcon")!
        let httpHeaders = ["Authorization": "Client-ID 84f03bf655cb681"]
        
        guard let imageProperty = ImageProperties(withImage: image, forKey: "image") else { return }
        guard let url = URL(string: url) else { return }
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = httpHeaders
        request.httpBody = imageProperty.data
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let response = response {
                print(response)
            }
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    print(json)
                } catch let error {
                    print(String(describing: error))
                }
            }
        }.resume()
        
    }
}
