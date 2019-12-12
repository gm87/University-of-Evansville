//
//  Chip.swift
//  poker
//
//  Created by Graham Matthews on 11/27/19.
//  Copyright © 2019 Graham Matthews. All rights reserved.
//

import Foundation
import SpriteKit

class Chip:SKSpriteNode {
    private var value = ChipValue.ten
    
    init (value: ChipValue) {
        var texture:SKTexture
        self.value = value
        switch value {
        case .ten:
            texture = SKTexture(imageNamed: "money10")
        case .twentyFive:
            texture = SKTexture(imageNamed: "money25")
        case .fifty:
            texture = SKTexture(imageNamed: "money50")
        }
        super.init(texture: texture, color: SKColor.clear, size: texture.size())
        self.name = "chip"
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func getValue() -> ChipValue {
        return value
    }
}
