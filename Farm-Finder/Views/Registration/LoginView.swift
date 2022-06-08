//
//  LoginView.swift
//  Farm-Finder
//
//  Created by vatran robert on 2022-01-14.
//

import SwiftUI
import FirebaseAuth



struct LoginView: View {
    
    @State var email  = ""
    @State var password  = ""
    @State var visible = false
    @EnvironmentObject var user : UserViewModel
    @State private var keyboardHeight: CGFloat = 140
    
    var body: some View {
        
        NavigationView{
            
            VStack{
                
                Image("logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 350, height: 200)
                    .lineLimit(100)
                    .overlay {
                        Text("Farm Finder")
                            .font(.largeTitle)
                            .offset(y: 100)
                            .foregroundColor(.blue)
                    }
                
                NavigationLink(destination: FarmListView())
                {
                    Text("Browse the farms")
                        .foregroundColor(Color.white)
                        .frame(width: 300, height: 70)
                        .font(.title2)
                        .background(Color.blue)
                        .cornerRadius(25)
                        .padding()
                }
                
                Text("Or Login with your farm")
                    .frame(width: 200, height: 20, alignment: .center)
                    .foregroundColor(Color.white)
                    .background(Color.green)
                    .cornerRadius(20)
                    .padding()
                
                TextField("Email Adress",text: $email)
                    .disableAutocorrection(true)
                    .autocapitalization(.none)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                
                HStack(spacing: 15){
                    
                    if self.visible {
                        TextField("Password", text: $password)
                            .disableAutocorrection(true)
                            .autocapitalization(.none)
                        
                    }
                    else {
                        SecureField("Password", text: $password)
                            .disableAutocorrection(true)
                            .autocapitalization(.none)
                        
                    }
                    Button(action: {
                        self.visible.toggle()
                    },label: {
                        
                        Image(systemName: self.visible ? "eye.slash.fill" : "eye.fill")
                            .foregroundColor(Color.primary)
                    })
                }
                .padding()
                .background(Color(.secondarySystemBackground))
                
                NavigationLink(destination: EditProfileView(),isActive: $user.signedIn){EmptyView()
                }
                Button(action: {
                    
                    user.signIn(email: email, password: password)
                    
                }, label: {
                    Text("Login")
                        .foregroundColor(Color.white)
                        .frame(width: 200, height:50)
                        .background(Color.blue)
                        .cornerRadius(25)
                        .padding()
                })
                
                NavigationLink("Register your farm",destination: SignUpView())
                Spacer()
            }
            .padding()
            .padding(.bottom,keyboardHeight)
            .navigationTitle("Login Page")
        }
    }
}

