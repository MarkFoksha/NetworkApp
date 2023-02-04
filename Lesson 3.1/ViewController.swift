//
//  ViewController.swift
//  Lesson 3.1
//
//  Created by Марк Фокша on 04.02.2023.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var downloadImage: UIButton!
    @IBOutlet weak var getRequest: UIButton!
    @IBOutlet weak var postRequest: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cornerRadius()
    }
    
    @IBAction func getRequest(_ sender: Any) {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts") else { return }
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
    
    @IBAction func postRequest(_ sender: Any) {
    }
    
    
    func cornerRadius() {
        let cornerRadius: CGFloat = 20
        downloadImage.layer.cornerRadius = cornerRadius
        getRequest.layer.cornerRadius = cornerRadius
        postRequest.layer.cornerRadius = cornerRadius
    }

}

