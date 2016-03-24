//
//  MineAnnotationView.swift
//  SnapAround
//
//  Created by Mehdi Kitane on 22/05/2015.
//  Copyright (c) 2015 Mehdi Kitane. All rights reserved.
//

import UIKit
import MapKit

class MineAnnotationView: MKAnnotationView {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

    
    static var image = UIImage(named: "minePin")
    var countLabel : UILabel!
    var delegate : CustomAnnotationViewDelegate?
    
    
    override init(annotation: MKAnnotation!, reuseIdentifier: String!) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        self.enabled = true
        self.frame = CGRectMake(0, 0, 46, 46)
        super.image = MineAnnotationView.image
        
        //let tapGesture = UITapGestureRecognizer(target: self, action: Selector("didTapAnnotation"))
        //self.addGestureRecognizer(tapGesture)

        
        let userImg = UIImageView(frame: CGRectMake(7, 6.5, 32, 31))
        userImg.layer.cornerRadius = 16
        userImg.layer.masksToBounds = true
        self.addSubview(userImg)

        
        let access = FBSDKAccessToken.currentAccessToken().tokenString
        APIUsers.getMe(access, completion: { (theuser, error) -> Void in
            userImg.image = theuser?.picImage
        })
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func didTapAnnotation() {
        //override later
        //Mixpanel.sharedInstance().track("clickedMineAnnotation")
        snapLog("clickedMineAnnotation")
        //self.delegate?.didTapAnnotation()
    }

}
