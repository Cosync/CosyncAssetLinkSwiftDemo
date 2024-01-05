//
//  RealmManager.swift
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
import RealmSwift
import CosyncAssetLinkSwift


// Covenience call for singleton
var RM = RealmManager.shared

class RealmManager {
    
    static let shared = RealmManager()
    let app = RealmSwift.App(id: Constants.REALM_APP_ID)
    var user: User? {
        return self.app.currentUser
    }
    var realm: Realm?
    
    @MainActor
    func login(email: String, password:String) async throws -> Void {
        
        do{
            let user = try await app.login(credentials: Credentials.emailPassword(email: email, password: password))
            print("Successfully logged in userId: \(user.id)")
            
            try await initRealm()
            
        }
        catch{
            print(" log in error: \(error)")
            throw(error)
        }
    }
    
    @MainActor
    func signup(email:String, password:String) async throws -> Void{
        
        let client = app.emailPasswordAuth
        
        do {
            try await client.registerUser(email: email, password: password)
            // Registering just registers. You can now log in.
            print("Successfully registered user.")
            
            let user = try await app.login(credentials: Credentials.emailPassword(email: email, password: password))
            print("Successfully logged in userId: \(user.id)")
            
            try await initRealm()
            
            
        } catch {
            print("Failed to register: \(error.localizedDescription)")
            throw(error)
        }
        
    }
    
    @MainActor
    func logout(onCompletion completion: @escaping (Error?) -> Void) {
        
        if let user = app.currentUser {

            // Just log out - Realm does all of the cleanup
            user.logOut(completion: { (error) in
                
                guard error == nil else {
                    completion(error)
                    return
                }
                
                completion(nil)
            })
        }
    }
    
    
    
    @MainActor
    func initRealm() async throws -> Void {
        // Initialize realm and default subscriptions
        do {
            
            var config = self.user!.flexibleSyncConfiguration()
            config.objectTypes = [CosyncAsset.self]
            realm = try await Realm(configuration: config, downloadBeforeOpen: .always)
            
            let subscriptions = realm!.subscriptions
            let foundCosyncAsset = subscriptions.first(named: "cosyncAsset")
            try await subscriptions.update({
                if (foundCosyncAsset == nil) {
                    subscriptions.append(
                        QuerySubscription<CosyncAsset>(name: "cosyncAsset")
                    )
                }
            })
            
            print("initRealm user id \(self.app.currentUser?.id)")
            
            CSUploadManager.shared.configure(app: self.app, realm: self.realm!)
            CSAssetManager.shared.configure(app: self.app, realm: self.realm!)
        }
        catch {
            
            print("Unable to intialize realm and subscriptions \(error)")
            
            throw(error)
           
        }
        
    } 
    
}
