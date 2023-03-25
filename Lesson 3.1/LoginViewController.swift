//
//  LoginViewController.swift
//  Lesson 3.1
//
//  Created by Марк Фокша on 23.03.2023.
//

import UIKit
import FBSDKLoginKit

class LoginViewController: UIViewController {
    
    private lazy var fbLoginButton: UIButton = {
        
        let loginButton = FBLoginButton()
        loginButton.frame = CGRect(x: 32, y: 320, width: view.frame.width - 64, height: 50)
        loginButton.delegate = self
        return loginButton
    }()
    
    private lazy var customFbLoginButton: UIButton = {
        
        let customButton = FBLoginButton()
        customButton.frame = CGRect(x: 32, y: 320 + 60, width: view.frame.width - 64, height: 50)
        customButton.layer.cornerRadius = 4
        customButton.backgroundColor = UIColor(hexValue: "#3B59999", alpha: 1)
        customButton.setTitle("Login with Facebook", for: .normal)
        customButton.setTitleColor(.white, for: .normal)
        customButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 21)
        customButton.addTarget(self, action: #selector(handleButton), for: .touchUpInside)
        
        return customButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addVerticalGradientColor(topColor: primaryColor, bottomColor: secondaryColor)
        setupLoginButton()
    }
    
    private func setupLoginButton() {
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
            self.openMainVC()
        }
    }
    
    
}
