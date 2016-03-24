//
//  Posts.swift
//  SnapAround
//
//  Created by Mehdi Kitane on 04/05/2015.
//  Copyright (c) 2015 Mehdi Kitane. All rights reserved.
//

import Foundation

class Posts {
    var visible : [Post]!
    var hidden : [PostAggregate]!
    var myPosts : [Post]!
    
    init(json: NSDictionary){
        let dicVisible = json["visible"] as! NSArray
        let dicHidden = json["hidden"] as! NSArray
        let dicMyPosts = json["myPosts"] as! NSArray
        
        self.visible = []
        self.hidden = []
        self.myPosts = []
        
        for visibleJSON in dicVisible {
            let visible = Post(json: visibleJSON as! NSDictionary)
            self.visible.append(visible)
        }
        for hiddenJSON in dicHidden {
            let visible = PostAggregate(json: hiddenJSON as! NSDictionary)
            self.hidden.append(visible)
        }
        for myPostsJSON in dicMyPosts {
            let myPost = Post(json: myPostsJSON as! NSDictionary)
            self.myPosts.append(myPost)
        }
    }
    
    
}