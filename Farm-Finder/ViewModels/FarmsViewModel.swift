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
    
    
//    func addMockdata() {
//        entries.append(FarmEntry.init(name: "Dallas", content: "Sell meat eggs eko", image: "egg",location: "Haninge", latitude: 59.11966,longitude: 18.11518))
//        entries.append(FarmEntry.init(name: "Österhaninge Gård", content: "Sell eko chicken meat and vegetables", image: "farm",location : "Västerhaninge" ,latitude:59.1216 ,longitude: 17.0973 ))
//        entries.append(FarmEntry.init(name: "Gårdsmejeri", content: "Sell eko chese", image: "chese" , location : "Årsta" ,latitude:59.1216 ,longitude: 19.0973 ))
//        entries.append(FarmEntry.init(name: "Dallas", content: "Sell meat eggs eko.Different prices for chese starting from 89 kr/kg, 30 eggs with 100kr and more products. Welcome to the farm to see our products", image: "egg",location: "Haninge", latitude: 59.11966,longitude: 18.11518))
//        entries.append(FarmEntry.init(name: "Österhaninge Gård", content: "Sell eko chicken meat and vegetables", image: "farm",location : "Västerhaninge" ,latitude:59.1216 ,longitude: 17.0973 ))
//        entries.append(FarmEntry.init(name: "Gårdsmejeri", content: "Sell eko chese", image: "chese" , location : "Årsta" ,latitude:59.1216 ,longitude: 19.0973 ))
//    }
    
    func subscribeToFarms() {
        
        farmService.listenToFirestore() { snapshot in
            
            self.entries.removeAll()
//            self.addMockdata()
            
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
