//
//  AuthManager.swift
//  Instagram Clone
//
//  Created by Sunehar Sandhu on 4/11/21.
//

import FirebaseAuth

public class AuthManager {
    
    static let shared = AuthManager()
    
    // MARK: - Public
    public func registerNewUser(username: String, email: String, password: String, completion: @escaping (Bool) -> Void) {
        /*
         - Check if username is available
         - Check if email is available
         */
        DatabaseManager.shared.canCreateNewUser(with: email, username: username) { canCreate in
            if canCreate {
                /*
                 - Create account
                 - Insert account into database
                 */
                Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
                    guard authResult != nil, error == nil else {
                        // Firebase auth could not create account
                        completion(false)
                        return
                    }
                    // insert into database
                    DatabaseManager.shared.insertNewUser(with: email, username: username) { inserted in
                        if inserted {
                            completion(true)
                            return
                        } else {
                            // Failed to insert to database
                            completion(false)
                            return
                        }
                    }
                }
            } else {
                // either username or email does not exist
                completion(false)
            }
        }
    }
    
    public func loginUser(username: String?, email: String?, password: String, completion: @escaping (Bool) -> Void) {
        // email login
        if let email = email {
            Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
                guard authResult != nil, error == nil else {
                    // error occurred
                    completion(false)
                    return
                }
                // success
                completion(true)
            }
        }
        // username login
        else if let username = username {
            
        }
    }
}
