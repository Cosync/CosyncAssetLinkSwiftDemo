//
//  AppState.swift
//  CosyncAssetLinkSwiftDemo
//
//  Created by Tola Voeung on 27/12/23.
//

import Foundation
 


class AppState: ObservableObject {
    
    enum TargetUI: Int {
        case none
        case loggedOut
        case loggedIn
         
    }
    
    @Published var loading = false
    @Published var target: TargetUI = .loggedOut
}
