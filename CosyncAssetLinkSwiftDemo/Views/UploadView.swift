//
//  UploadView.swift
//  CosyncAssetLinkSwiftDemo
//
//  Licensed to the Apache Software Foundation (ASF) under one
//  or more contributor license agreements.  See the NOTICE file
//  distributed with this work for additional information
//  regarding copyright ownership.  The ASF licenses this file
//  to you under the Apache License, Version 2.0 (the
//  "License"); you may not use this file except in compliance
//  with the License.  You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing,
//  software distributed under the License is distributed on an
//  "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
//  KIND, either express or implied.  See the License for the
//  specific language governing permissions and limitations
//  under the License.
//
//  Created by Tola Voeung on 27/12/23.
//

import SwiftUI
import CosyncAssetLinkSwift
import RealmSwift
import AVKit
import Photos

struct SelectedAsset {
    
    enum MediaType {
        case image, video, audio, unknown
    }
    
    var id:String
    var url:URL
    var type: MediaType = .unknown
    
    var csUploadType: CSUploadItem.MediaType {
        switch type {
        case .image: return .image
        case .video: return .video
        case .audio: return .audio
        case .unknown: return .unknown
        }
    }
   
    
}
 
struct UploadView: View {
    
    enum Field {
       case caption
       case expiredHour
    }
    
    
    @State private var expiredHour: Double = 0.0
    @State private var showPicker: Bool = false
    @State private var pickerResult: [String] = []
    @State private var selectedType:String = "video"
    @State private var preferredType:String = "all"
    @State private var uploadStatus:String = ""
    @State private var uploadingAmount:Double = 0.0
    @State private var isUploading: Bool = false
    @State private var selectedImageErrorMessage:String?
    @State private var selectedVideoUrl:URL?
    @State private var selectedImage: UIImage?
    var uploadManager = CSUploadManager.shared
    @State private var selectedAsset: SelectedAsset?
    @State private var expirationHour:String = ""
    @State private var caption:String = ""
    @FocusState private var focusedField: Field?
    
    var uploads: [CSUploadItem] {
        var items: [CSUploadItem] = []
        if selectedAsset != nil {
            items.append(CSUploadItem(tag: selectedAsset!.id, url: selectedAsset!.url, mediaType: selectedAsset!.csUploadType, expiration: expiredHour, caption: caption))
        }
        return items
    }
    
    
   
    var body: some View {
        VStack{
            ZStack{
                if let image = selectedImage {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width:250, height:250)
                        .shadow(radius: 10)
                        .cornerRadius(10)
                }
                else if let vidoeUrl = selectedVideoUrl {
                    VideoPlayer(player: AVPlayer(url:  vidoeUrl))
                    .frame(width: 250, height: 250, alignment: .center)
                    .shadow(radius: 10)
                    .cornerRadius(10)
                }
                else {
                   
                    Image("CosyncLogo")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 250, height: 250)
                        .shadow(radius: 10)
                        .cornerRadius(10)
                }
            }
            
            
            
