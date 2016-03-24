//
//  PostAggregate.swift
//  SnapAround
//
//  Created by Mehdi Kitane on 04/05/2015.
//  Copyright (c) 2015 Mehdi Kitane. All rights reserved.
//

import Foundation


class PostAggregate {
    var count : Int!
    var user : User?
    var latitude : Float!
    var longitude : Float!
    
    init(json: NSDictionary){
        let dicUser = json["user"] as? NSDictionary
        
        if let dicUser = dicUser {
            self.user = User(json:dicUser)
        }
        
        self.count = json["count"] as! Int
        self.latitude = json["lat"] as! Float
        self.longitude = json["lon"] as! Float
    }
}
