//
//  UserProfileVC.swift
//  Lesson 3.1
//
//  Created by Марк Фокша on 25.03.2023.
//

import UIKit
import FBSDKLoginKit
import FirebaseAuth
import FirebaseDatabase

class UserProfileVC: UIViewController {

    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private lazy var fbLoginButton: UIButton = {
        let loginButton = FBLoginButton()
        loginButton.frame = CGRect(x: 32,
                                   y: view.frame.height - 128,
                                   width: view.frame.width - 64,
                                   height: 50)
        loginButton.delegate = self
        return loginButton
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.userNameLabel.isHidden = true
        view.addVerticalGradientColor(topColor: primaryColor, bottomColor: secondaryColor)
        setUpButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchUserData()
    }
      
    func setUpButton() {
        view.addSubview(fbLoginButton)
    }
}

//MARK: - Facebook SDK

extension UserProfileVC: LoginButtonDelegate {
    
    func loginButton(_ loginButton: FBSDKLoginKit.FBLoginButton, didCompleteWith result: FBSDKLoginKit.LoginManagerLoginResult?, error: Error?) {
        if error != nil {
            print(error!)
            
            return
        }

        print("Succesfully logged in with Facebook")
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginKit.FBLoginButton) {
        
        openLoginVC()
        print("Did log out from Facebook")
    }
    
    private func openLoginVC() {
        
        do {
            try Auth.auth().signOut()
            
            DispatchQueue.main.async {
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                self.present(loginVC, animated: true)
            }
        } catch let error {
            print("Failed to log out. Error: ", String(describing: error))
        }
    }
    
    private func fetchUserData() {
        
        if Auth.auth().currentUser != nil {
            guard let uid = Auth.auth().currentUser?.uid else { return }
            
            Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value) { snapshot in
                guard let userData = snapshot.value as? [String: Any] else { return }
                let currentUser = CurrentUser(uid: uid, data: userData)
                
                self.activityIndicator.stopAnimating()
                self.userNameLabel.isHidden = false
                self.userNameLabel.text = "\(currentUser?.name ?? "Noname") is logged in with Facebook"
            }
        }
        
    }
    
}
