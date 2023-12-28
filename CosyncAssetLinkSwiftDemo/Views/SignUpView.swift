//
//  SignUpView.swift
//  CosyncAssetLinkSwiftDemo
//
//  Created by Tola Voeung on 27/12/23.
//

import SwiftUI

struct SignUpView: View {
    @State private var email = ""
    @State private var password = ""
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        VStack() {
            Spacer()
            
            Image("CosyncLogo")
                .resizable()
                .scaledToFit()
                .frame(width: 150, height: 150)
                .padding([.top], 10)
            Spacer()
            
            Text("SIGN UP")
                .font(.system(size: 24, weight: .bold, design: .default))
                .foregroundColor(Color.blue)
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
                action: {
                    Task{
                        await self.signup()
                    }
                },
                label: {
                    Text("Sign Up")
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
    
    private func signup() async{
        
        if self.email.isEmpty || self.password.isEmpty {
            ToastManager.shared.send(title:"Signup Error", message:"Please enter email and password")
            return
        }
        self.appState.loading = true
        do {
            try await RM.signup(email: email, password: password)
            print("You are logged in")
            self.appState.target = .loggedIn
            self.appState.loading = false
        }
        catch{
            ToastManager.shared.send(title:"Signup Error", message:"\(error.localizedDescription)")
            self.appState.loading = false
        }
    }
    
}

#Preview {
    SignUpView()
}
