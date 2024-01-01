//
//  ToastManager.swift
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
        DispatchQueue.main.async {
            
            self.notification = ToastDataModel(title: title, message: message, data: data, type: type)
            self.notificationList.append(self.notification)
        }
        
    }
    
    func dismiss(toast:ToastDataModel){
        notificationList =  notificationList.filter{ $0.id != toast.id}
        
    }
}
