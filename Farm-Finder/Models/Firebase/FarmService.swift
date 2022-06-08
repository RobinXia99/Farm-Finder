//
//  FarmService.swift
//  Farm-Finder
//
//  Created by Robin Xia on 2022-06-08.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class FarmService {
    
    let db = Firestore.firestore()
    
    func listenToFirestore (completion: @escaping (_ snapshot: QuerySnapshot) -> Void) {
        
        db.collection("farms").addSnapshotListener { snapshot, err in
            guard let snapshot = snapshot else { return }
            
            if let err = err {
                print("Error to get documents \(err)")
            } else {
                
                completion(snapshot)
                
            }
        }
    }
    
    func saveFarm (entry: FarmEntry? ,imageURL: String, nameFieldText: String, descriptionText: String, locationTextField: String) {
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let user = FarmEntry(owner: uid, name: nameFieldText, content: descriptionText, image : imageURL ?? entry?.image as! String ,location: locationTextField , latitude: entry?.latitude ?? 59.11966, longitude: entry?.longitude ?? 18.11518)
        
        do {
            _ = try db.collection("farms").document(uid).setData(from: user)
            
        } catch {
            print("Error in saving the data")
        }
    }
    
    func getUserFarm (uid: String, completion: @escaping ( _ userFarm: FarmEntry) -> Void) {
        
        db.collection("farms").whereField("owner", isEqualTo: uid).getDocuments() { snapshot, err in
            
            guard let snapshot = snapshot else { return }
            
            if let err = err {
                
                print("Error to get documents \(err)")
                
            } else {
                
                for document in snapshot.documents {
                    
                    let result = Result {
                        try document.data(as: FarmEntry.self)
                    }
                    
                    switch result {
                        
                    case.success(let item ) :
                        if let item = item {
        
                            completion(item)
                            
                        } else {
                            
                            print("Document does not exist")
                            
                        }
                        
                    case.failure(let error) :
                        print("Error decoding item \(error)")
                    }
                    
                }
                
            }
        }
    }
    
    
    
}
