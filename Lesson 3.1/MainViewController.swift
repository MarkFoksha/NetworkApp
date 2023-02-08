//
//  MainViewController.swift
//  Lesson 3.1
//
//  Created by Марк Фокша on 07.02.2023.
//

import UIKit

private let reuseIdentifier = "Cell"
private let getPostUrlString = "https://jsonplaceholder.typicode.com/posts"
private let uploadImageUrl = "https://api.imgur.com/3/image"

enum Actions: String, CaseIterable {
    case downloadImage = "Download image"
    case get = "GET"
    case post = "POST"
    case ourCourses = "Our Courses"
    case uploadImage = "Upload image"
    case downloadFile = "Download file"
}

class MainViewController: UICollectionViewController {
    
    let actions = Actions.allCases
    

// MARK: UICollectionViewDataSource

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
            print(action.rawValue )
        }
    }
}
