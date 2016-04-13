//
//  CollectionTableViewController.swift
//  SnapAround
//
//  Created by Mehdi Kitane on 29/04/2015.
//  Copyright (c) 2015 Mehdi Kitane. All rights reserved.
//

import UIKit

class CollectionTableViewController: UITableViewController, CollectionRemoveTableViewDelegate {
    
    var collectionPosts : Array<Post>! = []
    var isCollectionView = true
    var pictureIndexToFocusOn: Int = -1
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var numberOfPhotos: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_7_1 {
            self.tableView.estimatedRowHeight = 525.0
            self.tableView.rowHeight = UITableViewAutomaticDimension
        }
        
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if isCollectionView == true {
            //load Data
            let access = FBSDKAccessToken.currentAccessToken().tokenString
            
            UIApplication.sharedApplication().networkActivityIndicatorVisible = true
            APIPosts.getCollection(access, completion: { (array, error) -> Void in
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                if let _ = array {
                    self.collectionPosts = array
                }
                
                self.titleLabel.text = NSLocalizedString("MY_COLLECTION",comment:"my collection")
                if self.collectionPosts.count == 0 {
                    self.tableView.backgroundView = Placeholders.collectionTableViewPlaceHolder(self.view)
                    self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
                }
                self.numberOfPhotos.text = String(format: "%i photos", self.collectionPosts.count)
                self.tableView.reloadData()
            })
        } else {
            self.titleLabel.text = NSLocalizedString("PHOTOS_AROUND",comment:"photos around you")
            if self.collectionPosts.count == 0 {
                self.tableView.backgroundView = Placeholders.aroundMeTableViewPlaceHolder(self.view)
                self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
            }
            self.numberOfPhotos.text = String(format: "%i photos", self.collectionPosts.count)
            self.tableView.reloadData()
            if(self.pictureIndexToFocusOn != -1) {
                self.tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: self.pictureIndexToFocusOn, inSection: 0), atScrollPosition: UITableViewScrollPosition.Top, animated: true)
            }
        }
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func clickedBackButton(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - Table view data source
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_7_1 {
            return UITableViewAutomaticDimension
        }
        
        
        let screenSize = UIScreen.mainScreen().bounds
        
        //get data at indexPath
        let post = self.collectionPosts[indexPath.row]
        let descriptionSize : CGFloat
        
        if let str = post.msg {
            let myString: NSString = str as NSString
            let myFont : UIFont = UIFont(name: "Avenir Book", size: 15.0)!
            let width = screenSize.width - 58 - 18
            descriptionSize = myString.boundingRectWithSize(CGSizeMake(width, CGFloat.max), options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName :myFont], context: nil).height
            
        } else {
            descriptionSize = 0
        }
        
        let imageSize : CGFloat = 40.0
        let topSpace : CGFloat = 8.0
        let bottomSpace : CGFloat = 8.0
        let viewUpvoteSize : CGFloat = 20.0
        return screenSize.width + descriptionSize + imageSize + topSpace + bottomSpace + 15 + viewUpvoteSize
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return self.collectionPosts.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("collectionCell", forIndexPath: indexPath) as! CollectionTableViewCell
        
        let post = self.collectionPosts[indexPath.row]
        
        // Configure the cell...
        cell.delegate = self
        cell.isCollectionView = self.isCollectionView
        cell.updateCell(post)
        return cell
    }
    
    func removePost(post: Post) {
        let index : Int? = (self.collectionPosts as NSArray).indexOfObject(post)
        
        if let i = index {
            self.collectionPosts.removeAtIndex(i)
            let indexPath = NSIndexPath(forRow: i, inSection: 0)
            self.tableView.beginUpdates()
            self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Top)
            self.tableView.endUpdates()
            self.tableView.reloadData()
            self.numberOfPhotos.text = String(format: "%i photos", self.collectionPosts.count)
        }
    }
    
    func postAdded(post: Post) {
        
        let hud = MBProgressHUD.showHUDAddedTo(UIApplication.sharedApplication().delegate?.window!, animated: true)
        hud.mode = MBProgressHUDMode.Text
        hud.labelText = NSLocalizedString("POST_ADDED_COLLECTION",comment:"post added to collection")
        hud.show(true)
        
        
        hud.hide(true, afterDelay: 2)
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
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(CollectionTableViewController.didReceiveNotification(_:)), name: "SnapRemoteNotification", object: nil)
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
