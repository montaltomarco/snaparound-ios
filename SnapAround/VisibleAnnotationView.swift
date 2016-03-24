//
//  visibleAnnotationView.swift
//  SnapAround
//
//  Created by Mehdi Kitane on 21/05/2015.
//  Copyright (c) 2015 Mehdi Kitane. All rights reserved.
//

import UIKit
import MapKit

protocol CustomAnnotationViewDelegate {
    func didTapAnnotation()
}

class VisibleAnnotationView: MKAnnotationView {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */


    static var image = UIImage(named: "visiblePin")
    var countLabel : UILabel!
    var delegate : CustomAnnotationViewDelegate?

    
    override init(annotation: MKAnnotation!, reuseIdentifier: String!) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        self.enabled = true
        self.frame = CGRectMake(0, 0, 78, 78)
        super.image = VisibleAnnotationView.image
//        self.backgroundColor = UIColor(rgba: "#825FCA")
//        self.layer.cornerRadius = 39
//        self.layer.masksToBounds = false
//        self.layer.borderColor = UIColor.whiteColor().CGColor
//        self.layer.borderWidth = 1
//        self.layer.shadowOffset = CGSizeMake(-15, 20);
//        self.layer.shadowRadius = 5;
//        self.layer.shadowOpacity = 0.5;
        
        let tapGesture = UITapGestureRecognizer(target: self, action: Selector("didTapAnnotation"))
        self.addGestureRecognizer(tapGesture)

        
        countLabel = UILabel(frame: self.frame)
        countLabel.textAlignment = .Center
        countLabel.font = UIFont(name: "AvenirNext-Regular", size: 22)
        countLabel.textColor = UIColor.whiteColor()
        self.addSubview(countLabel)
        self.layer.zPosition = 10000
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateAnnotation(nb: Int) {
        countLabel.text = String(nb)
    }
    func didTapAnnotation() {
        self.delegate?.didTapAnnotation()
        //Mixpanel.sharedInstance().track("clickedVisibleAnnotation")
        snapLog("clickedVisibleAnnotation")
    }
}
