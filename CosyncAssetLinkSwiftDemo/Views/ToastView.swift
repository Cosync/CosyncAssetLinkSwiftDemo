//
//  ToastView.swift
//  CosyncAssetLinkSwiftDemo
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
                    Image(systemName: "xmark.circle.fill").foregroundColor(.red)
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
 
