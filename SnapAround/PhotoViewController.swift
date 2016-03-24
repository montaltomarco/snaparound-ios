//
//  PhotoViewController.swift
//  SnapAround
//
//  Created by Mehdi Kitane on 30/04/2015.
//  Copyright (c) 2015 Mehdi Kitane. All rights reserved.
//

import UIKit

class PhotoViewController: UIViewController {
    
    var imageTaken : UIImage!
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.imageView.image = imageTaken
        let locationHandler = LocationHandler()
        locationHandler.startLocationTracker()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true;
    }
    
    @IBAction func clickedBackButton(sender: AnyObject) {
        self.dismissViewControllerAnimated(false, completion: nil)
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "shareSegue" {
            if let navigation = segue.destinationViewController as? UINavigationController {
                if let destinationVC = navigation.topViewController as? ShareTableViewController{
                    destinationVC.imageTaken = self.imageTaken
                }
            }
        }
    }
    
    
    
    //--Notifications handler
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("didReceiveNotification:"), name: "SnapRemoteNotification", object: nil)
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
                let VC : UIViewController? = self.presentingViewController?.presentingViewController
                
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
    }
}
