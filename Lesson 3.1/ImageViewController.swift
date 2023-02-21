//
//  ImageViewController.swift
//  Lesson 3.1
//
//  Created by Марк Фокша on 04.02.2023.
//

import UIKit
import Alamofire

class ImageViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var completedLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    
    
    private let imageUrlString = "https://applelives.com/wp-content/uploads/2016/03/iPhone-SE-11.jpeg"
    private let largeImageUrl = "https://i.imgur.com/3416rvI.jpg"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.startAnimating()
        activityIndicator.hidesWhenStopped = true
        completedLabel.isHidden = true
        progressView.isHidden = true
    }
    
    func fetchImage() {
        
        NetworkManager.downloadImage(url: imageUrlString) { image in
            self.imageView.image = image
            self.activityIndicator.stopAnimating()
        }
    }
    
    func fetchImageWithAlamofire() {
        
        AlamofireNetworkRequest.downloadImage(withURL: imageUrlString) { image in
            self.activityIndicator.stopAnimating()
            self.imageView.image = image
        }
        
    }
    
    func downloadImageWithProgress() {
        
        AlamofireNetworkRequest.onProgress = { progress in
            self.progressView.isHidden = false
            self.progressView.progress = Float(progress)
        }
        
        AlamofireNetworkRequest.completed = { completed in
            self.completedLabel.isHidden = false
            self.completedLabel.text = completed
        }
        
        AlamofireNetworkRequest.downloadLargeImageAlamofire(withURL: largeImageUrl) { image in
            self.activityIndicator.stopAnimating()
            self.progressView.isHidden = true
            self.completedLabel.isHidden = true
            self.imageView.image = image
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
