//
//  MainViewController.swift
//  Lesson 3.1
//
//  Created by Марк Фокша on 07.02.2023.
//

import UIKit
import UserNotifications
import FBSDKLoginKit
import FirebaseAuth

private let reuseIdentifier = "Cell"
private let getPostUrlString = "https://jsonplaceholder.typicode.com/posts"
private let coursesUrlString = "https://swiftbook.ru/wp-content/uploads/api/api_courses"
private let uploadImageUrl = "https://api.imgur.com/3/image"

enum Actions: String, CaseIterable {
    case downloadImage = "Download image"
    case get = "GET"
    case post = "POST"
    case ourCourses = "Our Courses"
    case uploadImage = "Upload image"
    case downloadFile = "Download file"
    case ourCoursesAlamofire = "Our course (Alamofire)"
    case responseData = "Response Data"
    case responseString = "Response String"
    case simpleResponse = "Response"
    case largeImage = "Large image"
    case postAlamofire = "POST Alamofire"
    case putRequest = "PUT Request with Alamofire"
    case uploadImageAlamofire = "Upload image Alamofire"
}

class MainViewController: UICollectionViewController {
    
    let actions = Actions.allCases
    private var alert: UIAlertController!
    private let dataProvider = DataProvider()
    private var fileLocation: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerForNotification()
        
        dataProvider.fileLocation = { location in
            print("Download finished \(location.absoluteString)")
            self.fileLocation = location.absoluteString
            self.postNotification()
            self.alert.dismiss(animated: false)
        }
        
        checkUpLogin()
    }
    
    func showAlert() {
        alert = UIAlertController(title: "Downloading...", message: "0%", preferredStyle: .alert)
        let height = alert.view.heightAnchor.constraint(equalToConstant: 170)
        alert.view.addConstraint(height)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive) {_ in
            self.dataProvider.stopDownload()
        }
        alert.addAction(cancelAction)
        
        present(alert, animated: true) {
            let size = CGSize(width: 40, height: 40)
            let point = CGPoint(x: self.alert.view.frame.width / 2 - size.width / 2, y: self.alert.view.frame.height / 2 - size.height / 2)
            
            let activityIndicator = UIActivityIndicatorView(frame: CGRect(origin: point, size: size))
            activityIndicator.startAnimating()
            
            let progressView = UIProgressView(frame: CGRect(x: 0, y: self.alert.view.frame.height - 44, width: self.alert.view.frame.width, height: 0))
            
            self.dataProvider.onProgress = { progress in
                progressView.progress = Float(progress)
                self.alert.message = String(Int(progress*100)) + "%"
            }
            
            self.alert.view.addSubview(activityIndicator)
            self.alert.view.addSubview(progressView)
        }
    }
    

// MARK: - UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return actions.count
        
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CollectionViewCell
        
        cell.label.text = actions[indexPath.row].rawValue
        
    
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let action = actions[indexPath.row]
        
        switch action {
        case .downloadImage:
            performSegue(withIdentifier: "showImage", sender: self)
        case .get:
            NetworkManager.getRequest(withURL: getPostUrlString)
        case .post:
            NetworkManager.postRequest(withURL: getPostUrlString)
        case .ourCourses:
            performSegue(withIdentifier: "ourCourses", sender: self)
        case .uploadImage:
            NetworkManager.uploadImage(withURL: uploadImageUrl)
        case .downloadFile:
            showAlert()
            dataProvider.startDownload()
        case .ourCoursesAlamofire:
            performSegue(withIdentifier: "ourCoursesWithAlamofire", sender: self)
        case .responseData:
            performSegue(withIdentifier: "responseData", sender: self)
            AlamofireNetworkRequest.responseData(url: coursesUrlString)
        case .responseString:
            AlamofireNetworkRequest.responseString(url: coursesUrlString)
        case .simpleResponse:
            AlamofireNetworkRequest.response(url: coursesUrlString)
        case .largeImage:
            performSegue(withIdentifier: "largeImage", sender: self)
        case .postAlamofire:
            performSegue(withIdentifier: "postRequest", sender: self )
        case .putRequest:
            performSegue(withIdentifier: "putRequest", sender: self)
        case .uploadImageAlamofire:
            AlamofireNetworkRequest.uploadImage(withURL: uploadImageUrl)
        }
    }
    
    //MARK: Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let coursesVC = segue.destination as? CoursesViewController
        let imageVC = segue.destination as? ImageViewController
        
        switch segue.identifier {
        case "ourCourses":
            coursesVC?.fetchData()
        case "ourCoursesWithAlamofire":
            coursesVC?.fetchDataWithAlamofire()
        case "showImage":
            imageVC?.fetchImage()
        case "responseData":
            imageVC?.fetchImageWithAlamofire()
        case "largeImage":
            imageVC?.downloadImageWithProgress()
        case "postRequest":
            coursesVC?.postRequest()
        case "putRequest":
            coursesVC?.putRequest()
        default:
            break
        }
    }
}


extension MainViewController {
    private func registerForNotification() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { _, _ in
            
            
        }
    }
    
    private func postNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Download complete!"
        content.body = "Your download has finished. File path: \(fileLocation ?? "error")"
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3, repeats: false)
        
        let request = UNNotificationRequest(identifier: "TransferComplete", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
}

// MARK: - Facebook SDK

extension MainViewController {
    private func checkUpLogin() {
        
        if Auth.auth().currentUser == nil {
            
            DispatchQueue.main.async {
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                loginVC.modalPresentationStyle = .fullScreen
                self.present(loginVC, animated: true)
            }
        }
    }
    
}