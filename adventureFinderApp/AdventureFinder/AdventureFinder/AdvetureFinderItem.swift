//
//  AdvetureFinderItem.swift
//  AdventureFinder
//
//  Created by Wayne Bangert on 3/23/16.
//  Copyright © 2016 Wayne Bangert. All rights reserved.
//

import Foundation
import Firebase


struct AdventureItem {
    
    let key:String!
    let name:String!
    let addedByUser:String!
    let ref: Firebase?
    
    init(name:String, addedByUser:String, key:String = "") {
        self.key = key
        self.name = name
        self.addedByUser = addedByUser
        self.ref = nil
    }
    
    init(snapshot:FDataSnapshot) {
        key = snapshot.key
        name = snapshot.value["name"] as! String!
        addedByUser = snapshot.value["addedByUser"] as! String
        ref = snapshot.ref
    }
    
    func toAnyObject() -> AnyObject {
        return [
            "name": name,
            "addedByUser": addedByUser,
        ]
    }
    
}