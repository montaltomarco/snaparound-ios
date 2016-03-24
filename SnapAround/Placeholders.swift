//
//  Placeholders.swift
//  SnapAround
//
//  Created by Mehdi Kitane on 14/05/2015.
//  Copyright (c) 2015 Mehdi Kitane. All rights reserved.
//

import Foundation


class Placeholders {
    class func collectionTableViewPlaceHolder(view : UIView) -> UILabel {
        let messageLabel = UILabel(frame: CGRectMake(0, 0, view.bounds.size.width, view.bounds.size.height))
        
        let attachment = NSTextAttachment()
        attachment.image = UIImage(named: "sad.png")
        let sadIcon = NSAttributedString(attachment: attachment)
        
        
        let myString = NSMutableAttributedString(string:NSLocalizedString("NO_PHOTO_COLLECTION",comment:"no photo collection"))
        
        
        let attachmentCollection = NSTextAttachment()
        attachmentCollection.image = UIImage(named: "grayAddToCollection.png")
        let collectionIcon = NSAttributedString(attachment: attachmentCollection)
        
        
        
        let finalString = NSMutableAttributedString()
        finalString.appendAttributedString(sadIcon)
        finalString.appendAttributedString(myString)
        finalString.appendAttributedString(collectionIcon)
        
        messageLabel.attributedText = finalString
        
        
        messageLabel.textColor = UIColor(rgba: "#9B9B9B")
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = NSTextAlignment.Center;
        messageLabel.font = UIFont(name: "Avenir Book", size: 18)
        messageLabel.sizeToFit();
        
        return messageLabel
    }
    class func aroundMeTableViewPlaceHolder(view : UIView) -> UILabel {
        let messageLabel = UILabel(frame: CGRectMake(0, 0, view.bounds.size.width, view.bounds.size.height))
        
        let attachment = NSTextAttachment()
        attachment.image = UIImage(named: "sad.png")
        let sadIcon = NSAttributedString(attachment: attachment)
        
        
        let myString = NSMutableAttributedString(string: NSLocalizedString("NO_PHOTO_AROUND",comment:"no photo around"))
    
        let finalString = NSMutableAttributedString()
        finalString.appendAttributedString(sadIcon)
        finalString.appendAttributedString(myString)
        
        messageLabel.attributedText = finalString
        
        
        messageLabel.textColor = UIColor(rgba: "#9B9B9B")
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = NSTextAlignment.Center;
        messageLabel.font = UIFont(name: "Avenir Book", size: 18)
        messageLabel.sizeToFit();
        
        return messageLabel
    }

}