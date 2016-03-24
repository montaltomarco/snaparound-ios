//
//  LegendTableViewCell.swift
//  SnapAround
//
//  Created by Mehdi Kitane on 05/05/2015.
//  Copyright (c) 2015 Mehdi Kitane. All rights reserved.
//

import UIKit

class LegendTableViewCell: UITableViewCell, UITextViewDelegate {
    
    @IBOutlet weak var textView: UITextView!
    let placeHolder : String = NSLocalizedString("WRITE_MESSAGE",comment:"write a message")
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.textView.delegate = self
        self.textView.text = self.placeHolder
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        if textView.text == self.placeHolder {
            textView.text = ""
            textView.textColor = UIColor.blackColor()
        }
        textView.becomeFirstResponder()
    }
    func textViewDidEndEditing(textView: UITextView) {
        if textView.text == "" {
            textView.text = self.placeHolder
            textView.textColor = UIColor.lightGrayColor()
        }
        textView.resignFirstResponder()
    }
    
    
}
