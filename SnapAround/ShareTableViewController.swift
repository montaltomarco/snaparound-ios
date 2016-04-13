//
//  ShareTableViewController.swift
//  SnapAround
//
//  Created by Mehdi Kitane on 05/05/2015.
//  Copyright (c) 2015 Mehdi Kitane. All rights reserved.
//

import UIKit

class ShareTableViewController: UITableViewController, PublicTableViewCellDelegate, FriendTableViewCellDelegate {
    
    var imageTaken : UIImage!
    var array = ["legendCell", "expiresCell", "publicCell"]
    var isPublic : Bool = true
    var friends : Array<User>! = []
    var addedFriends : Set<String>! = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Mixpanel.sharedInstance().track("opened share")

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ShareTableViewController.hideKeyboard))
        self.tableView.addGestureRecognizer(gestureRecognizer);
        let gestureRecognizer2 = UITapGestureRecognizer(target: self, action: #selector(ShareTableViewController.hideKeyboard))
        self.navigationController?.navigationBar.addGestureRecognizer(gestureRecognizer2)
        
        
        let access = FBSDKAccessToken.currentAccessToken().tokenString
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        APIUsers.getFriendsOn(access, completion: { (array, error) -> Void in
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            if let array = array {
                self.friends = array
            }
            self.tableView.reloadData()
        })
    }
    
    func hideKeyboard() {
        let cell = self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) as! LegendTableViewCell
        cell.textView.resignFirstResponder()
    }
    func clickSwitch(on: Bool) {
        self.isPublic = on
        self.tableView.reloadData()
    }
    func friendAdded(friend: User) {
        self.addedFriends.insert(friend.fbUserId)
    }
    func friendRemoved(friend: User) {
        self.addedFriends.remove(friend.fbUserId)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func clickedValidate(sender: AnyObject) {
        let textCell = self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) as! LegendTableViewCell
        textCell.textView.resignFirstResponder()
        
        if isPublic == false && self.addedFriends.count <= 0 {
            UIAlertView(title: NSLocalizedString("OOPS",comment:"oops"), message: NSLocalizedString("SHARE_FRIENDS_FAILURE",comment:"You should select at least one friend or post this image as public"), delegate: nil, cancelButtonTitle: "Ok").show()
            return
        }
        
        let hud = MBProgressHUD.showHUDAddedTo(UIApplication.sharedApplication().delegate?.window!, animated: true)
        
        
        let expiresCell = self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 1, inSection: 0)) as! ExpiresTableViewCell
        
        
        let access = FBSDKAccessToken.currentAccessToken().tokenString
        let image = APIHandler.compressForUpload(self.imageTaken, width: 500)
        let longitude = NSUserDefaults.standardUserDefaults().objectForKey("SnapLongitude")  as? Double
        let latitude = NSUserDefaults.standardUserDefaults().objectForKey("SnapLatitude")  as? Double
        
        
        var msg :String? = textCell.textView.text
        if let mesg = msg {
            if mesg == textCell.placeHolder || mesg.characters.count == 0 {
                msg = nil
            }
        }
        
        var stringDate : String? = nil
        if let interval = expiresCell.getExpires() {
            let date = NSDate().dateByAddingTimeInterval(interval)
            let dateFormatter = NSDateFormatter()
            //dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
            stringDate = dateFormatter.stringFromDate(date)
            stringDate = stringDate?.stringByReplacingOccurrencesOfString("+", withString: "%2B", options: NSStringCompareOptions.LiteralSearch, range: nil)
        }
        

        
        
        //Mixpanel.sharedInstance().track("uploaded picture", properties: ["expires" : expiresCell.getExpiresString() , "nbfriends" : self.addedFriends.count])

        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        APIPosts.publishPost(access, lat: latitude!, lon: longitude!, msg: msg, image: image, sharedWith: addedFriends, expires: stringDate) { (post, error) -> Void in
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            hud.hide(true)
            self.presentingViewController?.presentingViewController?.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    @IBAction func clickedBack(sender: AnyObject) {
        self.dismissViewControllerAnimated(false, completion: nil)
    }
    
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1 {
            return 50
        }
        return 0
    }
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 1 && !self.isPublic {
            let screenSize = UIScreen.mainScreen().bounds
            let view = UILabel(frame: CGRectMake(0, 0, screenSize.width, 50))
            view.text = NSLocalizedString("SHARE_WITH",comment:"Share with")
            view.textAlignment = NSTextAlignment.Center
            view.backgroundColor = UIColor(rgba: "#E0D4F3")
            return view
        }
        return nil
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 0 && indexPath.section == 0 {
            return 120
        } else {
            return UITableViewAutomaticDimension
        }
        
    }
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        if isPublic {
            return 1
        }
        return 2
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        if section == 0 {
            return array.count
        }
        if section == 1 {
            return friends.count
        }
        return 3
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell!
        
        if indexPath.section == 0 {
            cell = tableView.dequeueReusableCellWithIdentifier(array[indexPath.row], forIndexPath: indexPath) 
            if indexPath.row == 2 {
                if let cell = (cell as? PublicTableViewCell) {
                    cell.delegate = self
                }
            }
        } else if indexPath.section == 1 {
            cell = tableView.dequeueReusableCellWithIdentifier("friendCell", forIndexPath: indexPath) 
            if let cell = (cell as? FriendTableViewCell) {
                cell.updateCell(friends[indexPath.row])
                cell.delegate = self
            }
        } else {
            cell = tableView.dequeueReusableCellWithIdentifier("friendCell", forIndexPath: indexPath) 
        }
        
        // Configure the cell...
        
        return cell
    }
    
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return NO if you do not want the specified item to be editable.
    return true
    }
    */
    
    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    if editingStyle == .Delete {
    // Delete the row from the data source
    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
    } else if editingStyle == .Insert {
    // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
    }
    */
    
    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
    
    }
    */
    
    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return NO if you do not want the item to be re-orderable.
    return true
    }
    */
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    }
    */
    
    //--Notifications handler
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ShareTableViewController.didReceiveNotification(_:)), name: "SnapRemoteNotification", object: nil)
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
                let VC : UIViewController? = self.presentingViewController?.presentingViewController?.presentingViewController
                
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
