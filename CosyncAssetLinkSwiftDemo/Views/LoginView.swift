//
//  LoginView.swift
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

struct LoginView: View {
    @EnvironmentObject var appState: AppState
    @State private var email = "tolacambo@gmail.com"
    @State private var password = "qwerty"
    
    
    var body: some View {
        VStack() {
            Spacer()
            
            Image("CosyncLogo")
                .resizable()
                .scaledToFit()
                .frame(width: 150, height: 150)
                .padding([.top], 10)
            Spacer()
            
            Text("LOG IN")
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
                self.appState.loading = false
                ToastManager.shared.send(title:"Invalid Data", message:"\(error.localizedDescription)")
                print("You got an error \(error.localizedDescription)")
            }
        }
    }
}

#Preview {
    LoginView()
}
