//
//  TextLine.swift
//  outreachTrackingTool
//
//  Created by Graham Matthews on 3/14/20.
//  Copyright © 2020 Graham Matthews. All rights reserved.
//

import Vision

class TextLine {
    var text:String = ""
    var minX:CGFloat = CGFloat()
    var maxX:CGFloat = CGFloat()
    var minY:CGFloat = CGFloat()
    var maxY:CGFloat = CGFloat()
    var classification:String = ""
    
    init(text:String, minX:CGFloat, maxX:CGFloat, minY:CGFloat, maxY: CGFloat) {
        self.text = text
        self.minX = minX
        self.maxX = maxX
        self.minY = minY
        self.maxY = maxY
    }
}
