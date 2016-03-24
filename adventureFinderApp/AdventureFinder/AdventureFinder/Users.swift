//
//  Users.swift
//  AdventureFinder
//
//  Created by Wayne Bangert on 3/23/16.
//  Copyright © 2016 Wayne Bangert. All rights reserved.
//

import Foundation
import Firebase

struct User {
    let uid:String
    let email:String
    
    init(authData: FAuthData) {
        // provides unique user ID
        uid = authData.uid
        email = authData.providerData["email"] as! String
    }
    
    init(uid:String, email:String) {
        self.uid = uid
        self.email = email
    }
}
