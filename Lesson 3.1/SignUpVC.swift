//
//  SignUpVC.swift
//  Lesson 3.1
//
//  Created by Марк Фокша on 03.04.2023.
//

import UIKit

class SignUpVC: UIViewController {

    @IBOutlet weak var usernameTestField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTesxField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    
    private lazy var continueButton: UIButton = {
       
        let button = UIButton()
        button.frame = CGRect(x: 0, y: 0, width: 200, height: 50)
        button.center = CGPoint(x: view.center.x, y: view.frame.height - 100)
        button.backgroundColor = .white
        button.setTitle("Continue", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.setTitleColor(secondaryColor, for: .normal)
        button.layer.cornerRadius = 4
        button.addTarget(self, action: #selector(handleSignIn), for: .touchUpInside)
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        usernameTestField.addTarget(self, action: #selector(textfieldChanged), for: .editingChanged)
        emailTextField.addTarget(self, action: #selector(textfieldChanged), for: .editingChanged)
        passwordTesxField.addTarget(self, action: #selector(textfieldChanged), for: .editingChanged)
        confirmPasswordTextField.addTarget(self, action: #selector(textfieldChanged), for: .editingChanged)
        
        usernameTestField.delegate = self
        emailTextField.delegate = self
        passwordTesxField.delegate = self
        confirmPasswordTextField.delegate = self
        
        view.addVerticalGradientColor(topColor: primaryColor, bottomColor: secondaryColor)
        setContinueButton(isEnabled: false)
        setupButtons()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: nil) { notification in
            
            let userInfo = notification.userInfo
            let keyboardFrame = (userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
            
            self.continueButton.center = CGPoint(x: self.view.center.x, y: self.view.frame.height - keyboardFrame.height - 16 - self.continueButton.frame.height / 2)
        }
        
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: nil) { _ in
            self.continueButton.center = CGPoint(x: self.view.center.x, y: self.view.frame.height - 100)
        }
        
    }
    
    @IBAction func goBack(_ sender: Any) {
        dismiss(animated: true)
    }
    
    
    private func setContinueButton(isEnabled: Bool) {
        
        if isEnabled {
            continueButton.alpha = 1
            continueButton.isEnabled = true
        } else {
            continueButton.alpha = 0.5
            continueButton.isEnabled = false
        }
    }
    
    private func setupButtons() {
        view.addSubview(continueButton)
    }
    
    @objc private func textfieldChanged() {
        
        guard let name = usernameTestField.text,
              let email = emailTextField.text,
              let password = passwordTesxField.text,
              let confirmPassword = confirmPasswordTextField.text
        else { return }
        
        let enableButton = !name.isEmpty && !email.isEmpty && !password.isEmpty && confirmPassword == password
        setContinueButton(isEnabled: enableButton)
    }
    
    @objc private func handleSignIn() {
        
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

extension SignUpVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        usernameTestField.resignFirstResponder()
        emailTextField.resignFirstResponder()
        passwordTesxField.resignFirstResponder()
        confirmPasswordTextField.resignFirstResponder()
        
        return true
    }
}
