//
//  ContentView.swift
//  Farm-Finder
//
//  Created by vatran robert on 2022-01-12.
//

import SwiftUI
import Firebase
import FirebaseStorage
import FirebaseFirestore
import MapKit

struct ContentView: View {
    
    @StateObject var userViewModel = UserViewModel()
    
    var body: some View {
        
        ZStack {
            
            LoginView()
            
        }
        .environmentObject(userViewModel)
        
        
        
    }

}


//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        //ContentView()
//        //EditProfileView()
//    }
//}
