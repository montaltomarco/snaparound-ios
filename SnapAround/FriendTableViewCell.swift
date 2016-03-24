//
//  FriendTableViewCell.swift
//  SnapAround
//
//  Created by Mehdi Kitane on 05/05/2015.
//  Copyright (c) 2015 Mehdi Kitane. All rights reserved.
//

import UIKit

protocol FriendTableViewCellDelegate {
    func friendAdded(friend: User)
    func friendRemoved(friend: User)
}

class FriendTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var buttonCheck: UIButton!
    var isSelected : Bool! = false
    
    var friend : User!
    var delegate : FriendTableViewCellDelegate?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func updateCell(friend:User) {
        self.friend = friend
        
        
        self.nameLabel.text = self.friend.name
        if let im = friend.picImage {
            self.profileImage.image = im
        } else {
            if let im = friend.pic {
                self.profileImage.image = CollectionTableViewCell.placeholderImage
                UIApplication.sharedApplication().networkActivityIndicatorVisible = true
                APIHandler.downloadImageWithURL(im, completion: { (succeeded, image) -> Void in
                    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                    if let image = image {
                        self.friend.picImage = image
                        self.profileImage.image = image
                    }
                })
            }
        }
    }
    
    
    @IBAction func clickedAddFriend(sender: AnyObject) {
        self.isSelected = !self.isSelected
        self.buttonCheck.selected = self.isSelected
        if self.isSelected == true {
            self.delegate?.friendAdded(friend)
            //Mixpanel.sharedInstance().track("share added friend")
        } else {
            self.delegate?.friendRemoved(friend)
            //Mixpanel.sharedInstance().track("share removed friend")
        }
    }
}
