//
//  DatabaseManager.swift
//  Instagram Clone
//
//  Created by Sunehar Sandhu on 4/11/21.
//

import FirebaseDatabase

public class DatabaseManager {
    
    static let shared = DatabaseManager()
    
    private let database = Database.database().reference()
    
    // MARK: - Public
    
    /// Check if username and email is available
    /// - Parameters
    ///     - email: String representing email
    ///     - username: String representing username
    public func canCreateNewUser(with email: String, username: String, completion: @escaping (Bool) -> Void) {
        completion(true)
    }
    
    /// Insert new user data to database
    /// - Parameters
    ///     - email: String representing email
    ///     - username: String representing username
    ///     - completion: Async callback  for result if databse entry succeeded
    public func insertNewUser(with email: String, username: String, completion: @escaping (Bool) -> Void) {
        database.child(email.safeDatabaseKey()).setValue(["username":username]) { (error, _) in
            if error == nil {
                // success
                completion(true)
            } else {
                // failed
                completion(false)
                return
            }
        }
    }
}
