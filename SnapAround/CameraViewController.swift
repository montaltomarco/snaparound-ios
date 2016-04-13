//
//  CameraViewController.swift
//  SnapAround
//
//  Created by Mehdi Kitane on 29/04/2015.
//  Copyright (c) 2015 Mehdi Kitane. All rights reserved.
//

import UIKit

class CameraViewController: UIViewController {
    
    var capture : CaptureObject!
    var imageTaken : UIImage!
    var isBackCamera : Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Mixpanel.sharedInstance().track("opened take picture")
        capture = CaptureObject(inView: self.view, atlayerIndex: 0)
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true;
    }
    
    
    @IBAction func touchedFlash(sender: AnyObject) {
        if(capture.flashTurnedOn()) {
            capture.turnOffFlash()
        } else {
            capture.turnOnFlash()
        }
    }
    
    @IBAction func touchedChangeCamera(sender: AnyObject) {
        capture.switchCameraTapped()
    }
    
    @IBAction func touchedTakePicture(sender: AnyObject) {
        capture.takePicture(completionHandler : { (image : UIImage) -> Void in
            if(!self.capture.isBackCamera()) {
                //revert image
                if let cgImage = image.CGImage {
                    self.imageTaken = UIImage(CGImage: cgImage, scale: image.scale, orientation: UIImageOrientation.LeftMirrored)
                }
            } else {
                self.imageTaken = image
            }
            //Mixpanel.sharedInstance().track("took picture")
            self.performSegueWithIdentifier("showTakenPicture", sender: self)
        })
    }
    
    @IBAction func touchedBack(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func tappedForFocus(sender: AnyObject) {
        let touch : UITapGestureRecognizer = sender as! UITapGestureRecognizer
        let touchPoint : CGPoint = touch.locationInView(self.view)
        capture.focusAtPoint(touchPoint)
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "showTakenPicture" {
            if let destinationVC = segue.destinationViewController as? PhotoViewController{
                destinationVC.imageTaken = imageTaken
            }
        }
    }
    
    
    
    //--Notifications handler
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(CameraViewController.didReceiveNotification(_:)), name: "SnapRemoteNotification", object: nil)
    }
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func didReceiveNotification(notification : NSNotification) {
        let userInfo = notification.userInfo
        
        if let userInfo = userInfo {
            if (self.isViewLoaded() && self.view.window != nil ) {
                let state = NSUserDefaults.standardUserDefaults().objectForKey("SnapNotificationState")  as? Int
                let VC : UIViewController? = self
                
                if state == UIApplicationState.Active.rawValue {
                    //if active show notif
                    CustomNotification(userInfo: userInfo, popUpViewController: VC).show()
                }else{
                    VC?.dismissViewControllerAnimated(true, completion: { () -> Void in
                        NSNotificationCenter.defaultCenter().postNotificationName("SnapRemoteNotification", object: nil, userInfo: userInfo)
                    })
                }
            }
        }
    }}
