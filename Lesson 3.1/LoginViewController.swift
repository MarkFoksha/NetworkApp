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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLoginButton()
        
    }
    
    private func setupLoginButton() {
        view.addSubview(fbLoginButton)
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
    
    
}
