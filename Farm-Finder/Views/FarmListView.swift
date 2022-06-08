//
//  FarmListView.swift
//  Farm-Finder
//
//  Created by Robin Xia on 2022-06-08.
//

import SwiftUI

struct FarmListView: View {
    
    @StateObject var farms = FarmsViewModel()
    
    var body: some View {
        
        
        List() {
            
            ForEach(farms.entries) { entry in
                
                NavigationLink(destination: FarmEntryView(entry: entry)) {
                    
                    HStack{
                        
                        AsyncImage(url: URL(string: entry.image)){image in
                            image
                                .resizable()
                                .frame(width: 130, height: 130)
                                .scaledToFit()
                                .clipShape(Circle())
                        }  placeholder: {
                            Image(systemName: "photo")
                                .resizable()
                                .frame(width: 130, height: 130)
                                .scaledToFit()
                                .clipShape(Circle())
                        }
                        VStack{
                            Text(entry.name)
                                .font(.headline)
                            
                            Text(entry.content)
                                .lineLimit(1)
                                .padding()
                        }
                    }
                }
            }
            .background(Color.clear)
            .padding(5)
            .cornerRadius(20)
        }
        .onAppear() {
            farms.subscribeToFarms()
        }
        
    }
}

