//
//  SettingCell.swift
//  SnapAround
//
//  Created by Karim Benhmida on 06/05/2015.
//  Copyright (c) 2015 Mehdi Kitane. All rights reserved.
//

import UIKit

class SettingCell: UITableViewCell {
    
    @IBOutlet weak var settingNameLabel: UILabel!
    @IBOutlet weak var settingDescriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
