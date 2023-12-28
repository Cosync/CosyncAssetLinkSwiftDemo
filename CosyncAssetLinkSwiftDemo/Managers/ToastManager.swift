//
//  ToastManager.swift
//  CosyncAssetLinkSwiftDemo
//
//  Created by Tola Voeung on 27/12/23.
//

import Foundation




struct ToastDataModel: Codable {
    var id = UUID()
    var title: String = ""
    var message: String = ""
    var data: String? = ""
    var type: String = "error"
    var createdAt:Date? = Date()
}



var TM = ToastManager.shared
 
class ToastManager: ObservableObject {
 
    static let shared = ToastManager()
    @Published var notification: ToastDataModel = ToastDataModel()
    @Published var notificationList = [ToastDataModel]()
    
    init() { 
    }
    
    func send (title:String, message:String, data:String = "", type:String = "error"){
        notification = ToastDataModel(title: title, message: message, data: data, type: type)
        notificationList.append(notification)
        
    }
    
    func dismiss(toast:ToastDataModel){
        notificationList =  notificationList.filter{ $0.id != toast.id}
        
    }
}
