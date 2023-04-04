//
//  SignInVC.swift
//  Lesson 3.1
//
//  Created by Марк Фокша on 03.04.2023.
//

import UIKit

class SignInVC: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTestField: UITextField!
    
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

        view.addVerticalGradientColor(topColor: primaryColor, bottomColor: secondaryColor)
        setContinueButton(isEnabled: false)
        
        emailTextField.addTarget(self, action: #selector(textfieldChanged), for: .editingChanged)
        passwordTestField.addTarget(self, action: #selector(textfieldChanged), for: .editingChanged)
        
        emailTextField.delegate = self
        passwordTestField.delegate = self
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
        
        guard let email = emailTextField.text,
              let password = passwordTestField.text else { return }
        
        let enableButton = !email.isEmpty && !password.isEmpty
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

extension SignInVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        emailTextField.resignFirstResponder()
        passwordTestField.resignFirstResponder()
        
        return true
    }
}
