//
//  LaunchViewController.swift
//  SnapAround
//
//  Created by Karim Benhmida on 03/05/2015.
//  Copyright (c) 2015 Mehdi Kitane. All rights reserved.
//

import UIKit

class LaunchViewController: UIViewController {
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if (FBSDKAccessToken.currentAccessToken() == nil) {
            self.performSegueWithIdentifier("loginSegue", sender: nil)
        }
        else {
            APIUsers.getMe(FBSDKAccessToken.currentAccessToken().tokenString, completion: { (theuser, error) -> Void in })
            self.performSegueWithIdentifier("appSegue", sender: nil)
        }
        
    }
}
