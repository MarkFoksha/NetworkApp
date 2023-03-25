//
//  UserProfileVC.swift
//  Lesson 3.1
//
//  Created by Марк Фокша on 25.03.2023.
//

import UIKit
import FBSDKLoginKit

class UserProfileVC: UIViewController {

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
        
        view.addVerticalGradientColor(topColor: primaryColor, bottomColor: secondaryColor)
        setUpButton()
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
        
        if !AccessToken.isCurrentAccessTokenActive {
            
            DispatchQueue.main.async {
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                self.present(loginVC, animated: true)
            }
        }
    }
    
}
