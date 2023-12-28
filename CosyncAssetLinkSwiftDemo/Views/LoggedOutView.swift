//
//  LoggedOutView.swift
//  CosyncAssetLinkSwiftDemo
//
//  Created by Tola Voeung on 27/12/23.
//

import SwiftUI

struct LoggedOutView: View {
    
    @State private var selectedTab = "login"
    
    var body: some View {
        TabView (selection: $selectedTab){

            LoginView().tabItem {
                Image(systemName: "arrow.right.square").renderingMode(.template)
                    .foregroundColor(Color(.brown))
                Text("Login")
            }.tag("login")
            
            SignUpView().tabItem {
                Image(systemName: "person.badge.plus").renderingMode(.template)
                    .foregroundColor(Color(.brown))
                Text("Signup")
            }.tag("signup")
        }
    }
}

#Preview {
    LoggedOutView()
}
