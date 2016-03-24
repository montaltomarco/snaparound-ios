//
//  Post.swift
//  SnapAround
//
//  Created by Mehdi Kitane on 04/05/2015.
//  Copyright (c) 2015 Mehdi Kitane. All rights reserved.
//

import Foundation

class Post {
    var postId : Int!
    var user : User!
    var latitude : Float!
    var longitude : Float!
    var msg : String?
    var pic : String!
    var sharedWith : Array<String>?
    var expires : String?
    var createdAt : String?
    
    var picImage : UIImage?
    
    init(json: NSDictionary){
        let dicUser = json["user"] as! NSDictionary
        
        self.postId = json["postId"] as! Int
        self.user = User(json:dicUser)
        self.latitude = json["lat"] as! Float
        self.longitude = json["lon"] as! Float
        
        self.msg = json["msg"] as? String
        self.pic = json["pic"] as! String
        self.expires = json["expires"] as? String
        self.createdAt = json["createdAt"] as? String
        
        let arrayShared = json["sharedwith"] as? NSArray
        self.sharedWith = arrayShared as? [String]
    }
}