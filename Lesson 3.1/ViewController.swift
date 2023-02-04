//
//  ViewController.swift
//  Lesson 3.1
//
//  Created by Марк Фокша on 04.02.2023.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var tapLabel: UILabel!
    @IBOutlet weak var getImageViewButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.isHidden = true
        activityIndicator.hidesWhenStopped = true
        
    }
    
    @IBAction func imageViewButtonPressed(_ sender: UIButton) {
        tapLabel.isHidden = true
        getImageViewButton.isEnabled = false
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        
        let urlString = "https://applelives.com/wp-content/uploads/2016/03/iPhone-SE-11.jpeg"
        guard let url = URL(string: urlString) else { return }
        
        let session = URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                let image = UIImage(data: data)
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    self.imageView.image = image
                }
            }
        }
        session.resume()
    }

}