            Button(action: {
                preferredType = ""
                checkPhotoAccess()
            }, label: {
                Text("choose image/video")
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.blue)
                    .cornerRadius(12)
               
            })
            
            TextField(
                "Caption",
                text: $caption
            ) 
            .textFieldStyle(.roundedBorder)
            .padding(.top, 20)
            .focused($focusedField, equals: .caption)
            .submitLabel(.next)
            
            TextField(
                "Expiration Hour",
                text: $expirationHour
            )
            .onChange(of: expirationHour) { _ in
                expiredHour = Double(expirationHour) ?? 0.0
            }
            .keyboardType(.decimalPad)
            .textFieldStyle(.roundedBorder)
            .focused($focusedField, equals: .expiredHour)
            .padding(.top, 20) 
            
            
            if selectedImageErrorMessage != nil {
                Text("\(selectedImageErrorMessage ?? "")").foregroundColor(.red)
            }
            else {
                Text("\(uploadStatus)").padding()
            }
            
            if isUploading {
                ProgressView(("Uploading \( (uploadingAmount/1) * 100, specifier: "%.0f")%") , value: uploadingAmount, total: 1)
            }
            
            if let _ = selectedAsset {
                
                Button(action: {
                    uploadPhoto()
                    
                }, label: {
                    Text("Upload")
                        .font(.system(size: 24, weight: .bold, design: .default))
                        .frame(maxWidth: .infinity, maxHeight: 60)
                        .foregroundColor(Color.white)
                        .background(Color.blue)
                        .cornerRadius(10)
                })
            }
            
        }
        .padding()
        .fullScreenCover(isPresented: $showPicker, onDismiss: {showPicker = false}) {
            AssetPicker(pickerResult: self.$pickerResult, selectedImage: self.$selectedImage ,selectedVideoUrl: self.$selectedVideoUrl, selectedType: self.$selectedType, isPresented: self.$showPicker, errorMessage: self.$selectedImageErrorMessage, preferredType : self.preferredType, isMultipleSelection: false)
        }
        .onChange(of: selectedImage) { img in
        //.onChange(of: selectedImage) { // ios 17 up
            if img != nil {
                uploadStatus = ""
                selectedVideoUrl = nil
                selectedImageErrorMessage = nil
                uploadingAmount = 0.0
                
                self.selectedAsset = SelectedAsset(id: ObjectId.generate().stringValue, url: URL.str(pickerResult[0])!, type: .image)
            }
        }
        .onChange(of: selectedVideoUrl) { url in
        //.onChange(of: selectedVideoUrl) { _, url in // ios 17 up
            if url != nil {
                uploadStatus = ""
                selectedImage = nil
                selectedImageErrorMessage = nil
                uploadingAmount = 0.0
                if let url = url {
                    self.selectedAsset = SelectedAsset(id: ObjectId.generate().stringValue, url: url, type: .video)
                }
            }
        }
        .onSubmit {
           switch focusedField {
           case .caption:
               focusedField = .expiredHour
           case .expiredHour:
               hideKeyboard()
           case .none: break
               
           }
       }
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
               
                    Spacer()
                    Button {
                        hideKeyboard()
                    } label: {
                        Image(systemName: "keyboard.chevron.compact.down")
                    }
                
            }
        }
        .onAppear{
            focusedField = .caption
        }
    }
    
    
    @MainActor private func uploadPhoto(){
        if selectedAsset == nil || isUploading {
            ToastManager.shared.send(title:"Upload Error", message: "Please choose an image.")
            return
        }
        
        do {
            uploadingAmount = 0.0
            isUploading = true
            
            try uploadManager.uploadAssets(uploadItems: uploads) { (state: CSUploadState) in
                onUpload(state)
            }
        }
        catch {
            isUploading = false
            ToastManager.shared.send(title:"Upload Error", message: "Unable to upload asset.")
        }
    }
    
    
    private func checkPhotoAccess(){
        let readWriteStatus = PHPhotoLibrary.authorizationStatus(for: .readWrite)
        if readWriteStatus != PHAuthorizationStatus.authorized {
            // Request read-write access to the user's photo library.
            
            PHPhotoLibrary.requestAuthorization(for: .readWrite) { status in
                switch status {
                case .notDetermined:
                    // The user hasn't determined this app's access.
                    break
                case .restricted:
                    // The system restricted this app's access.
                    break
                case .denied:
                    // The user explicitly denied this app's access.
                    ToastManager.shared.send(title:"Upload Error", message: "Please allow app to access your photo library in your iPhone privacy setting")
                    break
                case .authorized:
                    // The user authorized this app to access Photos data.
                    showPicker = true
                    
                    break
                case .limited:
                    // The user authorized this app for limited Photos access.
                    ToastManager.shared.send(title:"Upload Error", message: "Unable to fully access all images.")
                    break
                @unknown default:
                    ToastManager.shared.send(title:"Upload Error", message: "Unable to access to any image.")
                    fatalError()
                }
            }
        }
        else {
            showPicker = true
        }
        
    }
    
    @MainActor func uploadImage(){
        do {
            try uploadManager.uploadAssets(uploadItems: uploads) { (state: CSUploadState) in
                onUpload(state)
            }
        }
        catch {
            ToastManager.shared.send(title:"Upload Error", message: "Unable to upload image.")
        }
    }
    
    @MainActor
    func onUpload(_ state: CSUploadState) {
        
        print("\(#function) UPLOAD STATE: \(state)")
        
        switch state {
            
        case .transactionStart:
            uploadStatus = "request uploading asset ..."
            break
            
        case .assetStart(let index, let total, _):
            uploadStatus = "Uploading \(index + 1) of \(total)"
            break
        
        case .assetInitError(_, _):
            uploadStatus = "error on uploading asset ..."
            break
            
        case .assetPogress( let bytes , let bytesTotal , _):
            let percentage = CGFloat(bytes) / CGFloat(bytesTotal)
            uploadingAmount = percentage
            if uploadingAmount == 1 {
                uploadStatus = "Asset is being created"
            }
            break
            
        case .assetUploadError(_, _):
            uploadStatus = "error uploading asset ..."
            break
            
        case .assetUploadEnd(_):
            uploadStatus = "Creating Cosync Asset"
            break
            
        case .transactionEnd(_, _):
            uploadStatus = "Your asset has been uploaded."
            isUploading = false
            self.selectedAsset = nil
            break
        }
    }
    
}

#Preview {
    UploadView()
}


#if canImport(UIKit)
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif
