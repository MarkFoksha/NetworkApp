//
//  LoginViewController.swift
//  Lesson 3.1
//
//  Created by Марк Фокша on 23.03.2023.
//

import UIKit
import FBSDKLoginKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import GoogleSignIn

class LoginViewController: UIViewController {
    
    // Properties
    var userProfile: UserProfile?
    var credentials: AuthCredential?
    
    // Default Facebook login button
    private lazy var fbLoginButton: UIButton = {
        
        let loginButton = FBLoginButton()
        loginButton.frame = CGRect(x: 32, y: 320, width: view.frame.width - 64, height: 50)
        loginButton.delegate = self
        return loginButton
    }()
    
    //Custom Facebook login button
    private lazy var customFbLoginButton: UIButton = {
        
        let customButton = UIButton()
        customButton.frame = CGRect(x: 32, y: 320 + 60, width: view.frame.width - 64, height: 50)
        customButton.layer.cornerRadius = 4
        customButton.backgroundColor = UIColor(hexValue: "#3B5999", alpha: 1)
        customButton.setTitle("Login with Facebook", for: .normal)
        customButton.setTitleColor(.white, for: .normal)
        customButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        customButton.addTarget(self, action: #selector(handleCustomFBButton), for: .touchUpInside)
        
        return customButton
    }()
    
    //Default Google login button
    private lazy var googleLoginButton: GIDSignInButton = {
       
        let loginButton = GIDSignInButton()
        loginButton.frame = CGRect(x: 32, y: 320 + 120, width: view.frame.width - 64, height: 50)
        loginButton.addTarget(self, action: #selector(signInWithGoogle), for: .touchUpInside)
        return loginButton
    }()
    
    //Custom Google login button
    private lazy var customGoogleLoginButton: UIButton = {
       
        let loginButton = UIButton()
        loginButton.frame = CGRect(x: 32, y: 320 + 180, width: view.frame.width - 64, height: 50)
        loginButton.backgroundColor = .white
        loginButton.setTitle("Login with Google", for: .normal)
        loginButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        loginButton.setTitleColor(.gray, for: .normal)
        loginButton.layer.cornerRadius = 4
        loginButton.addTarget(self, action: #selector(signInWithGoogle), for: .touchUpInside)
        
        return loginButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addVerticalGradientColor(topColor: primaryColor, bottomColor: secondaryColor)
        setupLoginButtons()
    }
    
    //Buttons setup
    private func setupLoginButtons() {
        
        view.addSubview(fbLoginButton)
        view.addSubview(customFbLoginButton)
        view.addSubview(googleLoginButton)
        view.addSubview(customGoogleLoginButton)
    }
}

//MARK: - Facebook LoginButtonDelegate

extension LoginViewController: LoginButtonDelegate {
    
    //Login handling for default Facebook button
    func loginButton(_ loginButton: FBSDKLoginKit.FBLoginButton, didCompleteWith result: FBSDKLoginKit.LoginManagerLoginResult?, error: Error?) {
        
        if error != nil {
            print(error!)
            
            return
        }
        
        guard let token = AccessToken.current,
              !token.isExpired else { return }
        
        print("Succesfully logged in with Facebook")
        self.signIntoFirebase()
    }
    
    //Logout handling for default Facebook button
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginKit.FBLoginButton) {
        
        print("Did log out from Facebook")
    }
    
    private func openMainVC() {
        
        dismiss(animated: true)
    }
    
    //Handle custom FB button
    @objc private func handleCustomFBButton() {
        
        LoginManager().logIn(permissions: ["public_profile", "email"], from: self) { result, error in
            if let error = error {
                print(String(describing: error))
            }
            
            guard let result = result else { return }
            guard !result.isCancelled else { return }
            
            self.signIntoFirebase()
        }
    }
    
    //Sign into Firebase method
    private func signIntoFirebase() {
        let token = AccessToken.current
        guard let tokenString = token?.tokenString else { return }
        
        let credentials = FacebookAuthProvider.credential(withAccessToken: tokenString)
        Auth.auth().signIn(with: credentials) { user, error in
            if let error = error {
                print("Something went wrong:( ", error)
                return
            }
            
            self.fetchFBData()
            print("User successfully logged in with Firebase: ")
        }
    }
    
    //Fetching FB user's data method
    private func fetchFBData() {
        GraphRequest(graphPath: "me", parameters: ["fields": "id, name, email"]).start { _, result, error in
            
            if let error = error {
                print(error)
                return
            }
            
            guard let userData = result as? [String: Any] else { return }
            
            self.userProfile = UserProfile(data: userData)
            print(userData)
            print(self.userProfile?.name ?? "nil")
            self.saveIntoFirebase()
        }
    }
    
    //Saving user's data into Firebase method
    private func saveIntoFirebase() {
        let uid = Auth.auth().currentUser?.uid
        
        let userData = ["name": userProfile?.name, "email": userProfile?.email]
        let values = [uid: userData]
        
        Database.database().reference().child("users").updateChildValues(values) { error, _ in
            if let error = error {
                print(error)
                return
            }
            
            print("Successfully saved user into Firebase database")
            self.openMainVC()
        }
    } 
}

//MARK: - Google sign-in

extension LoginViewController {
    
    //Handle sign in with Google method
    @objc private func signInWithGoogle() {
        
        //Handling GID configuration
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        //Sign in completion
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { [unowned self] result, error in
            
            if let error = error {
                print("Failed to log in with Google: ", error)
                return
            }
            
            print("Successfully logged in with Google")
            
            guard let user = result?.user,
                  let idToken = user.idToken?.tokenString else { return }
            
            if let userName = user.profile?.name, let userEmail = user.profile?.email {
                let userData = ["name": userName, "email": userEmail]
                userProfile = UserProfile(data: userData)
                
                print(userProfile?.name ?? "Noname")
            }
            
            //Making credentials
            let credentials = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: user.accessToken.tokenString)
            self.credentials = credentials
            
            signIntoFirebaseWithGoogle()
        }
    }
    
    // Sign into Firebase for Google method
    private func signIntoFirebaseWithGoogle() {
        guard let credentials = credentials else { return }
        
        Auth.auth().signIn(with: credentials) { user, error in
            
            if let error = error {
                print("Failed to log in with Google: ", error)
                return
            }
            
            print("Successfully logged into Firebase with Google")
            self.saveIntoFirebase()
        }
    }
}

