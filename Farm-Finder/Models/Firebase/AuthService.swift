//
//  AuthService.swift
//  Farm-Finder
//
//  Created by Robin Xia on 2022-06-08.
//

import Foundation
import FirebaseAuth

class AuthService {
    
    let auth = Auth.auth()
    
    func signIn(email: String, password: String, completion: @escaping (_ onSuccess: Bool) -> Void ) {
        
        auth.signIn(withEmail: email, password: password) {
            [weak self] result, error in
            guard result != nil, error == nil
            else {
                return
            }
            completion(true)
        }
    }

    func signUp(email: String, password: String, completion: @escaping (_ onSuccess: Bool) -> Void){
        auth.createUser(withEmail: email, password: password) {
            [weak self] result, error in
            guard result != nil, error == nil else {
                return
            }
            
            completion(true)
            
        }
    }

    
}

