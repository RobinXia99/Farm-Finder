//
//  FarmPage.swift
//  Farm-Finder
//
//  Created by vatran robert on 2022-01-12.
//

import Foundation
import SwiftUI

class FarmsViewModel : ObservableObject {
    
    @Published var entries = [FarmEntry]()
    let farmService = FarmService()
    
    
    func subscribeToFarms() {
        
        farmService.listenToFirestore() { snapshot in
            
            self.entries.removeAll()
            
            for document in snapshot.documents {
                let result = Result {
                    try document.data(as: FarmEntry.self)
                }
                switch result {
                    
                case.success(let item ):
                    
                    if let item = item {
                        
                        self.entries.append(item)
                        
                    } else {
                        
                        print("Document does not exist")
                        
                    }
                    
                case.failure(let error):
                    
                    print("Error decoding item \(error)")
                    
                }
            }
        }
    }
    
}
