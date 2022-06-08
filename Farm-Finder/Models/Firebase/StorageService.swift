//
//  StorageService.swift
//  Farm-Finder
//
//  Created by Robin Xia on 2022-06-08.
//

import Foundation
import FirebaseAuth
import FirebaseStorage
import SwiftUI


class StorageService {
    
    let farmService = FarmService()
    
    func uploadImageToStorage(entry: FarmEntry?, image: UIImage, nameFieldText: String, descriptionText: String, locationTextField: String) {
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let storageRef = Storage.storage().reference().child("user\(uid)")
        
        guard let imageData = image.jpegData(compressionQuality: 1) else { return }
        
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"
        
        storageRef.putData(imageData, metadata: metaData) {
            metaData, error in
            if error == nil , metaData != nil {
                storageRef.downloadURL {url, error in
                    self.farmService.saveFarm(entry: entry, imageURL: url?.absoluteString ?? "", nameFieldText: nameFieldText, descriptionText: descriptionText, locationTextField: locationTextField)
                }
            }
            else {
                print("ERROR IN UPLOAD IMAGE FUNC")
                
            }
        }
    }
    
    
    
}
