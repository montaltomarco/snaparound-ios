//
//  APIHandler.swift
//  SnapAround
//
//  Created by Mehdi Kitane on 04/05/2015.
//  Copyright (c) 2015 Mehdi Kitane. All rights reserved.
//

import Foundation
import UIKit

enum HTTPMethod : String {
    case GET = "GET"
    case POST = "POST"
    case DELETE = "DELETE"
    case PUT = "PUT"
}

class APIHandler {
    // ONLY FOR MARCO'S LOCAL TESTS static var baseURL : String! = "http://192.168.0.18:3000/"
    static var baseURL : String! = "https://snaparound-app.herokuapp.com/"
    
    static func sendRequest(method: HTTPMethod, endpoint: String, authentication:String!, queryParameters : Dictionary<String,String>?,
        completion: (json: AnyObject?, statusCode:Int?, error : NSError?) -> Void ) {
            
            let request : NSMutableURLRequest = NSMutableURLRequest()
            
            var stringURL = APIHandler.baseURL+endpoint
            
            if let parameters = queryParameters {
                for (index, (key,value)) in parameters.enumerate() {
                    let encodedKey = key.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
                    let encodedValue = value.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
                    if index == 0 {
                        stringURL = stringURL + "?" + encodedKey! + "=" + encodedValue!
                    } else {
                        stringURL = stringURL + "&" + encodedKey! + "=" + encodedValue!
                    }
                }
            }
            
            request.URL = NSURL(string: stringURL)
            request.addValue("FBShort " + authentication, forHTTPHeaderField: "Authentication")
            request.HTTPMethod = method.rawValue
            
            
            NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue()) {
                    (response:NSURLResponse?, data: NSData?, error: NSError?) -> Void in
                let statusCode = (response as? NSHTTPURLResponse)?.statusCode

                if let error = error {
                    completion(json: nil, statusCode: nil, error: error)
                } else {
                    do {
                        let jsonResult = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers)
                        completion(json: jsonResult, statusCode:statusCode!, error: nil)
                    } catch let errJSON as NSError {
                        completion(json: nil, statusCode:statusCode!, error: errJSON)
                    }
                }
                
            }
    }
    
    static func uploadImage(endpoint endpoint: String, authentication:String!, image:UIImage, message:String?, sharedWith : Set<String>?,
        queryParameters : Dictionary<String,String>?,
        completion: (json: AnyObject?, statusCode:Int?, error : NSError?) -> Void) {
            
            
            let request = NSMutableURLRequest()
            
            var stringURL = APIHandler.baseURL+endpoint
            
            if let parameters = queryParameters {
                for (index, (key,value)) in parameters.enumerate() {
                    if index == 0 {
                        stringURL = stringURL + "?" + key + "=" + value
                    } else {
                        stringURL = stringURL + "&" + key + "=" + value
                    }
                }
            }
            
            request.URL = NSURL(string: stringURL)
            request.addValue("FBShort " + authentication, forHTTPHeaderField: "Authentication")
            request.HTTPMethod = HTTPMethod.POST.rawValue
            
            
            
            
            let boundary = "---------------------------3402388781793354232971591579"
            let contentType = String(format:"multipart/form-data; boundary=%@",boundary)
            request.addValue(contentType, forHTTPHeaderField: "Content-Type")
            
            let body : NSMutableData = NSMutableData()
            
            if let msg = message {
                body.appendData( String(format: "\r\n--%@\r\n",boundary).dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)!)
                body.appendData( "Content-Disposition: form-data; name=\"msg\"\r\n".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)!)
                body.appendData( "\r\n".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)!)
                body.appendData( msg.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)!)
            }
            if let sharedWith = sharedWith {
                if sharedWith.count > 0 {
                    body.appendData( String(format: "\r\n--%@\r\n",boundary).dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)!)
                    body.appendData( "Content-Disposition: form-data; name=\"sharedWith\"\r\n".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)!)
                    body.appendData( "\r\n".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)!)
                    
                    
                    let str : NSMutableString = ""
                    for element in sharedWith {
                        str.appendString( String(format: "%@,", element) )
                    }
                    str.deleteCharactersInRange(NSMakeRange(str.length-1, 1))
                    body.appendData( str.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)! )
                }
            }
            
            let imageData = UIImagePNGRepresentation(image)
            if let imageData = imageData {
                body.appendData( String(format: "\r\n--%@\r\n",boundary).dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)!)
                body.appendData( String(format: "Content-Disposition: form-data; name=\"pic\"; filename=\"%@.png\"\r\n", "Uploaded_file").dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)!)
                body.appendData( String(format: "Content-Type: image/png\r\n\r\n").dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)!)
                body.appendData( NSData(data: imageData) )
                body.appendData( String(format:"\r\n--%@--\r\n",boundary).dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)!)
            }
            
            
            request.HTTPBody = body
            
            NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue()) {
                (response:NSURLResponse?, data: NSData?, error: NSError?) -> Void in
                let statusCode = (response as? NSHTTPURLResponse)?.statusCode
                
                if let error = error {
                    completion(json: nil, statusCode: nil, error: error)
                } else {
                    do {
                        let jsonResult = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers)
                        completion(json: jsonResult, statusCode:statusCode!, error: nil)
                    } catch let errJSON as NSError {
                        completion(json: nil, statusCode:statusCode!, error: errJSON)
                    }
                }
                
            }
    }
    
    static func compressForUpload(original : UIImage, width : CGFloat) -> UIImage{
        // Calculate new size given scale factor.
        
        let originalSize = original.size
        let scale = width/originalSize.width
        let newSize = CGSizeMake(originalSize.width*scale, originalSize.height*scale)
        
        // Scale the original image to match the new size.
        UIGraphicsBeginImageContext(newSize);
        original.drawInRect(CGRectMake(0, 0, newSize.width, newSize.height))
        
        let compressedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext();
        
        return compressedImage;
    }
    
    static func downloadImageWithURL(urlPath:String, completion: (succeeded:Bool, image : UIImage?) -> Void){
        let url = NSURL(string: urlPath)
        let request = NSMutableURLRequest(URL: url!)
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue()) {
            (response:NSURLResponse?, data: NSData?, error: NSError?) -> Void in
            
            if let _ = error {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    completion(succeeded: false, image: nil)
                })
            } else {
                if let data = data {
                    let image = UIImage(data: data)
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        completion(succeeded: true, image: image)
                    })
                } else {
                    completion(succeeded: false, image: nil)
                }
            }
            
        }

    }
}