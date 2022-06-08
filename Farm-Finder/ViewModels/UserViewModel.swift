//
//  UserViewModel.swift
//  Farm-Finder
//
//  Created by Robin Xia on 2022-06-08.
//

import Foundation


class UserViewModel: ObservableObject {
    
    @Published var signedIn = false
    let authService = AuthService()
    
    func signIn (email: String, password: String) {
        
        authService.signIn(email: email, password: password) { onSuccess in
            
            if onSuccess {
                
                self.signedIn = true
                
            }
        }
    }
    
    func signUp (email: String, password: String) {
        
        authService.signUp(email: email, password: password) { onSuccess in
            
            if onSuccess {
                
                self.signedIn = true
                
            }
            
        }
        
    }
    

}
