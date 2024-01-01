//
//  LoggedInView.swift
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

struct LoggedInView: View {
    
    @State private var selectedTab = "upload"
    
    var body: some View {
        TabView (selection: $selectedTab){

            UploadView().tabItem {
                Image(systemName: "square.and.arrow.up").renderingMode(.template)
                    .foregroundColor(Color(.brown))
                Text("Upload")
            }.tag("upload")
            
            AssetView().tabItem {
                Image(systemName: "photo.circle").renderingMode(.template)
                    .foregroundColor(Color(.brown))
                Text("Asset")
            }.tag("asset")
        }
    }
}

#Preview {
    LoggedInView()
}
