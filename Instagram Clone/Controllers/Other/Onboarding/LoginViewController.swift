//
//  LoginViewController.swift
//  Instagram Clone
//
//  Created by Sunehar Sandhu on 4/10/21.
//

import UIKit
import SafariServices
import FirebaseAuth

class LoginViewController: UIViewController {
    
    // All declared constants here
    struct Constants {
        static let cornerRadius: CGFloat = 8.0
        static let textFieldBorderWidth: CGFloat = 1.0
        static let textFieldBorderColor: CGColor = UIColor.secondaryLabel.cgColor
    }
    
    private let headerView: UIView = {
        let header = UIView()
        header.clipsToBounds = true
        let backgroundImageView = UIImageView(image: UIImage(named: "gradient"))
        header.addSubview(backgroundImageView)
        return header
    }()
    
    private let usernameEmailTextField: UITextField = {
        let field = UITextField()
        field.placeholder = "Username or Email"
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
    
    private let loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("Log In", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = Constants.cornerRadius
        button.backgroundColor = .systemBlue
        return button
    }()
    
    private let createAccountButton: UIButton = {
        let button = UIButton()
        button.setTitle("New User? Create an Account", for: .normal)
        button.setTitleColor(.label, for: .normal)
        
        return button
    }()
    
    private let termsButton: UIButton = {
        let button = UIButton()
        button.setTitle("Terms of Service", for: .normal)
        button.setTitleColor(.secondaryLabel, for: .normal)
        return button
    }()
    
    private let privacyButton: UIButton = {
        let button = UIButton()
        button.setTitle("Privacy Policy", for: .normal)
        button.setTitleColor(.secondaryLabel, for: .normal)
        return button
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginButton.addTarget(self, action: #selector(didTapLoginButton), for: .touchUpInside)
        createAccountButton.addTarget(self, action: #selector(didTapCreateAccountButton), for: .touchUpInside)
        termsButton.addTarget(self, action: #selector(didTapTermsButton), for: .touchUpInside)
        privacyButton.addTarget(self, action: #selector(didTapPrivacyButton), for: .touchUpInside)
        
        usernameEmailTextField.delegate = self
        passwordField.delegate = self
        
        addSubViews()
        
        view.backgroundColor = .systemBackground
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // assign frames
        headerView.frame = CGRect(
            x: 0,
            y: 0,
            width: view.width,
            height: view.height/3.0
        )
        
        usernameEmailTextField.frame = CGRect(
            x: 25,
            y: headerView.bottom + 40,
            width: view.width - 50,
            height: 52
        )
        
        passwordField.frame = CGRect(
            x: 25,
            y: usernameEmailTextField.bottom + 10,
            width: view.width - 50,
            height: 52
        )
        
        loginButton.frame = CGRect(
            x: 25,
            y: passwordField.bottom + 10,
            width: view.width - 50,
            height: 52
        )
        
        createAccountButton.frame = CGRect(
            x: 25,
            y: loginButton.bottom + 10,
            width: view.width - 50,
            height: 52
        )
        
        termsButton.frame = CGRect(
            x: 10,
            y: view.height - view.safeAreaInsets.bottom - 100,
            width: view.width - 20,
            height: 50
        )
        
        privacyButton.frame = CGRect(
            x: 10,
            y: view.height - view.safeAreaInsets.bottom - 50,
            width: view.width - 20,
            height: 50
        )
        
        configureHeaderView()
    }
    
    private func addSubViews() {
        view.addSubview(headerView)
        view.addSubview(usernameEmailTextField)
        view.addSubview(passwordField)
        view.addSubview(loginButton)
        view.addSubview(createAccountButton)
        view.addSubview(termsButton)
        view.addSubview(privacyButton)
    }
    
    private func configureHeaderView() {
        guard headerView.subviews.count == 1 else { return }
        
        guard let backgroundView = headerView.subviews.first else { return }
        backgroundView.frame = headerView.bounds
        
        // Add instagram logo
        let imageView = UIImageView(image: UIImage(named: "text_logo"))
        headerView.addSubview(imageView)
        imageView.contentMode = .scaleAspectFit
        imageView.frame = CGRect(x: headerView.width/4, y: view.safeAreaInsets.top, width: headerView.width/2, height: headerView.height - view.safeAreaInsets.top)
        
    }
    
    @objc private func didTapLoginButton() {
        usernameEmailTextField.resignFirstResponder()
        passwordField.resignFirstResponder()
        
        guard let usernameEmail = usernameEmailTextField.text, !usernameEmail.isEmpty,
              let password = passwordField.text, !password.isEmpty, password.count >= 8 else {
            return
        }
        
        // login functionality
        var username: String?
        var email: String?
        
        // check if email was used
        if usernameEmail.contains("@"), usernameEmail.contains(".") {
            email = usernameEmail
        } else {
            username = usernameEmail
        }
        
        AuthManager.shared.loginUser(username: username, email: email, password: password) { success in
            DispatchQueue.main.async {
                if success {
                    // user logged in
                    self.dismiss(animated: true, completion: nil)
                } else {
                    // error occurred - create alert
                    let alert = UIAlertController(title: "Log In Error",
                                                  message: "Unable to log in",
                                                  preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Dismiss",
                                                  style: .cancel,
                                                  handler: nil))
                    self.present(alert, animated: true)
                }
            }
        }
        
    }
    
    @objc private func didTapTermsButton() {
        // instagram url for terms of service
        guard let url = URL(string: "https://help.instagram.com/1215086795543252") else { return }
        let vc = SFSafariViewController(url: url)
        present(vc, animated: true)
    }
    
    @objc private func didTapPrivacyButton() {
        // instagram url for privacy policy
        guard let url = URL(string: "https://help.instagram.com/519522125107875") else { return }
        let vc = SFSafariViewController(url: url)
        present(vc, animated: true)
    }
    
    @objc private func didTapCreateAccountButton() {
        let vc = RegistrationViewController()
        vc.title = "Create Account"
        present(UINavigationController(rootViewController: vc), animated: true)
    }
    
}

// MARK: - UITextFieldDelegate
extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == usernameEmailTextField {
            // focus the password text field
            passwordField.becomeFirstResponder()
        } else if textField == passwordField {
            didTapLoginButton()
        }
        return true
    }
}
