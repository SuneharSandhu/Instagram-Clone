//
//  RegistrationViewController.swift
//  Instagram Clone
//
//  Created by Sunehar Sandhu on 4/10/21.
//

import UIKit

class RegistrationViewController: UIViewController {
    
    struct Constants {
        static let cornerRadius: CGFloat = 8.0
        static let textFieldBorderWidth: CGFloat = 1.0
        static let textFieldBorderColor: CGColor = UIColor.secondaryLabel.cgColor
    }
    
    private let usernameTextField: UITextField = {
        let field = UITextField()
        field.placeholder = "Username"
        field.returnKeyType = .next
        field.leftViewMode = .always  // gives the text a bit of a buffer so it's not flush with the frame
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.layer.masksToBounds = true
        field.layer.cornerRadius = Constants.cornerRadius
        field.backgroundColor = .secondarySystemBackground
//        field.layer.borderWidth = Constants.textFieldBorderWidth
//        field.layer.borderColor = Constants.textFieldBorderColor
        return field
    }()
    
    private let emailTextField: UITextField = {
        let field = UITextField()
        field.placeholder = "Email Address"
        field.returnKeyType = .next
        field.leftViewMode = .always  // gives the text a bit of a buffer so it's not flush with the frame
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.layer.masksToBounds = true
        field.layer.cornerRadius = Constants.cornerRadius
        field.backgroundColor = .secondarySystemBackground
//        field.layer.borderWidth = Constants.textFieldBorderWidth
//        field.layer.borderColor = Constants.textFieldBorderColor
        return field
    }()
    
    private let passwordField: UITextField = {
        let field = UITextField()
        field.placeholder = "Password"
        field.isSecureTextEntry = true
        field.returnKeyType = .continue
        field.leftViewMode = .always  // gives the text a bit of a buffer so it's not flush with the frame
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.layer.masksToBounds = true
        field.layer.cornerRadius = Constants.cornerRadius
        field.backgroundColor = .secondarySystemBackground
//        field.layer.borderWidth = Constants.textFieldBorderWidth
//        field.layer.borderColor = Constants.textFieldBorderColor
        return field
    }()
    
    private let registerButton: UIButton = {
        let button = UIButton()
        button.setTitle("Sign Up", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = Constants.cornerRadius
        button.backgroundColor = .systemGreen
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(usernameTextField)
        view.addSubview(emailTextField)
        view.addSubview(passwordField)
        view.addSubview(registerButton)
        
        registerButton.addTarget(self,
                                 action: #selector(didTapRegister),
                                 for: .touchUpInside)
        
        usernameTextField.delegate = self
        emailTextField.delegate = self
        passwordField.delegate = self
        
        view.backgroundColor = .systemBackground
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        usernameTextField.frame = CGRect(
            x: 20,
            y: view.safeAreaInsets.top + 100,
            width: view.width - 40,
            height: 52
        )
        
        emailTextField.frame = CGRect(
            x: 20,
            y: usernameTextField.bottom + 10,
            width: view.width - 40,
            height: 52
        )
        
        passwordField.frame = CGRect(
            x: 20,
            y: emailTextField.bottom + 10,
            width: view.width - 40,
            height: 52
        )
        
        registerButton.frame = CGRect(
            x: 20,
            y: passwordField.bottom + 10,
            width: view.width - 40,
            height: 52
        )
    }
    
    @objc private func didTapRegister() {
        usernameTextField.resignFirstResponder()
        emailTextField.resignFirstResponder()
        passwordField.resignFirstResponder()
        
        guard let username = usernameTextField.text, !username.isEmpty,
              let email = emailTextField.text, !email.isEmpty,
              let password = passwordField.text, !password.isEmpty, password.count >= 8 else {
            return
        }
        
        // register functionality
        AuthManager.shared.registerNewUser(username: username, email: email, password: password) { registered in
            DispatchQueue.main.async {
                if registered {
                    
                } else {
                    // failed
                    
                }
            }
        }
    }
}

// MARK: - UITextFieldDelegate
extension RegistrationViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == usernameTextField {
            // focus email text field
            emailTextField.becomeFirstResponder()
        } else if textField == emailTextField {
            passwordField.becomeFirstResponder()
        } else {
            didTapRegister()
        }
        return true
    }
}
