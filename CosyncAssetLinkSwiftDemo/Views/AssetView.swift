//
//  AssetView.swift
//  CosyncAssetLinkSwiftDemo
//
//  Created by Tola Voeung on 27/12/23.
//

import SwiftUI
import RealmSwift
import CosyncAssetLinkSwift
 

struct AssetView: View { 
 
    @ObservedResults(CosyncAsset.self, sortDescriptor: SortDescriptor(keyPath: "createdAt", ascending: false)) var assetList
    
    var body: some View {
        VStack{
        
            Text("Cosync Asset")
       
            List{
                ForEach(assetList, id: \.self){ asset in
                   AssetRow(asset: asset)
                }
            }
        }
    }
}

#Preview {
    AssetView()
}
