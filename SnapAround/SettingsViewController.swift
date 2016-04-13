//
//  SettingsViewController.swift
//  SnapAround
//
//  Created by Mehdi Kitane on 29/04/2015.
//  Copyright (c) 2015 Mehdi Kitane. All rights reserved.
//

import UIKit

class SettingsViewController: UITableViewController {
    
    
    @IBOutlet weak var userPicture: UIImageView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var userName: UILabel!
    
    enum SettingsRowName: Int {
        case Share
        case Terms
        case Logout
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let access = FBSDKAccessToken.currentAccessToken().tokenString
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        APIUsers.getMe(access, completion: { (theuser, error) -> Void in
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            if let user = theuser {
                self.userName.text = user.name
                if let picImage = user.picImage {
                    self.setProfilePictureWithImage(picImage)
                } else {
                    if let pic = user.pic {
                        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
                        APIHandler.downloadImageWithURL(pic, completion: { (succeeded, image) -> Void in
                            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                            if let image = image {
                                self.setProfilePictureWithImage(image)
                            }
                        })
                    }
                }
            }
        })
        
    }
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        // Menu fixed position
        snapLog(scrollView.contentOffset.y)
        if (scrollView.contentOffset.y <= -64) {
            var fixedFrame = self.headerView.frame;
            fixedFrame.origin.y = 64 + scrollView.contentOffset.y;
            self.headerView.frame = fixedFrame;
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return 3
    }
    
    @IBAction func dismissSettingsView(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("settingCell", forIndexPath: indexPath) as! SettingCell
        
        if indexPath.row == SettingsRowName.Share.rawValue {
            cell.settingNameLabel.text = NSLocalizedString("SHARE_FRIENDS",comment:"share")
            cell.settingDescriptionLabel.text = NSLocalizedString("SHARE_MESSAGE",comment:"spread the word")
        }
        else if indexPath.row == SettingsRowName.Logout.rawValue {
            cell.settingNameLabel.text = NSLocalizedString("LOGOUT",comment:"logout")
            cell.settingDescriptionLabel.text = NSLocalizedString("LOGOUT_MESSAGE",comment:"goodbye")
        }
        else if indexPath.row == SettingsRowName.Terms.rawValue {
            cell.settingNameLabel.text = NSLocalizedString("TERMS",comment:"Terms of Service")
            cell.settingDescriptionLabel.text = NSLocalizedString("TERMS_MESSAGE",comment:"")
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == SettingsRowName.Share.rawValue {
            let string = NSLocalizedString("DISCOVER",comment:"discover around you");
            let URL = NSURL(string: "http://snaparound.herokuapp.com")
            
            let activityViewController = UIActivityViewController(activityItems: [string, URL!], applicationActivities: nil)
            self.navigationController?.presentViewController(activityViewController, animated: true, completion: nil)
        }
        else if indexPath.row == SettingsRowName.Logout.rawValue {
            let fbLoginManager = FBSDKLoginManager()
            fbLoginManager.logOut()
            self.performSegueWithIdentifier("loginSegue", sender: nil)
        } else if indexPath.row == SettingsRowName.Terms.rawValue {
            UIApplication.sharedApplication().openURL(NSURL(string : urlTerms)!)
        }
    }
    
    
    func setProfilePictureWithImage(picture: UIImage) {
        self.userPicture.image = picture
        self.userPicture.layer.cornerRadius = self.userPicture.frame.size.height/2
        self.userPicture.layer.masksToBounds = true
        self.userPicture.layer.borderColor = UIColor(rgba: "#cecece").CGColor
        self.userPicture.layer.borderWidth = 0.5
    }
    
    
    //--Notifications handler
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(SettingsViewController.didReceiveNotification(_:)), name: "SnapRemoteNotification", object: nil)
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
    }
}
