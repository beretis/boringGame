//
//  Player.swift
//  testgame
//
//  Created by Jozef Matus on 04/05/2017.
//  Copyright © 2017 Jozef Matus. All rights reserved.
//

import Foundation
import SpriteKit


enum ShotLvl: String {
    case lvl1 = "laserBlue01"
    case lvl2 = "laserBlue02"
    case lvl3 = "laserGreen16"
    case lvl4 = "laserRed04"
    case lvl5 = "laserRed08"
}

struct ShotData {
    var dmg: Int
    var velocity: CGFloat
    var asset: ShotLvl
    var cadence: TimeInterval

}

extension ShotData {
    static let shotLvl1 = ShotData(dmg: 1, velocity: 1, asset: .lvl1, cadence: 1)
    static let shotLvl2 = ShotData(dmg: 1, velocity: 2, asset: .lvl2, cadence: 2)
    static let shotLvl3 = ShotData(dmg: 1, velocity: 3, asset: .lvl3, cadence: 3)
    static let shotLvl4 = ShotData(dmg: 2, velocity: 2, asset: .lvl4, cadence: 2)
    static let shotLvl5 = ShotData(dmg: 2, velocity: 3, asset: .lvl5, cadence: 3)

}

struct ShotFactory {
    
    static func createShot(shotLvl: ShotLvl) -> Shot {
        switch shotLvl {
        case .lvl1:
            return Shot(ShotData.shotLvl1)
        case .lvl2:
            return Shot(ShotData.shotLvl2)
        case .lvl3:
            return Shot(ShotData.shotLvl3)
        case .lvl4:
            return Shot(ShotData.shotLvl4)
        case .lvl5:
            return Shot(ShotData.shotLvl5)
        }
    }
    
}

class Shot: SKSpriteNode {
    var shotData: ShotData
    
    init(_ shotData: ShotData) {
        self.shotData = shotData
        let texture = SKTexture(imageNamed: self.shotData.asset.rawValue)
        super.init(texture: texture, color: UIColor.clear, size: texture.size())
        self.setup()
    }
    
    private func setup() {
        self.size = CGSize(width: 10, height: 10)
        self.physicsBody = SKPhysicsBody(circleOfRadius: self.size.width / 2)
        self.physicsBody?.isDynamic = true
        
        self.physicsBody?.categoryBitMask = PhysicsCategory.Shot
        self.physicsBody?.contactTestBitMask = PhysicsCategory.Monster
        self.physicsBody?.collisionBitMask = 0
        self.physicsBody?.usesPreciseCollisionDetection = true
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func isDestroyedAfterHitting(monster: MonsterData) -> Bool {
        self.shotData.dmg -= monster.health
        return self.shotData.dmg < 1
    }
    
}

struct Gun {
    var shotData: ShotData
    var ammo: Int
    
    init() {
        self.shotData = ShotData.shotLvl1
        self.ammo = -1
    }
    
    mutating func fire(FromPosition position: CGPoint, gameScene: SKScene) {
        self.handleGunFire()
        gameScene.run(SKAction.playSoundFileNamed("torpedo.mp3", waitForCompletion: false))
        print(self.shotData)
        let shot = Shot(self.shotData)
        shot.position = CGPoint(x: position.x, y: position.y)
        gameScene.addChild(shot)
        let velo = gameScene.size.height / shot.shotData.velocity
        let distance = gameScene.size.height - shot.position.y
        let time = (distance / velo) / self.shotData.velocity
        let shotAction = SKAction.move(to: CGPoint(x: shot.position.x, y: gameScene.size.height), duration: TimeInterval(time))
        let actionMoveDone = SKAction.removeFromParent()
        shot.run(SKAction.sequence([shotAction, actionMoveDone]))
    }
    
    private mutating func handleGunFire() {
        guard self.shotData.asset != .lvl1 else {
            return
        }
        guard self.ammo > 0 else {
            self.shotData = ShotData.shotLvl1
            self.ammo = -1
            return
        }
        self.ammo -= 1
    }
    
}

class Player: SKSpriteNode {
    
    let asset: String = "Spaceship"
    var health: Int = 1
    var gun: Gun
    weak var gameScene: SKScene!
    var shotingTimer: Timer!
    
    init(gameScene: SKScene) {
        let texture = SKTexture(imageNamed: asset)
        self.gameScene = gameScene
        self.gun = Gun()
        super.init(texture: texture, color: UIColor.clear, size: texture.size())
        self.size = CGSize(width: 40, height: 60)
        self.shotingTimer = self.setUpTimer()
        self.setup()
        
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        self.physicsBody = SKPhysicsBody(rectangleOf: self.size)
        self.physicsBody?.isDynamic = true
        
        self.physicsBody?.categoryBitMask = PhysicsCategory.Player
        self.physicsBody?.contactTestBitMask = PhysicsCategory.Bonus | PhysicsCategory.Monster
        print("players contact bitmask \(self.physicsBody!.contactTestBitMask)")
        self.physicsBody?.collisionBitMask = 0
        self.physicsBody?.usesPreciseCollisionDetection = true
    }
    
    
    private func setUpTimer() -> Timer {
        return Timer.scheduledTimer(timeInterval: 1 / self.gun.shotData.cadence, target: self, selector: #selector(self.shot), userInfo: nil, repeats: false)
    }

    func upgradeGun(bonus: BonusData) {
        self.gun.shotData = bonus.shotData
        self.gun.ammo = bonus.ammo
    }
    
    func shot() {
        self.shotingTimer.invalidate()
        self.shotingTimer = setUpTimer()
        gun.fire(FromPosition: CGPoint(x: self.position.x, y: self.position.y + self.size.height/2), gameScene: self.gameScene)
    }
    
    func stopShoting() {
        self.shotingTimer.invalidate()
    }
    
}
