//
//  ExpiresTableViewCell.swift
//  SnapAround
//
//  Created by Mehdi Kitane on 05/05/2015.
//  Copyright (c) 2015 Mehdi Kitane. All rights reserved.
//

import UIKit

class ExpiresTableViewCell: UITableViewCell {
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    let segments = ["1h","2h","4h","12h","24h", "1w", "∞"]
    let segmentsInterval : [NSTimeInterval?] = [3600, 7200, 14400, 43200, 86400, 604800, nil]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        if segments.count == 7 {
            for (i,elem) in segments.enumerate() {
                self.segmentedControl.setTitle(elem, forSegmentAtIndex: i)
            }
            self.segmentedControl.selectedSegmentIndex = 6
        }
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func getExpires() -> NSTimeInterval?{
        let i : Int = self.segmentedControl.selectedSegmentIndex
        return segmentsInterval[i]
    }
    
    func getExpiresString() -> String {
        let i : Int = self.segmentedControl.selectedSegmentIndex
        return segments[i]
    }
}
