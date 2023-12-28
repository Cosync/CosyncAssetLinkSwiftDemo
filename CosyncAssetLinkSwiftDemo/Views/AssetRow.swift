//
//  AssetRow.swift
//  CosyncAssetLinkSwiftDemo
//
//  Created by Tola Voeung on 27/12/23.
//

import SwiftUI
import RealmSwift
import AVKit
import CosyncAssetLinkSwift

struct AssetRow: View {
       
    @ObservedRealmObject var asset: CosyncAsset
    @State private var isRefresing = false
    
    var body: some View {
        HStack{
            if(asset.contentType!.contains("image")){
                AsyncImage(url: URL(string: asset.urlMedium!), transaction: .init(animation: .spring(response: 1.6))) { phase in
                            switch phase {
                            case .empty:
                                ProgressView()
                                    .progressViewStyle(.circular)
                            case .success(let image):
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                            case .failure:
                                 
                                
                                   Button(action: {
                                       Task{
                                           if isRefresing {
                                               return
                                           }
                                           
                                           isRefresing = true
                                           let _ = try await CSAssetManager.shared.refreshAsset(assetId: asset._id.stringValue)
                                           
                                           isRefresing = false
                                       }
                                       
                                     

                                   }) {
                                       if !isRefresing {
                                           Text("Refresh").foregroundColor(.red)
                                           Image(systemName: "arrow.clockwise.circle").foregroundColor(.red)
                                       }
                                       else {
                                           ProgressView().progressViewStyle(.circular)
                                       }
                                   }
                                   .padding()
                                
                                
                            @unknown default:
                                Text("Unknown error. Please try again.")
                                    .foregroundColor(.red)
                            }
                        }
                        .frame(width: 128, height: 128)
                        .clipShape(RoundedRectangle(cornerRadius: 25))
                Spacer()
                Text("\(asset.caption)")
            }
            else{
                if let url = asset.url {
                    
                    VideoPlayer(player: AVPlayer(url:  URL(string: url)!))
                    .id("\(asset._id)")
                    .padding()
                    .frame(width: 200, height: 200, alignment: .center)

                }
                else {
                    Image.init(uiImage: UIImage(systemName: "bookmark")!)
                        .padding()
                }
            }
        }.padding()
    }
}
 
