//
//  ToastView.swift
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

struct ToastView: View {
    
    var toast:ToastDataModel;
    @State private var isShowing = true
    @State private var dragOffset = CGSize.zero
    @State private var opacity = 1.0
    
    var body: some View {
        if isShowing {
            HStack(alignment:.top){
               
                VStack (alignment: .leading){
                    if toast.title != "" {
                        Text(toast.title).foregroundColor(toast.type == "error" ? .red : .blue)
                            .font(.headline)
                    }
                    
                    Spacer()
                    Text(toast.message).font(.subheadline)
                        .lineLimit(5)
                   
                    Spacer()
                }
                .padding(EdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5))
                .frame( maxWidth: .infinity, minHeight: 60, maxHeight:120, alignment: .topLeading)
               
                Button(action: {
                    withAnimation{
                        dismiss()
                    }
                }){
                    Image(systemName: "xmark.circle.fill").foregroundColor(.black)
                }
                
            }
            .fixedSize(horizontal: false, vertical: true)
            .foregroundColor(.black)
            .frame(maxWidth: .infinity, alignment: .topLeading)
            .padding(5)
            .background(Color.white)
            .cornerRadius(15)
            .shadow(radius: 3)
            .opacity(opacity)
            .onAppear{
                DispatchQueue.main.asyncAfter(deadline: .now() + 5){
                    withAnimation{
                        dismiss()
                    }
                }
            }
            .padding(10)
        }
    }
    
    private func dismiss(){
        withAnimation{
            isShowing = false
        }
        TM.dismiss(toast: toast)
    }
    
}
 
