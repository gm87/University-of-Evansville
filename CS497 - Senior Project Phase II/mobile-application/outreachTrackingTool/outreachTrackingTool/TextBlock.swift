//
//  TextBlock.swift
//  outreachTrackingTool
//
//  Created by Graham Matthews on 3/14/20.
//  Copyright © 2020 Graham Matthews. All rights reserved.
//

import Vision

class TextBlock {
    var lines:[TextLine] = []
    var minX:CGFloat = CGFloat()
    var maxX:CGFloat = CGFloat()
    var minY:CGFloat = CGFloat()
    var maxY:CGFloat = CGFloat()
    var classification:String = ""
    var evaluated:Bool = false
    
    init(line: TextLine) {
        lines.append(line)
        minX = line.minX
        minY = line.minY
        maxX = line.maxX
        maxY = line.maxY
    }
    
    func addLine(line: TextLine) {
        lines.append(line)
        if (line.minX < minX) {
            minX = line.minX
        }
        if (line.minY < minY) {
            minY = line.minY
        }
        if (line.maxX > maxX) {
            maxX = line.maxX
        }
        if (line.maxY > maxY) {
            maxY = line.maxY
        }
    }
    
    func getLines() -> String {
        var text = ""
        for line in lines {
            text += line.text + "\\n"
        }
        return text
    }
    
    func getAllText() -> String {
        var text = ""
        for line in lines {
            text += line.text + "\n"
        }
        return text
    }
}
