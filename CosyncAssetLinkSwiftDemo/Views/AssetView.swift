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
 
    @ObservedResults(CosyncAsset.self, where: {($0.userId == RM.user!.id)}, sortDescriptor: SortDescriptor(keyPath: "createdAt", ascending: false)) var assetList
    
    var body: some View {
        VStack{
        
            Text("Cosync Asset")
            
            if assetList.count == 0 {
                Text("There is no Cosync Asset")
            }
       
            List(assetList, id: \._id) { asset in
               AssetRow(asset: asset) 
            }
        }
    }
}

#Preview {
    AssetView()
}
