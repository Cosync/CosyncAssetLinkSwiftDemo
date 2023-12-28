//
//  CosyncAssetLinkSwiftDemoApp.swift
//  CosyncAssetLinkSwiftDemo
//
//  Created by Tola Voeung on 27/12/23.
//

import SwiftUI

@main
struct CosyncAssetLinkSwiftDemoApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(AppState())
        }
    }
}
