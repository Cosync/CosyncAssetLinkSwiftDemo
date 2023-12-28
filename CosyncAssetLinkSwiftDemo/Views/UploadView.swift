//
//  UploadView.swift
//  CosyncAssetLinkSwiftDemo
//
//  Created by Tola Voeung on 27/12/23.
//

import SwiftUI
import CosyncAssetLinkSwift
import RealmSwift

struct UploadView: View {
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
    @State private var uploads: [CSUploadItem]  = []
    
    var body: some View {
        VStack{
            Text("Tap on image to choose an image")
            Button(action: {
                preferredType = ""
                showPicker = true
            }, label: {
                if let image = selectedImage {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width:250, height:250)
                        .shadow(radius: 10)
                        .cornerRadius(10)
                }
                else {
                    Image(uiImage: UIImage(systemName: "photo")!)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 250, height: 250)
                        .shadow(radius: 10)
                        .cornerRadius(10)
                }
            })
            
            Text("\(uploadStatus)").padding()
            
            if isUploading {
                ProgressView(("Uploading \( (uploadingAmount/1) * 100, specifier: "%.0f")%") , value: uploadingAmount, total: 1)
            }
            
            Button(action: {
                
                if uploads.count == 0 || isUploading {
                    ToastManager.shared.send(title:"Upload Error", message: "Please choose an image.")
                    return
                }
                
                do {
                    isUploading = true
                    try uploadManager.uploadAssets(uploadItems: uploads) { (state: CSUploadState) in
                        onUpload(state)
                    }
                }
                catch {
                    isUploading = false
                    ToastManager.shared.send(title:"Upload Error", message: "Unable to upload asset.")
                }
                
                
            }, label: {
                Text("Upload")
                    .font(.system(size: 24, weight: .bold, design: .default))
                    .frame(maxWidth: .infinity, maxHeight: 60)
                    .foregroundColor(Color.white)
                    .background(Color.blue)
                    .cornerRadius(10)
            })
            
            
                
            
        }
        .padding()
        .fullScreenCover(isPresented: $showPicker, onDismiss: {showPicker = false}) {
            AssetPicker(pickerResult: self.$pickerResult, selectedImage: self.$selectedImage ,selectedVideoUrl: self.$selectedVideoUrl, selectedType: self.$selectedType, isPresented: self.$showPicker, errorMessage: self.$selectedImageErrorMessage, preferredType : self.preferredType, isMultipleSelection: false)
        }
        .onChange(of: selectedImage) {
            self.uploads = [CSUploadItem(tag: ObjectId.generate().stringValue, url: URL.str(pickerResult[0])!, mediaType: CSUploadItem.MediaType.image, expiration:expiredHour)]
        }
        .onChange(of: selectedVideoUrl) { _, url in
            if let url = url {
                self.uploads = [CSUploadItem(tag: ObjectId.generate().stringValue, url: url, mediaType: CSUploadItem.MediaType.video, expiration:expiredHour)]
            }
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
            self.uploads = []
            break
        }
    }
    
}

#Preview {
    UploadView()
}
