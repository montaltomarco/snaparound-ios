//
//  LoginViewController.swift
//  SnapAround
//
//  Created by Mehdi Kitane on 28/04/2015.
//  Copyright (c) 2015 Mehdi Kitane. All rights reserved.
//

import Foundation
import CoreLocation

class LoginViewController: UIViewController, CLLocationManagerDelegate {
    
    let screenWidth = UIScreen.mainScreen().bounds.size.width
    let screenHeight = UIScreen.mainScreen().bounds.size.height
    
    //var locationHandler = LocationHandler()
    
    @IBOutlet weak var appLogo: UIImageView!
    var animationAppLogo: UIImageView!
    @IBOutlet weak var overlayView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        animationAppLogo = UIImageView(image: UIImage(named: "app-logo")!)
        var appLogoFrame = animationAppLogo.frame
        appLogoFrame.origin.x = (screenWidth/2)-(appLogoFrame.size.width/2)
        appLogoFrame.origin.y = (screenHeight/2)-(appLogoFrame.size.height/2)
        animationAppLogo.frame = appLogoFrame
        
        overlayView.addSubview(animationAppLogo)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        animateLogo()
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    func animateLogo() {
        UIView.animateWithDuration(0.5, delay: 0.8, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            
            // Logo transition
            var logoFrame = self.animationAppLogo.frame
            let factor = CGFloat(1.5)
            let wdiff: CGFloat = (logoFrame.size.width-(logoFrame.size.width/factor))/2
            
            logoFrame.size.height /= factor
            logoFrame.size.width /= factor
            logoFrame.origin.x += wdiff
            logoFrame.origin.y = self.appLogo.frame.origin.y
            
            self.animationAppLogo.frame = logoFrame
            
            })  { (success) -> Void in
                
                if let overlayView = self.overlayView {
                    UIView.animateWithDuration(0.4, animations: {
                        overlayView.layer.opacity = 0
                        }, completion: { (value: Bool) in
                            self.overlayView.removeFromSuperview()
                        
                            //self.locationHandler = LocationHandler()
                            //self.locationHandler.startLocationTracker()
                    })
                }
        }
    }
    
    @IBAction func clickedTerms(sender: AnyObject) {
        UIApplication.sharedApplication().openURL(NSURL(string : urlTerms)!)
    }
    
    @IBAction func fbLoginAction(sender: UIButton) {
        let fbLoginManager = FBSDKLoginManager()
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        fbLoginManager.logInWithReadPermissions(["public_profile", "email", "user_friends"], fromViewController: self, handler: {(result: FBSDKLoginManagerLoginResult!, error: NSError!) -> Void in
            
            if (error != nil) {
                UIAlertView(title: NSLocalizedString("OOPS",comment:"oops"), message: NSLocalizedString("AUTHENTICATION_FAILURE",comment:"authentication failure"), delegate: nil, cancelButtonTitle: "Ok").show()
                return
            }
            
            if result.isCancelled {
                UIAlertView(title: NSLocalizedString("OOPS",comment:"oops"), message: NSLocalizedString("AUTHENTICATION_FAILURE",comment:"authentication failure"), delegate: nil, cancelButtonTitle: "Ok").show()
                return
            }
            
            if result.grantedPermissions.contains("email") {
                //Mixpanel.sharedInstance().track("successfully registered")
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                let access = FBSDKAccessToken.currentAccessToken().tokenString
                let deviceToken = NSUserDefaults.standardUserDefaults().objectForKey("SnapDeviceToken") as? String
                if let deviceToken = deviceToken {
                    APIUsers.registerForNotifications(access, deviceToken: deviceToken) { (error) -> Void in
                        self.performSegueWithIdentifier("appSegue", sender: nil)
                    }
                } else {
                    self.performSegueWithIdentifier("appSegue", sender: nil)
                }
            }
            
        })
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        snapLog("yo")
        snapLog(status)
    }
    
}