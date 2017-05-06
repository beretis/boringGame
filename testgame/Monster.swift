//
//  Monster.swift
//  testgame
//
//  Created by Jozef Matus on 05/05/2017.
//  Copyright © 2017 Jozef Matus. All rights reserved.
//

import Foundation
import SpriteKit

struct MonsterData {
    var health: Int
    var velocity: CGFloat
    var asset: String
    var score: Int
}

extension MonsterData {
    static let monsterLvl10 = MonsterData(health: 1, velocity: 1, asset: "1", score: 5)
    static let monsterLvl11 = MonsterData(health: 1, velocity: 1.5, asset: "2", score: 6)
    static let monsterLvl12 = MonsterData(health: 1, velocity: 2, asset: "3", score: 7)
    static let monsterLvl13 = MonsterData(health: 1, velocity: 2.5, asset: "4", score: 8)
    static let monsterLvl14 = MonsterData(health: 1, velocity: 3, asset: "5", score: 9)
    
    static let monsterLvl20 = MonsterData(health: 2, velocity: 1.5, asset: "1B", score: 10)
    static let monsterLvl21 = MonsterData(health: 2, velocity: 2, asset: "2B", score: 11)
    static let monsterLvl22 = MonsterData(health: 1, velocity: 3.5, asset: "3B", score: 12)
    static let monsterLvl23 = MonsterData(health: 2, velocity: 2, asset: "4B", score: 13)
    static let monsterLvl24 = MonsterData(health: 2, velocity: 2.5, asset: "5B", score: 14)
    
    static let monsterLvl30 = MonsterData(health: 1, velocity: 1, asset: "1G", score: 15)
    static let monsterLvl31 = MonsterData(health: 1, velocity: 1, asset: "2G", score: 16)
    static let monsterLvl32 = MonsterData(health: 1, velocity: 1, asset: "3G", score: 17)
    static let monsterLvl33 = MonsterData(health: 1, velocity: 1, asset: "4G", score: 18)
    static let monsterLvl34 = MonsterData(health: 1, velocity: 1, asset: "5G", score: 19)

}

class Monster: SKSpriteNode {
    
    var monsterData: MonsterData
    weak var gameScene: SKScene!
    
    init(gameScene: SKScene, monsterData: MonsterData) {
        let texture = SKTexture(imageNamed: monsterData.asset)
        self.gameScene = gameScene
        self.monsterData = monsterData
        super.init(texture: texture, color: UIColor.clear, size: texture.size())
        self.name = "Monster"
        self.setup()
    }
    
    private func setup() {
        self.setScale(0.5)
        self.physicsBody = SKPhysicsBody(rectangleOf: self.size)
        self.physicsBody?.isDynamic = true
        
        self.physicsBody?.categoryBitMask = PhysicsCategory.Monster
        self.physicsBody?.contactTestBitMask = PhysicsCategory.Shot | PhysicsCategory.Player
        self.physicsBody?.collisionBitMask = 0
    }
    
    private func move() {
        // Determine speed of the monster

        
        // Create the actions
        let actionMove = SKAction.move(to: CGPoint(x: self.position.x, y: -self.size.height/2), duration: TimeInterval(4 / self.monsterData.velocity))
        let actionMoveDone = SKAction.removeFromParent()
        self.run(SKAction.sequence([actionMove, actionMoveDone]))
    }
    
    private func createMonster() {
        let actualX = random(min: self.size.width/2, max: gameScene.size.width - self.size.width/2)
        self.position = CGPoint(x: actualX, y: gameScene.size.height + self.size.height/2)
        self.gameScene.addChild(self)
    }
    
    func spawn() {
        self.createMonster()
        self.move()
    }
    
    func isMonsterDeadAfter(shot: ShotData) -> Bool {
        self.monsterData.health -= shot.dmg
        return self.monsterData.health < 1
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
