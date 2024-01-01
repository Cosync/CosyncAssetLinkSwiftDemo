//
//  AssetRow.swift
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
import RealmSwift
import AVKit
import CosyncAssetLinkSwift

struct AssetRow: View {
       
    @ObservedRealmObject var asset: CosyncAsset
    @State private var isRefresing = false
    @State private var isDeleting = false
    
    var body: some View {
        VStack{
            HStack{
                if((asset.contentType?.contains("image")) != nil){
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
                    
                }
                else{
                    if let url = asset.url {
                        
                        VideoPlayer(player: AVPlayer(url:  URL(string: url)!))
                            .id("\(asset._id)")
                            .frame(width: 200, height: 200, alignment: .center)
                            .shadow(radius: 10)
                            .cornerRadius(10)
                    }
                    else {
                        Image.init(uiImage: UIImage(systemName: "bookmark")!)
                            .padding()
                    }
                }
                
                Spacer()
                if isDeleting {
                    ProgressView().progressViewStyle(.circular)
                }
                else {
                    Button(action: {
                        Task{
                            isDeleting = true
                            let _ = try await CSAssetManager.shared.updateAssetStatus(assetId: asset._id, status: "deleted")
                        }
                        
                    }) {
                        Image(systemName: "trash").foregroundColor(.red)
                    }
                    .padding()
                }
            }.padding()
            
            Text("\(asset.caption)")
        }
    }
}
 
