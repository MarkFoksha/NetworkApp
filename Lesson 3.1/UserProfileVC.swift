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
import GoogleSignIn

class UserProfileVC: UIViewController {

    //Outlets
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    //Properties
    private var provider: String?
    private var currentUser: CurrentUser?
    
    // Log out button
    private lazy var logOutButton: UIButton = {
        let button = UIButton()
        button.frame = CGRect(x: 32,
                                   y: view.frame.height - 128,
                                   width: view.frame.width - 64,
                                   height: 50)
        button.backgroundColor = UIColor(hexValue: "#3B5999", alpha: 1)
        button.setTitle("Log out", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 4
        button.addTarget(self, action: #selector(signOut), for: .touchUpInside)
        
        return button
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
      
    //Set up log out button
    func setUpButton() {
        view.addSubview(logOutButton)
    }
}

extension UserProfileVC {
    
    //Method that opens LoginVC after log out
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
    
    //Method that fetches user's data and inserts needed data in label
    private func fetchUserData() {
        
        if Auth.auth().currentUser != nil {
            guard let uid = Auth.auth().currentUser?.uid else { return }
            
            Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value) { snapshot in
                guard let userData = snapshot.value as? [String: Any] else { return }
                self.currentUser = CurrentUser(uid: uid, data: userData)
                
                self.activityIndicator.stopAnimating()
                self.userNameLabel.isHidden = false
                self.userNameLabel.text = self.getProviderData()
            }
        }
        
    }
    
    //Method that handles sign out
    @objc private func signOut() {
        
        if let providerData = Auth.auth().currentUser?.providerData {
            
            for userInfo in providerData {
                
                switch userInfo.providerID {
                
                case "facebook.com":
                    LoginManager().logOut()
                    print("User did log out from FB")
                    openLoginVC()
                case "google.com":
                    GIDSignIn.sharedInstance.signOut()
                    print("User did log out from Google")
                    openLoginVC()
                default:
                    print("User is signed in with: ", userInfo.providerID)
                }
            }
        }
    }
    
    //Method that makes needed greeting based on what provider user is signed in with
    private func getProviderData() -> String {
        var greetings = ""
        
        if let providerData = Auth.auth().currentUser?.providerData {
            for userInfo in providerData {
                switch userInfo.providerID {
                case "facebook.com":
                    provider = "Facebook"
                case "google.com":
                    provider = "Google"
                default:
                    break
                }
            }
            greetings = "\(currentUser?.name ?? "Noname") is logged with \(provider!)"
        }
        return greetings
    }
}
