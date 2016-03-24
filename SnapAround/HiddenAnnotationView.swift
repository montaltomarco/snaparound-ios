//
//  HiddenAnnotationView.swift
//  SnapAround
//
//  Created by Mehdi Kitane on 22/05/2015.
//  Copyright (c) 2015 Mehdi Kitane. All rights reserved.
//

import UIKit
import MapKit
class HiddenAnnotationView: MKAnnotationView {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

    
    static var image = UIImage(named: "hiddenPin")
    var countLabel : UILabel!
    var pinImg : UIImageView!
    var delegate : CustomAnnotationViewDelegate?
    
    
    override init(annotation: MKAnnotation!, reuseIdentifier: String!) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        self.enabled = true
        self.frame = CGRectMake(0, 0, 46, 46)
        super.image = HiddenAnnotationView.image
        
        //let tapGesture = UITapGestureRecognizer(target: self, action: Selector("didTapAnnotation"))
        //self.addGestureRecognizer(tapGesture)

        
        countLabel = UILabel(frame: self.frame)
        countLabel.textAlignment = .Center
        countLabel.font = UIFont(name: "AvenirNext-Regular", size: 22)
        countLabel.textColor = UIColor.whiteColor()
        self.addSubview(countLabel)
        
        
        pinImg = UIImageView(frame: CGRectMake(7, 6.5, 32, 31))
        pinImg.layer.cornerRadius = 16
        pinImg.layer.masksToBounds = true
        self.addSubview(pinImg)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateAnnotation(aggregate: PostAggregate) {
        if let user = aggregate.user {
            if let userPic = user.pic {
                APIHandler.downloadImageWithURL(userPic, completion: { (succeeded, image) -> Void in
                    self.pinImg.image = image
                })
            }
        } else {
            countLabel.text = String(aggregate.count)
        }
    }
    func didTapAnnotation() {
        //override later
        //Mixpanel.sharedInstance().track("clickedHiddenAnnotation")
        snapLog("clickedHiddenAnnotation")
        //self.delegate?.didTapAnnotation()
    }

    
}
