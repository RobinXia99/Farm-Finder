//
//  EditProfileView.swift
//  Farm-Finder
//
//  Created by Robin Xia on 2022-06-08.
//

import SwiftUI
import MapKit
import FirebaseAuth

struct EditProfileView : View {
    
    @EnvironmentObject var userViewModel : UserViewModel
    @ObservedObject private var locationManager = LocationManager()
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var storageService = StorageService()
    var farmService = FarmService()
    
    @State var showActionSheet = false
    @State var showImagePicker = false
    @State var sourceType : UIImagePickerController.SourceType = .camera
    @State var uploadImage : UIImage?
    @State var descriptionText : String = ""
    @State var nameFieldText : String = ""
    @State var locationTextField : String = ""
    @State private var imageURL = URL(string:"")
    @State private var showingLocationSheet = false
    @State var entry: FarmEntry? = nil
    
    @State var tapped = false
    
    var tap: some Gesture {
        TapGesture(count: 1)
            .onEnded { _ in self.tapped = !self.tapped
                showingLocationSheet = false
                print("tapped")
            }
    }
    
    
    var body: some View {
        
        let coordinate = locationManager.location?.coordinate ?? CLLocationCoordinate2D()
        
        ScrollView {
            
            VStack {
                
                Button(action: {
                    self.showActionSheet = true
                    
                }, label: {
                    
                    if uploadImage != nil {
                        Image(uiImage: uploadImage!)
                            .resizable()
                            .frame(width: 200, height: 200)
                            .clipShape(Circle())
                        
                    } else {
                        
                        if let entry = entry {
                            
                            AsyncImage(url: URL(string: entry.image)){image in
                                image
                                    .resizable()
                                    .frame(width: 200, height: 200)
                                    .clipShape(Circle())
                            }  placeholder: {
                                Image(systemName: "photo")
                                    .resizable()
                                    .frame(width: 200, height: 200)
                                    .scaledToFit()
                                    .clipShape(Circle())
                            }
                            
                        } else {
                            Image(systemName: "photo")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 200, height: 200, alignment: .trailing)
                                .clipShape(Circle())
                        }
                    }
                    
                }).actionSheet(isPresented: $showActionSheet){
                    ActionSheet(title: Text("Add a picture to the profile"), message: nil, buttons: [
                        
                        .default(Text("Camera"),action: {
                            self.showImagePicker = true
                            self.sourceType = .camera
                        }),
                        .default(Text("Photo library"), action: {
                            self.showImagePicker = true
                            self.sourceType = .photoLibrary
                        }),
                        .cancel()
                    ])
                }
                .sheet(isPresented: $showImagePicker){
                    imagePicker(image: self.$uploadImage, showImagePicker:
                                    self.$showImagePicker, sourceType:
                                    self.sourceType)
                }
                
                Text("Add a picture ")
                
                if entry != nil {
                    
                    TextField("Farm Name",text: $nameFieldText)
                        .font(.largeTitle)
                        .padding(5)
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(20)
                }
                if entry != nil {
                    
                    TextField("City",text: $locationTextField)
                        .font(.title)
                        .padding(6)
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(20)
                }
                Button("Save location on map") {
                    showingLocationSheet.toggle()
                }
                
                .sheet(isPresented: $showingLocationSheet){
                    if let entry = entry {
                        
                        MapView(coordinate: coordinate, entry: entry)
                        
                            .overlay {
                                
                                Image(systemName: "x.circle.fill")
                                    .frame(width: 50, height: 50, alignment: .topLeading)
                                    .font(.title)
                                    .offset(x: -160, y: -300)
                                    .gesture(tap)
                                
                            }
                        
                        Text("\(coordinate.latitude), \(coordinate.longitude)")
                            .foregroundColor(.white)
                            .background(.green)
                            .padding(10)
                        
                        Button(action: {
                            
                            self.entry?.latitude = coordinate.latitude
                            self.entry?.longitude = coordinate.longitude
                            showingLocationSheet = false
                            
                        }, label: {
                            
                            Text("Save Location")
                                .font(.headline)
                                .frame(width: 200, height: 60)
                                .foregroundColor(.white)
                                .background(.red)
                                .cornerRadius(25)
                        })
                    }
                }
                Text("Write down info about your farm")
                    .frame(width: 300, height: 20, alignment: .center)
                
                ScrollView{
                    if entry != nil {
                        
                        ZStack(alignment: .topLeading) {
                            
                            RoundedRectangle(cornerRadius: 20, style: .continuous)
                                .fill(Color(UIColor.secondarySystemBackground))
                            
                            if descriptionText.isEmpty {
                                
                                Text("Write here")
                                    .foregroundColor(Color(UIColor.placeholderText))
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 12)
                                
                            } else {
                                
                                TextEditor(text: $descriptionText)
                                    .font(.title)
                                    .frame(width: 400, height: 250, alignment: .topLeading)
                                    .disableAutocorrection(true)
                            }
                            
                            if entry?.content == "" {
                                
                                TextEditor(text: $descriptionText)
                                    .font(.title)
                                    .frame(width: 400, height: 250, alignment: .topLeading)
                                    .disableAutocorrection(true)
                                
                            }
                        }
                    }
                }
                
                Button(action: {
                    if let image = self.uploadImage {
                        storageService.uploadImageToStorage(entry: entry, image: image, nameFieldText: nameFieldText, descriptionText: descriptionText, locationTextField: locationTextField)
                        self.presentationMode.wrappedValue.dismiss()
                        
                    } else {
                        
                        print("error in upload")
                        farmService.saveFarm(entry: entry, imageURL: (entry?.image ?? "") as String, nameFieldText: nameFieldText, descriptionText: descriptionText, locationTextField: locationTextField)
                        self.presentationMode.wrappedValue.dismiss()
                    }
                    
                }, label: {
                    
                    Text("Save")
                        .foregroundColor(Color.white)
                        .frame(width: 200, height:50)
                        .background(Color.blue)
                        .cornerRadius(25)
                })
                
                Spacer()
                
            }
            .padding()
        }
        .onAppear() {
            
            guard let uid = Auth.auth().currentUser?.uid else { return }
            
            self.entry = FarmEntry(owner: uid ,name: "", content: "", image: "",location: "", latitude: 0.0, longitude: 0.0)
            
            farmService.getUserFarm(uid: uid) { userFarm in
                
                self.entry = userFarm
                
                nameFieldText = entry?.name ?? "Farm Name"
                descriptionText = entry?.content ?? "Description of your farm"
                locationTextField = entry?.location ?? "City"
                
                
            }
            
            
        }
    }
    
}

