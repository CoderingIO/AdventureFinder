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
    
    
    
    let rating:Int!
    let name:String!
    let addedByUser:String!
    let address: String!
    let ref: Firebase?
    
    // move key to end. Dont have to include when calling
    init(name:String, addedByUser:String, rating:Int, address:String) {
        self.rating = rating
        self.name = name
        self.address = address
        self.addedByUser = addedByUser
        self.ref = nil
    }
    
    init(snapshot:FDataSnapshot) {
        rating = snapshot.value["rating"] as? Int
        name = snapshot.value["name"] as? String
        address = snapshot.value["address"] as? String
        addedByUser = snapshot.value["addedByUser"] as? String
        ref = snapshot.ref
    }
    
    func toAnyObject() -> AnyObject {
        return [
            "name": name,
            "address": address,
            "addedByUser": addedByUser,
            "rating": rating
        ]
    }
    
}