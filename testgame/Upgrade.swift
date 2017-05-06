//
//  Upgrade.swift
//  testgame
//
//  Created by Jozef Matus on 05/05/2017.
//  Copyright © 2017 Jozef Matus. All rights reserved.
//

import Foundation
import SpriteKit


struct BonusData {
    var shotData: ShotData
    var ammo: Int
    let asset: String
}

extension BonusData {
    static let bonus1 = BonusData(shotData: ShotData.shotLvl2, ammo: 40, asset: "bolt_bronze")
    static let bonus2 = BonusData(shotData: ShotData.shotLvl3, ammo: 40, asset: "bolt_gold")
    static let bonus3 = BonusData(shotData: ShotData.shotLvl4, ammo: 40, asset: "star_gold")
    static let bonus4 = BonusData(shotData: ShotData.shotLvl5, ammo: 40, asset: "powerupGreen_star")
}

class Bonus: SKSpriteNode {
    
    var bonusData: BonusData
    weak var gameScene: GameScene!
    
    init(bonusData: BonusData, gameScene: GameScene) {
        self.bonusData = bonusData
        self.gameScene = gameScene
        let texture = SKTexture(imageNamed: self.bonusData.asset)
        super.init(texture: texture, color: UIColor.clear, size: texture.size())
        self.name = "Bonus"
        self.setup()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        self.physicsBody = SKPhysicsBody(rectangleOf: self.size)
        self.physicsBody?.isDynamic = true
        
        self.physicsBody?.categoryBitMask = PhysicsCategory.Bonus
        self.physicsBody?.contactTestBitMask = PhysicsCategory.Player
        print("bonus contact bitmask \(self.physicsBody!.contactTestBitMask)")
        self.physicsBody?.collisionBitMask = 0
        self.physicsBody?.usesPreciseCollisionDetection = true

    }
    
    private func move() {
        // Determine speed of the monster
        let actualDuration = 3.5
        
        // Create the actions
        let actionMove = SKAction.move(to: CGPoint(x: self.position.x, y: -self.size.height/2), duration: TimeInterval(actualDuration))
        let actionMoveDone = SKAction.removeFromParent()
        self.run(SKAction.sequence([actionMove, actionMoveDone]))
    }
    
    private func createBonus() {
        let actualX = random(min: self.size.width/2, max: gameScene.size.width - self.size.width/2)
        self.position = CGPoint(x: actualX, y: gameScene.size.height + self.size.height/2)
        self.gameScene.addChild(self)
    }
    
    func spawn() {
        self.createBonus()
        self.move()
    }
    
}
