//
//  CustomNotification.swift
//  SnapAround
//
//  Created by Mehdi Kitane on 07/05/2015.
//  Copyright (c) 2015 Mehdi Kitane. All rights reserved.
//

import UIKit

class CustomNotification: UIView {
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
    // Drawing code
    }
    */
    
    //http://stackoverflow.com/questions/8346100/uibutton-cant-be-touched-while-animated-with-uiview-animatewithduration
    var userInfo :[NSObject : AnyObject]?
    var VC : UIViewController?
    var button : UIButton!
    
    init(userInfo: [NSObject : AnyObject]?, popUpViewController: UIViewController?) {
        let w = UIScreen.mainScreen().bounds
        super.init(frame: CGRectMake(0, 0, w.width, 64))
        
        
        self.userInfo = userInfo
        self.VC = popUpViewController
        
        
        var string : String? = nil
        if let userInfo = userInfo {
            let dic = userInfo["aps"] as? NSDictionary
            if let dic = dic {
                string = dic["alert"] as? String
            }
        }
        
        self.backgroundColor = UIColor.blackColor()
        self.alpha = 1
        
        
        let label = UILabel(frame: self.frame)
        if let string = string {
            label.text = string
        }
        label.textColor = UIColor.whiteColor()
        label.textAlignment = NSTextAlignment.Center
        label.numberOfLines = 0
        
        self.addSubview(label)
        
        
        button = UIButton(frame: self.frame)
        self.addSubview(button)
        button.addTarget(self, action: Selector("clicked"), forControlEvents: UIControlEvents.TouchUpInside)
    }
    func clicked(){
        let w = UIScreen.mainScreen().bounds
        self.frame = CGRectMake(0, -64, w.width, 64)
        
        button.removeTarget(self, action: Selector("clicked"), forControlEvents: UIControlEvents.TouchUpInside)
        VC?.dismissViewControllerAnimated(true, completion: { () -> Void in
            NSNotificationCenter.defaultCenter().postNotificationName("SnapRemoteNotification", object: nil, userInfo: self.userInfo)
        })
    }
    func show(){
        self.show(UIApplication.sharedApplication().keyWindow)
    }
    func show(view: UIView?){
        let w = UIScreen.mainScreen().bounds
        let options = UIViewAnimationOptions.AllowUserInteraction.union(.CurveEaseIn)
        
        
        if let view = view {
            view.addSubview(self)
            self.frame = CGRectMake(0, -64, w.width, 64)
            UIView.animateWithDuration(0.3, delay: 0, options: options, animations: { () -> Void in
                self.frame = CGRectMake(0, 0, w.width, 64)
                }, completion: { (completed) -> Void in
                    let timer = NSTimer(timeInterval: 1.5, target: self, selector: Selector("timerEvent"), userInfo: nil, repeats: false)
                    NSRunLoop.currentRunLoop().addTimer(timer, forMode: NSRunLoopCommonModes)
            })
        }
    }
    
    func timerEvent() {
        let w = UIScreen.mainScreen().bounds
        let options = UIViewAnimationOptions.AllowUserInteraction.union(.CurveEaseIn)
        
        UIView.animateWithDuration(0.3, delay: 0, options: options, animations: { () -> Void in
            self.frame = CGRectMake(0, -64, w.width, 64)
            }, completion: { (completed) -> Void in
                self.removeFromSuperview()
        })
    }
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
