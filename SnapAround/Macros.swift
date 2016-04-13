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


let mixpanelToken = "2c4ac80c52646f7236ec05811f18f506"
let urlTerms = "https://snaparound.herokuapp.com/#/terms"
