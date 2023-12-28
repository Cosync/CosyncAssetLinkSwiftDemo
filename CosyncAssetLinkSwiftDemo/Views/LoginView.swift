//
//  LoginView.swift
//  CosyncAssetLinkSwiftDemo
//
//  Created by Tola Voeung on 27/12/23.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var appState: AppState
    @State private var email = ""
    @State private var password = ""
    
    
    var body: some View {
        VStack() {
            Spacer()
            
            Image("CosyncLogo")
                .resizable()
                .scaledToFit()
                .frame(width: 150, height: 150)
                .padding([.top], 10)
            Spacer()
            
            TextField(
                "Enter email",
                text: $email
            )
            .autocapitalization(.none)
            .disableAutocorrection(true)
            .padding(.top, 20)
            
            Divider()
            
            SecureField(
                "Enter password",
                text: $password
            )
            .padding(.top, 20)
            
            Divider()
            
            
            Button(
                action: self.login,
                label: {
                    Text("Login")
                        .font(.system(size: 24, weight: .bold, design: .default))
                        .frame(maxWidth: .infinity, maxHeight: 60)
                        .foregroundColor(Color.white)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
            )

            Spacer()
        }
    }
    
    func login() {
        Task {
           
            if self.email.isEmpty || self.password.isEmpty {
                ToastManager.shared.send(title:"Invalid Data", message:"Please enter email and password")
                return
            }
            
            do {
                self.appState.loading = true
                try await RM.login(email: self.email, password: self.password)
                print("You are logged in")
                self.appState.target = .loggedIn
                self.appState.loading = false
            }
            catch {
                print("You got an error \(error.localizedDescription)")
            }
        }
    }
}

#Preview {
    LoginView()
}
