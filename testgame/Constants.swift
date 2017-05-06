//
//  Constants.swift
//  testgame
//
//  Created by Jozef Matus on 05/05/2017.
//  Copyright © 2017 Jozef Matus. All rights reserved.
//

import Foundation
import SpriteKit

struct PhysicsCategory {
    static let None      : UInt32 = 0
    static let All       : UInt32 = UInt32.max
    static let Shot      : UInt32 = 0x1
    static let Monster   : UInt32 = 0x1 << 1     // 2
    static let Bonus     : UInt32 = 0x1 << 2
    static let Player    : UInt32 = 0x1 << 3
}
