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
    @State private var contentType = ""
    @State private var isPlaying = false
    @State private var player:AVPlayer?
    
    var body: some View {
        VStack{
            
            if let urlMedium = asset.urlMedium {
                HStack{
                    
                    if contentType.contains("image") {
                        
                        AsyncImage(url: URL(string: urlMedium), transaction: .init(animation: .spring(response: 1.6))) { phase in
                            switch phase {
                            case .empty:
                                ProgressView()
                                    .progressViewStyle(.circular)
                            case .success(let image):
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                            case .failure:
                                Text("Invalid URL. Reloading asset...")
                                    .foregroundColor(.red)
                                
                                
                            @unknown default:
                                Text("Unknown error. Please try again.")
                                    .foregroundColor(.red)
                            }
                        }
                        .frame(width: 200, height: 200, alignment: .center)
                        .clipShape(RoundedRectangle(cornerRadius: 25))
                        
                        
                    }
                    else if contentType.contains("video") || contentType.contains("sound") {
                        
                        HStack {
                            Button(action: {
                                if isPlaying == false {
                                    playVideo()
                                }
                                else {
                                    stopVideo()
                                }
                                
                            }) {
                                loadVideoView
                                
                            }.buttonStyle(BorderlessButtonStyle())
                        }
                        
                        
                    }
                    else {
                        Image.init(uiImage: UIImage(systemName: "bookmark")!)
                            .padding()
                    }
                    
                    Spacer()
                    
                    if isDeleting {
                        ProgressView().progressViewStyle(.circular)
                    }
                    else {
                        
                        Button {
                            
                            Task{
                                isDeleting = true
                                let _ = try await CSAssetManager.shared.updateAssetStatus(assetId: asset._id, status: "deleted")
                            }
                        } label: {
                            Image(systemName: "trash").tint(.red)
                        }
                        .padding()
                    }
                    
                    
                }.padding()
                
                Text("\(asset.caption)")
            }
            else {
                Image.init(uiImage: UIImage(systemName: "bookmark")!)
                    .padding()
            }
        }
        .padding()
        .onAppear{
            self.contentType = asset.contentType ?? ""
            
           
            
            checkExpiredDate()
        }
    }
    
    
    var loadVideoView : some View {
        ZStack{
            
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
                    Text("Invalid URL. Reloading asset...")
                        .foregroundColor(.red)
                    
                    
                @unknown default:
                    Text("Unknown error. Please try again.")
                        .foregroundColor(.red)
                }
            }
            .frame(width: 200, height: 200, alignment: .center)
            .clipShape(RoundedRectangle(cornerRadius: 25))
            
            
            if let player = player, isPlaying == true {
                VideoPlayer(player: player, videoOverlay: {
                    VStack(alignment: .leading) {
                        Text("Video")
                            .foregroundColor(Color.gray)
                            .bold()
                            .font(Font.body)
                            .padding(.all, 10)
                        Spacer()
                    }
                })
                .frame(width: 200, height: 200, alignment: .center)
                .clipShape(RoundedRectangle(cornerRadius: 25))
            }
            
            if isPlaying == false {
                
                Image(systemName: "play.circle")
                    .resizable()
                    .frame(width: 30, height: 30)
                    .imageScale(.large)
                    .background(Color(white: 1, opacity: 0.7))
                    .clipShape(Circle())
               
            }
            else {
                
                Image(systemName: "stop.circle")
                    .resizable()
                    .frame(width: 30, height: 30)
                    .imageScale(.large)
                    .background(Color(white: 1, opacity: 0.7))
                    .clipShape(Circle())
            }
            
        }.onAppear{
            player = AVPlayer(url: URL(string: asset.url!)!)
        }
         
    }
    
   
    
    private func playVideo(){
        isPlaying = true
      
        if let player = player {
            player.pause()
            player.seek(to: .zero)
            do {
                try AVAudioSession.sharedInstance().setCategory(.playback)
                player.play()
            }
            catch {
                
            }
        }
    }
    
    private func stopVideo(){
        isPlaying = false
        if let player = player{
            player.pause()
        }
    }
    
    private func checkExpiredDate(){
        
        if let expiration = asset.expiration {
            
            print("\(expiration)")
            
            let now = Date.now
            if now.compare(expiration) == .orderedDescending {
                Task{
                   
                    if let _ = try await CSAssetManager.shared.refreshAsset(assetId: asset._id.stringValue){
                      
                    }
                     
                }
            }
            
        }
        
    }
}
 
