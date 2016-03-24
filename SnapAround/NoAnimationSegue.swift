//
//  NoAnimationSegue.swift
//  SnapAround
//
//  Created by Mehdi Kitane on 30/04/2015.
//  Copyright (c) 2015 Mehdi Kitane. All rights reserved.
//

import UIKit

class NoAnimationSegue: UIStoryboardSegue {
    override func perform() {
        self.sourceViewController.presentViewController(self.destinationViewController , animated: false, completion: nil)
    }
}
