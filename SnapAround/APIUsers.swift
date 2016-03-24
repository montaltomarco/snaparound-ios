//
//  APIUsers.swift
//  SnapAround
//
//  Created by Mehdi Kitane on 04/05/2015.
//  Copyright (c) 2015 Mehdi Kitane. All rights reserved.
//

import Foundation

class APIUsers {
    
    static var me : User?  
    
    static func getMe(authentication:String, completion: (theuser:User?, error : NSError?) -> Void) {
        
        if APIUsers.me == nil {
            snapLog("requesting User Me");
            APIHandler.sendRequest(.GET, endpoint: "v1.0/me", authentication: authentication, queryParameters: nil)
                { (json, statusCode, error) -> Void in
                    
                    if error == nil {
                        snapLog("got me!");
                        if let dictionary = json as? NSDictionary {
                            APIUsers.me = User(json: dictionary)
                        
                            if let picPath = APIUsers.me?.pic {
                                if APIUsers.me?.picImage == nil {
                                    APIHandler.downloadImageWithURL(picPath, completion: { (succeeded, image) -> Void in
                                        if let image = image {
                                            APIUsers.me?.picImage = image
                                        }
                                    })
                                }
                            }
                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                completion(theuser: APIUsers.me, error: error)
                            })
                        } else {
                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                completion(theuser: nil, error: error)
                            })
                        }
                    }
            }
        } else {
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                completion(theuser: APIUsers.me, error: nil)
            })
        }
    }
    
    static func getFriendsOn(authentication:String, completion: (array: Array<User>?, error : NSError?) -> Void) {
        APIHandler.sendRequest(.GET, endpoint: "v1.0/friends/on", authentication: authentication, queryParameters: nil)
            { (json, statusCode, error) -> Void in
                
                if let appFriends = json as? NSArray {
                    var friendsArray : Array<User> = []
                    for friend in appFriends {
                        let user = User(json: friend as! NSDictionary)
                        friendsArray.append( user )
                    }
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        completion(array: friendsArray, error: error)
                    })
                } else {
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        completion(array: nil, error: error)
                    })
                }
                
                
        }
    }
    
    static func getFriendsOff(authentication:String, completion: (array: Array<User>?, error : NSError?) -> Void) {
        APIHandler.sendRequest(.GET, endpoint: "v1.0/friends/off", authentication: authentication, queryParameters: nil)
            { (json, statusCode, error) -> Void in
                
                if let appFriends = json as? NSArray {
                    var friendsArray : Array<User> = []
                    for friend in appFriends {
                        let user = User(json: friend as! NSDictionary)
                        friendsArray.append( user )
                    }
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        completion(array: friendsArray, error: error)
                    })
                } else {
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        completion(array: nil, error: error)
                    })
                }
        }
        
    }
    
    static func registerForNotifications(authentication:String, deviceToken: String, completion: (error : NSError?) -> Void) {
        
        let params = ["iosDeviceId" : deviceToken]
        
        APIHandler.sendRequest(.POST, endpoint: "v1.0/notifications/apnDeviceId", authentication: authentication, queryParameters: params)
            { (json, statusCode, error) -> Void in
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    completion(error: error)
                })
        }
    }
    
}