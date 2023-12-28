//
//  ContentView.swift
//  CosyncAssetLinkSwiftDemo
//
//  Created by Tola Voeung on 27/12/23.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var appState: AppState
    @State var showAlert = false
    @StateObject private var toast = ToastManager.shared
    
    var body: some View {
        VStack{
            Spacer()
            
            ZStack {
                if self.appState.target == .loggedOut {
                    LoggedOutView()
                 
                } else {
                    if let user = RM.app.currentUser{
                        LoggedInView().environment(\.realmConfiguration, user.flexibleSyncConfiguration())
                    }
                    else {
                        LoggedInView()
                    }
                }
                
                if(self.appState.loading){
                    ProgressView()
                }
                
                VStack{
                    ForEach(TM.notificationList, id: \.id){ item in
                        ToastView(toast: item)
                    }
                    Spacer()
                }
                
            } 
            
            Spacer()
        } 
        .environmentObject(appState)
        .padding()
    }
}

#Preview {
    ContentView()
}
