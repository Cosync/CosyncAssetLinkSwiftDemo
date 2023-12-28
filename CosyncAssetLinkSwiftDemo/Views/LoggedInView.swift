//
//  LoggedInView.swift
//  CosyncAssetLinkSwiftDemo
//
//  Created by Tola Voeung on 27/12/23.
//

import SwiftUI

struct LoggedInView: View {
    
    @State private var selectedTab = "upload"
    
    var body: some View {
        TabView (selection: $selectedTab){

            UploadView().tabItem {
                Image(systemName: "arrow.right.square").renderingMode(.template)
                    .foregroundColor(Color(.brown))
                Text("Upload")
            }.tag("upload")
            
            AssetView().tabItem {
                Image(systemName: "person.badge.plus").renderingMode(.template)
                    .foregroundColor(Color(.brown))
                Text("Asset")
            }.tag("asset")
        }
    }
}

#Preview {
    LoggedInView()
}
