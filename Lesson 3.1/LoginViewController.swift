//
//  LoginViewController.swift
//  Lesson 3.1
//
//  Created by Марк Фокша on 23.03.2023.
//

import UIKit
import FBSDKLoginKit
import FirebaseAuth

class LoginViewController: UIViewController {
    
    private lazy var fbLoginButton: UIButton = {
        
        let loginButton = FBLoginButton()
        loginButton.frame = CGRect(x: 32, y: 320, width: view.frame.width - 64, height: 50)
        loginButton.delegate = self
        return loginButton
    }()
    
    private lazy var customFbLoginButton: UIButton = {
        
        let customButton = UIButton()
        customButton.frame = CGRect(x: 32, y: 320 + 60, width: view.frame.width - 64, height: 50)
        customButton.layer.cornerRadius = 4
        customButton.backgroundColor = UIColor(hexValue: "#3B5999", alpha: 1)
        customButton.setTitle("Login with Facebook", for: .normal)
        customButton.setTitleColor(.white, for: .normal)
        customButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        customButton.addTarget(self, action: #selector(handleButton), for: .touchUpInside)
        
        return customButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addVerticalGradientColor(topColor: primaryColor, bottomColor: secondaryColor)
        setupLoginButtons()
    }
    
    private func setupLoginButtons() {
        view.addSubview(fbLoginButton)
        view.addSubview(customFbLoginButton)
    }

}

//MARK: - Facebook LoginButtonDelegate

extension LoginViewController: LoginButtonDelegate {
    
    func loginButton(_ loginButton: FBSDKLoginKit.FBLoginButton, didCompleteWith result: FBSDKLoginKit.LoginManagerLoginResult?, error: Error?) {
        
        if error != nil {
            print(error!)
            
            return
        }
        
        guard let token = AccessToken.current,
              !token.isExpired else { return }
        fetchFBData()
        openMainVC()
        print("Succesfully logged in with Facebook")
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginKit.FBLoginButton) {
        
        print("Did log out from Facebook")
    }
    
    private func openMainVC() {
        
        dismiss(animated: true)
    }
    
    @objc private func handleButton() {
        
        LoginManager().logIn(permissions: ["public_profile", "email"], from: self) { result, error in
            if let error = error {
                print(String(describing: error))
            }
            
            guard let result = result else { return }
            guard !result.isCancelled else { return }
            self.fetchFBData()
            self.openMainVC()
            self.signIntoFirebase()
        }
    }
    
    private func signIntoFirebase() {
        let token = AccessToken.current
        guard let tokenString = token?.tokenString else { return }
        
        let credentials = FacebookAuthProvider.credential(withAccessToken: tokenString)
        Auth.auth().signIn(with: credentials) { user, error in
            if let error = error {
                print("Something went wrong:( ", error)
                return
            }
            
            print("User successfully loged in with Firebase: ", user!)
        }
    }
    
    private func fetchFBData() {
        GraphRequest(graphPath: "me", parameters: ["fields": "id, name, email"]).start { _, result, error in
            
            if let error = error {
                print(error)
                return
            }
            
            guard let userData = result as? [String: Any] else { return }
            print(userData)
        }
    }
    
    
}
