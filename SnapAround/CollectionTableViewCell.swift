//
//  CollectionTableViewCell.swift
//  SnapAround
//
//  Created by Mehdi Kitane on 04/05/2015.
//  Copyright (c) 2015 Mehdi Kitane. All rights reserved.
//

import UIKit

protocol CollectionRemoveTableViewDelegate {
    func removePost(post: Post)
    func postAdded(post: Post)
}
class CollectionTableViewCell: UITableViewCell, UIActionSheetDelegate {
    
    static var placeholderImage : UIImage! = UIImage(named: "gradient-bg")
    
    @IBOutlet weak var pic: UIImageView!
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var author: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var msg: UILabel!
    
    @IBOutlet weak var upvoteButton: UIButton!
    
    static let dateFormatter = NSDateFormatter()
    
    var post : Post!
    var delegate : CollectionRemoveTableViewDelegate?
    var isCollectionView :Bool! = true
    
    override func awakeFromNib() {
        super.awakeFromNib()
        pic.clipsToBounds = true
        
        let tap1 = UITapGestureRecognizer(target: self, action: Selector("tapImage"))
        let tap2 = UITapGestureRecognizer(target: self, action: Selector("tapProfilePic"))
        tap1.numberOfTapsRequired = 1
        tap2.numberOfTapsRequired = 1
        pic.userInteractionEnabled = true
        profilePic.userInteractionEnabled = true
        pic.addGestureRecognizer(tap1)
        profilePic.addGestureRecognizer(tap2)
        
        
        let enUSPosixLocale = NSLocale(localeIdentifier: "en_US_POSIX")
        CollectionTableViewCell.dateFormatter.locale = enUSPosixLocale
        CollectionTableViewCell.dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func updateCell(post:Post) {
        if isCollectionView  == true{
            self.button.setImage(UIImage(named: "RemoveFromCollection"), forState: UIControlState.Normal)
        } else {
            self.button.setImage(UIImage(named: "AddToCollection"), forState: UIControlState.Normal)
        }
        
        self.post = post
        
        //cell.pic.image
        //cell.profilePic.image
        self.author.text = post.user.name
        let newDateString = post.createdAt!.truncate(5, trailing: "+0000")
        let date = CollectionTableViewCell.dateFormatter.dateFromString(newDateString)
        self.date.text = RelativeTime.stringFromDate(date)
        self.msg.text = post.msg
        
        let url = NSURLRequest(URL: NSURL(string: post.pic)!)
        
        self.pic.setImageWithURLRequest(url, placeholderImage: CollectionTableViewCell.placeholderImage, success:nil, failure: nil)
        
        
        if let im = post.user.pic {
            let url = NSURLRequest(URL: NSURL(string:im)!)
            self.profilePic.setImageWithURLRequest(url, placeholderImage: CollectionTableViewCell.placeholderImage, success:nil, failure: nil)
        } else {
            self.profilePic.image = CollectionTableViewCell.placeholderImage
        }
        
        //        self.pic.image = CollectionTableViewCell.placeholderImage
        //        if let im = post.picImage {
        //            self.pic.image = im
        //        } else {
        //            self.pic.image = CollectionTableViewCell.placeholderImage
        //            APIHandler.downloadImageWithURL(post.pic, completion: { (succeeded, image) -> Void in
        //                if let image = image {
        //                    self.post.picImage = image
        //                    self.pic.image = image
        //                }
        //            })
        //        }
        //
        //        self.profilePic.image = CollectionTableViewCell.placeholderImage
        //
        //        if let im = post.user.picImage {
        //            self.profilePic.image = im
        //        } else {
        //            if let im = post.user.pic {
        //                self.profilePic.image = CollectionTableViewCell.placeholderImage
        //                APIHandler.downloadImageWithURL(im, completion: { (succeeded, image) -> Void in
        //                    if let image = image {
        //                        self.post.user.picImage = image
        //                        self.profilePic.image = image
        //                    }
        //                })
        //            }
        //        }
        
    }
    
    func tapImage() {
        if isCollectionView == true {
            //Mixpanel.sharedInstance().track("collection tapImage")
        } else {
            //Mixpanel.sharedInstance().track("around you tapImage")
        }
    }
    
    func tapProfilePic() {
        if isCollectionView == true {
            //Mixpanel.sharedInstance().track("collection tapProfilePic")
        } else {
            //Mixpanel.sharedInstance().track("around you tapProfilePic")
        }
    }
    @IBAction func clickedButton(sender: AnyObject) {
        let access = FBSDKAccessToken.currentAccessToken().tokenString
        if isCollectionView == true {
            //Mixpanel.sharedInstance().track("collection added post")
            UIApplication.sharedApplication().networkActivityIndicatorVisible = true
            APIPosts.removePostFromCollection(access, postID: post.postId) { (error) -> Void in
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                self.delegate?.removePost(self.post)
            }
        } else {
            //Mixpanel.sharedInstance().track("collection removed post")
            UIApplication.sharedApplication().networkActivityIndicatorVisible = true
            APIPosts.addPostToCollection(access, postID: post.postId, lat: Double(post.latitude), lon: Double(post.longitude), completion: { (post, error) -> Void in
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                self.delegate?.postAdded(self.post)
            })
        }
        
    }
    
    
    @IBAction func clickedSignalButton(sender: AnyObject) {
        let actionSheet = UIActionSheet(title: nil, delegate: self, cancelButtonTitle: nil, destructiveButtonTitle: nil)
        
        actionSheet.addButtonWithTitle(NSLocalizedString("REPORT_POST",comment:"Report this post"))
        actionSheet.addButtonWithTitle(NSLocalizedString("CANCEL",comment:"Cancel"))
        actionSheet.cancelButtonIndex = 1
        
        actionSheet.showInView(self.superview!)
        
    }
    
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        switch buttonIndex{
        case 0:
            NSLog("Signal on post " + String(self.post.postId));
            break;
        default:
            NSLog("Cancel");
            break;
            //Some code here..
        }
    }
    @IBAction func clickedUpvoteButton(sender: AnyObject) {
        NSLog("Upvote on post " + String(self.post.postId));
    }
    
    
    
}
