//
//  SignUpView.swift
//  Farm-Finder
//
//  Created by Robin Xia on 2022-06-08.
//

import SwiftUI

struct SignUpView: View {
    
    @EnvironmentObject var userViewModel : UserViewModel
    
    @State var email  = ""
    @State var password  = ""
    @State var verifyPassword = ""
    @State var showingPassword = false
    
    @State private var keyboardHeight: CGFloat = 100
    
    var body: some View {
        
        VStack{
            
            Image("logo")
                .resizable()
                .position(x: 225, y: 50)
                .frame(width: 450, height: 300)
            
            TextField("Email Adress",text: $email)
                .disableAutocorrection(true)
                .autocapitalization(.none)
                .padding()
                .background(Color(.secondarySystemBackground))
            
            HStack(spacing: 15){
                
                if self.showingPassword {
                    TextField("Password", text: $password)
                        .disableAutocorrection(true)
                        .autocapitalization(.none)
                    
                } else {
                    
                    SecureField("Password", text: $password)
                        .disableAutocorrection(true)
                        .autocapitalization(.none)
                }
                
                Button(action: {
                    self.showingPassword.toggle()
                },label: {
                    
                    Image(systemName: self.showingPassword ? "eye.slash.fill" : "eye.fill")
                        .foregroundColor(Color.primary)
                    
                })
            }
            .padding()
            .background(Color(.secondarySystemBackground))
            
            HStack(spacing: 15){
                
                if self.showingPassword {
                    TextField("Retype Password", text: $verifyPassword)
                        .disableAutocorrection(true)
                        .autocapitalization(.none)
                }
                else {
                    SecureField("Retype Password", text: $verifyPassword)
                        .disableAutocorrection(true)
                        .autocapitalization(.none)
                }
                Button(action: {
                    self.showingPassword.toggle()
                },label: {
                    
                    Image(systemName: self.showingPassword ? "eye.slash.fill" : "eye.fill")
                        .foregroundColor(Color.primary)
                    
                })
            }
            .padding()
            .background(Color(.secondarySystemBackground))
            
            
            NavigationLink(destination: LoginView() ,isActive: $userViewModel.signedIn){EmptyView()
            }
            Button(action: {
                
                if password == verifyPassword {
                    userViewModel.signUp(email: email, password: password)
                    
                } else {
                    
                    showingPassword = true
                    password = "Type mismatch"
                    verifyPassword = "Type mismatch"
                    
                }
                
            }, label: {
                Text("Create Account")
                    .foregroundColor(Color.white)
                    .frame(width: 200, height:50)
                    .background(Color.blue)
                    .cornerRadius(25)
                
            })
                .padding()
            Spacer()
        }
        .padding()
        .padding(.bottom,keyboardHeight)
        .navigationTitle("Register")
        
        
    }
}
