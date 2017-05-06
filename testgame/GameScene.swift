//
//  GameScene.swift
//  testgame
//
//  Created by Jozef Matus on 03/05/2017.
//  Copyright © 2017 Jozef Matus. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    weak var gameNavigationProtocol: GameNavigationProtocol!
    var starfield:SKEmitterNode!
    var lvlLabel :SKLabelNode!
    var scoreLabel:SKLabelNode!
    var player: Player!
    var lvls: [GameLevel]!
    var currentLvlIndex = 0 {
        didSet {
            lvlLabel.text = "LEVEL: \(currentLvlIndex)"
        }
    }
    var score:Int = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    var mathLevel: MathLevel!
    
    override func didMove(to view: SKView) {
        self.initialStup()
        self.lvls.first!.startLevel()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let positionInScene = touch.location(in: self)
        let previousPosition = touch.previousLocation(in: self)
        let translation = CGPoint(x: positionInScene.x - previousPosition.x, y: positionInScene.y - previousPosition.y)
        
        panForTranslation(translation: translation)
    }

    func panForTranslation(translation: CGPoint) {
        let position = self.player.position
        let aNewPosition = CGPoint(x: position.x + translation.x, y: position.y + translation.y)
        self.player.position = aNewPosition
    }

    //private
    private func initialStup() {
        self.precacheSounds()
        self.setupLvls()
        self.setupScene()
        self.setupPlayer()
        self.setupLevelLabel()
        self.setupScoreLabel()
    }
    
    func precacheSounds() {
        SKAction.playSoundFileNamed("explosion.mp3", waitForCompletion: false)
        SKAction.playSoundFileNamed("torpedo.mp3", waitForCompletion: false)
    }
    
    private func setupScene() {
        starfield = SKEmitterNode(fileNamed: "Starfield")
        starfield.position = CGPoint(x: 0, y: 1472)
        starfield.advanceSimulationTime(10)
        self.addChild(starfield)
        
        starfield.zPosition = -1
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        self.physicsWorld.contactDelegate = self
    }
    
    private func setupLvls() {
        self.lvls = [
            GameLevel(levelData: GameLevelData.lvl1, gameScene: self),
            GameLevel(levelData: GameLevelData.lvl2, gameScene: self),
            GameLevel(levelData: GameLevelData.lvl3, gameScene: self),
            GameLevel(levelData: GameLevelData.lvl4, gameScene: self),
            GameLevel(levelData: GameLevelData.lvl5, gameScene: self),
            GameLevel(levelData: GameLevelData.lvl6, gameScene: self),
            GameLevel(levelData: GameLevelData.lvl7, gameScene: self),
            GameLevel(levelData: GameLevelData.lvl8, gameScene: self),
            GameLevel(levelData: GameLevelData.lvl9, gameScene: self)
        ]
    }

    private func setupPlayer() {
        self.player = Player(gameScene: self)
        self.player.position = CGPoint(x: self.size.width/2, y: self.player.size.height/2)
        self.addChild(self.player)
    }

    private func setupLevelLabel() {
        self.lvlLabel = SKLabelNode(text: "LEVEL: 0")
        self.lvlLabel.position = CGPoint(x: 10, y: self.frame.size.height - 40)
        self.lvlLabel.fontName = "AmericanTypewriter-Bold"
        self.lvlLabel.fontSize = 15
        self.lvlLabel.fontColor = UIColor.white
        self.lvlLabel.horizontalAlignmentMode = .left
        self.addChild(lvlLabel)
    }
    
    private func setupScoreLabel() {
        self.scoreLabel = SKLabelNode(text: "Score: 0")
        self.scoreLabel.position = CGPoint(x: 10, y: self.frame.size.height - 60)
        self.scoreLabel.fontName = "AmericanTypewriter-Bold"
        self.scoreLabel.fontSize = 20
        self.scoreLabel.fontColor = UIColor.white
        self.scoreLabel.horizontalAlignmentMode = .left
        self.addChild(scoreLabel)
    }
    
    public func pauseLvl() {
        self.player.stopShoting()
        self.lvls[self.currentLvlIndex].pause()
    }
    
    public func unpause() {
        self.player.shot()
        self.lvls[self.currentLvlIndex].unpause()
    }
    
    public func lvlFinished() {
        guard self.currentLvlIndex != self.lvls.count - 1 else {
            self.gameOver(win: true)
            return
        }
        self.currentLvlIndex += 1
        self.lvls[currentLvlIndex].startLevel()
    }
    
    func playerPickedBonus(bonus: Bonus) {
        self.enumerateChildNodes(withName: "Monster") { (node, pointer) in
            node.removeFromParent()
        }
        self.enumerateChildNodes(withName: "Bonus") { (node, pointer) in
            node.removeFromParent()
        }
        self.pauseLvl()
        self.mathLevel = MathLevel(gameScene: self, bonusData: bonus.bonusData)
        self.mathLevel.createWindow()
        bonus.removeFromParent()
    }
    
    
    func monsterWasHit(shot: Shot, monster: Monster) {
        
        let monsterDataCopy = monster.monsterData
        let shotDataCopy = shot.shotData
        if monster.isMonsterDeadAfter(shot: shotDataCopy) {
            let explosion = SKEmitterNode(fileNamed: "Explosion")!
            explosion.position = monster.position
            self.addChild(explosion)
            self.run(SKAction.playSoundFileNamed("explosion.mp3", waitForCompletion: false))
            
            self.run(SKAction.wait(forDuration: 2)) {
                explosion.removeFromParent()
            }
            
            self.score += monster.monsterData.score
            
            monster.removeFromParent()
        }
        if shot.isDestroyedAfterHitting(monster: monsterDataCopy) {
            shot.removeFromParent()
        }
    }
    
    func gameOver(win: Bool) {
        self.pauseLvl()
        self.removeAllActions()
        self.removeAllChildren()
        self.removeFromParent()
        self.gameNavigationProtocol.gameOver(win: win)
    }
    
    
}

extension GameScene: SKPhysicsContactDelegate {
    
    
    func didBegin(_ contact: SKPhysicsContact) {
        var firstBody:SKPhysicsBody
        var secondBody:SKPhysicsBody
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        }else{
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        if (firstBody.categoryBitMask == PhysicsCategory.Shot) && (secondBody.categoryBitMask == PhysicsCategory.Monster) {
            monsterWasHit(shot: firstBody.node as! Shot, monster: secondBody.node as! Monster)
        }
        
        if (firstBody.categoryBitMask == PhysicsCategory.Bonus) && (secondBody.categoryBitMask == PhysicsCategory.Player) {
            print(secondBody.categoryBitMask)
            self.playerPickedBonus(bonus: firstBody.node as! Bonus)
        }
        
        if (firstBody.categoryBitMask == PhysicsCategory.Monster) && (secondBody.categoryBitMask == PhysicsCategory.Player) {
            self.gameOver(win: false)
        }
        
    }

}

protocol GameNavigationProtocol: class {
    func gameOver(win: Bool)
}




func random() -> CGFloat {
    return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
}

func random(min: CGFloat, max: CGFloat) -> CGFloat {
    return random() * (max - min) + min
}
