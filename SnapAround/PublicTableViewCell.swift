//
//  PublicTableViewCell.swift
//  SnapAround
//
//  Created by Mehdi Kitane on 05/05/2015.
//  Copyright (c) 2015 Mehdi Kitane. All rights reserved.
//

import UIKit

protocol PublicTableViewCellDelegate {
    func clickSwitch(on: Bool)
}

class PublicTableViewCell: UITableViewCell {
    
    @IBOutlet weak var publicLegend: UILabel!
    var delegate : PublicTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBAction func clickedSwitch(sender: AnyObject) {
        if let sender = (sender as? UISwitch) {
            self.delegate?.clickSwitch(sender.on)
            //Mixpanel.sharedInstance().track("click public", properties: ["isPublic" : sender.on])
        }
    }
}
