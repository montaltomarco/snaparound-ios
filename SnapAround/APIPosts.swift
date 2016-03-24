//
//  APIPosts.swift
//  SnapAround
//
//  Created by Mehdi Kitane on 04/05/2015.
//  Copyright (c) 2015 Mehdi Kitane. All rights reserved.
//

import Foundation

class APIPosts {
    
    
    static func getPosts(authentication : String, lat: Double, lon: Double, completion: (posts: Posts?, error : NSError?) -> Void) {
        
        snapLog("requesting posts")
        
        let params = ["lat" : String(format:"%f", lat), "lon" : String(format:"%f", lon)]
        
        APIHandler.sendRequest(.GET, endpoint: "v1.0/posts", authentication: authentication, queryParameters: params)
            { (json, statusCode, error) -> Void in
                
                if let dictionary = json as? NSDictionary {
                    let posts = Posts(json: dictionary)
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        snapLog("receiving posts")
                        completion(posts:posts, error:error)
                    })
                } else {
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        completion(posts:nil, error:error)
                    })
                }
        }
    }
    
    static func publishPost(authentication : String, lat: Double, lon: Double, msg : String?, image : UIImage, sharedWith : Set<String>?, expires : String?, completion: (post: Post?, error : NSError?) -> Void) {
        
        var params : Dictionary<String,String>!
        if let expires = expires {
            params  = ["lat" : String(format:"%f", lat), "lon" : String(format:"%f", lon), "expires" : expires]
        } else {
            params  = ["lat" : String(format:"%f", lat), "lon" : String(format:"%f", lon)]
        }
        
        APIHandler.uploadImage(endpoint: "v1.0/posts", authentication: authentication, image: image, message: msg, sharedWith: sharedWith, queryParameters: params)
            { (json, statusCode, error) -> Void in
                if let dictionary = json as? NSDictionary {
                    let post = Post(json: dictionary)
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        completion(post: post, error: error)
                    })
                } else {
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        completion(post: nil, error: error)
                    })
                }
        }
    }
    
    
    static func getCollection(authentication : String, completion: (array: Array<Post>?, error : NSError?) -> Void) {
        APIHandler.sendRequest(.GET, endpoint: "v1.0/collection", authentication: authentication, queryParameters: nil)
            { (json, statusCode, error) -> Void in
                
                if let NSPosts = json as? NSArray {
                    var postsArray : Array<Post> = []
                    for post in NSPosts {
                        let post = Post(json: post as! NSDictionary)
                        postsArray.append( post )
                    }
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        completion(array: postsArray, error: error)
                    })
                } else {
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        completion(array: nil, error: error)
                    })
                }
                
        }
    }
    
    
    
    static func removePostFromCollection(authentication: String, postID: Int, completion: (error : NSError?) -> Void) {
        
        let url = "v1.0/collection/" + String(postID)
        APIHandler.sendRequest(.DELETE, endpoint: url, authentication: authentication, queryParameters: nil)
            { (json, statusCode, error) -> Void in
                
                if statusCode != 204 {
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        completion(error:error)
                    })
                } else {
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        completion(error: nil)
                    })
                }
        }
    }
    
    static func addPostToCollection(authentication: String, postID: Int, lat: Double, lon: Double, completion: (post: Post?, error : NSError?) -> Void) {
        
        let url = "v1.0/collection/" + String(postID)
        let params = ["lat" : String(format:"%f", lat), "lon" : String(format:"%f", lon)]
        APIHandler.sendRequest(.POST, endpoint: url, authentication: authentication, queryParameters: params)
            { (json, statusCode, error) -> Void in
                
                if let dictionary = json as? NSDictionary {
                    let post = Post(json: dictionary)
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        completion(post: post, error: error)
                    })
                } else {
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        completion(post: nil, error: error)
                    })
                }
        }
    }
    
}