//
//  Constantes.swift
//  SnapAround
//
//  Created by Mehdi Kitane on 13/05/2015.
//  Copyright (c) 2015 Mehdi Kitane. All rights reserved.
//
//


func snapLog(object : Any, file : NSString = #file, line : Int = #line ) {
    //#if DEBUG
    let fileName = file.lastPathComponent
    print("<\(fileName):\(line) [\(NSDate())]> \(object)")
    //#endif
}


func addBlurArea(viewToBlur: UIView, opacity : CGFloat) {
    if #available(iOS 8.0, *) {
        if !UIAccessibilityIsReduceTransparencyEnabled() {
            viewToBlur.backgroundColor = UIColor.clearColor()
            
            let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Light)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            
            blurEffectView.frame = viewToBlur.bounds
            blurEffectView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
            
            let container = UIView(frame: viewToBlur.bounds)
            container.alpha = opacity
            container.addSubview(blurEffectView)
            
            viewToBlur.insertSubview(container, atIndex: 0)
        }
    }
}


let mixpanelToken = "2c4ac80c52646f7236ec05811f18f506"
let urlTerms = "https://snaparound.herokuapp.com/#/terms"
