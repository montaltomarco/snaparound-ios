//
//  User.swift
//  SnapAround
//
//  Created by Mehdi Kitane on 04/05/2015.
//  Copyright (c) 2015 Mehdi Kitane. All rights reserved.
//

import Foundation

class User {
    var fbUserId : String!
    var name : String!
    var pic : String?
    
    var picImage : UIImage?
    
    init(json: NSDictionary){
        self.fbUserId = json["fbUserId"] as! String
        self.name = json["name"] as! String
        self.pic = json["pic"] as? String
    }
    init(fbUserId:String, name:String, pic:String?) {
        self.fbUserId = fbUserId
        self.name = name
        self.pic = pic
    }
}