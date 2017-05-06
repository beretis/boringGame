//
//  GameLevel.swift
//  testgame
//
//  Created by Jozef Matus on 06/05/2017.
//  Copyright © 2017 Jozef Matus. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

struct GameLevelData {
    var monsterCount: Int
    var monsterTypes: [MonsterData]
    var spawnTime: TimeInterval
    var bonusTypes: [BonusData]
}

extension GameLevelData {
    static let lvl1 = GameLevelData(monsterCount: 30, monsterTypes: [MonsterData.monsterLvl10], spawnTime: 0.8, bonusTypes: [BonusData.bonus1])
    static let lvl2 = GameLevelData(monsterCount: 30, monsterTypes: [MonsterData.monsterLvl10, MonsterData.monsterLvl11], spawnTime: 0.8, bonusTypes: [BonusData.bonus1])
    static let lvl3 = GameLevelData(monsterCount: 30, monsterTypes: [MonsterData.monsterLvl11, MonsterData.monsterLvl12], spawnTime: 0.7, bonusTypes: [BonusData.bonus1, BonusData.bonus2])
    static let lvl4 = GameLevelData(monsterCount: 30, monsterTypes: [MonsterData.monsterLvl13, MonsterData.monsterLvl14], spawnTime: 0.7, bonusTypes: [BonusData.bonus2, BonusData.bonus3])
    static let lvl5 = GameLevelData(monsterCount: 30, monsterTypes: [MonsterData.monsterLvl13, MonsterData.monsterLvl14], spawnTime: 0.5, bonusTypes: [BonusData.bonus3, BonusData.bonus4])
    static let lvl6 = GameLevelData(monsterCount: 30, monsterTypes: [MonsterData.monsterLvl20], spawnTime: 0.4, bonusTypes: [BonusData.bonus3, BonusData.bonus4])
    static let lvl7 = GameLevelData(monsterCount: 30, monsterTypes: [MonsterData.monsterLvl21, MonsterData.monsterLvl22, MonsterData.monsterLvl23], spawnTime: 0.5, bonusTypes: [BonusData.bonus4, BonusData.bonus3])
    static let lvl8 = GameLevelData(monsterCount: 30, monsterTypes: [MonsterData.monsterLvl22, MonsterData.monsterLvl23], spawnTime: 0.8, bonusTypes: [BonusData.bonus4, BonusData.bonus3])
    static let lvl9 = GameLevelData(monsterCount: 30, monsterTypes: [MonsterData.monsterLvl22, MonsterData.monsterLvl23], spawnTime: 0.6, bonusTypes: [BonusData.bonus4, BonusData.bonus3])
    static let lvl10 = GameLevelData(monsterCount: 30, monsterTypes: [MonsterData.monsterLvl30, MonsterData.monsterLvl31], spawnTime: 0.6, bonusTypes: [BonusData.bonus4, BonusData.bonus3])
    static let lvl11 = GameLevelData(monsterCount: 30, monsterTypes: [MonsterData.monsterLvl32, MonsterData.monsterLvl34], spawnTime: 0.6, bonusTypes: [BonusData.bonus4, BonusData.bonus3])

}

class GameLevel {
    
    var levelData: GameLevelData
    weak var gameScene: GameScene!
    var monsterTimer: Timer!
    
    init(levelData: GameLevelData, gameScene: GameScene) {
        self.levelData = levelData
        self.gameScene = gameScene
    }
    
    func setUpMonsterTimer() -> Timer {
        return Timer.scheduledTimer(timeInterval: self.levelData.spawnTime, target: self, selector: #selector(self.spawnMonster), userInfo: nil, repeats: false)
    }
    
    func startLevel() {
        self.monsterTimer = self.setUpMonsterTimer()
    }
    
    func rollBonusSpawn() {
        let randomBonuses = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: self.levelData.bonusTypes) as! [BonusData]
        if arc4random_uniform(UInt32(self.levelData.monsterCount * 2)) == 1 {
            let bonus = Bonus(bonusData: randomBonuses.first!, gameScene: self.gameScene)
            bonus.spawn()
        }
    }
    
    @objc func spawnMonster() {
        self.monsterTimer.invalidate()
        let randomIndex = Int(arc4random_uniform(UInt32(self.levelData.monsterTypes.count)))
        let monster = Monster(gameScene: self.gameScene, monsterData: self.levelData.monsterTypes[randomIndex])
        monster.spawn()
        self.rollBonusSpawn()
        self.levelData.monsterCount -= 1
        if self.levelData.monsterCount > 0 {
            self.monsterTimer = self.setUpMonsterTimer()
        } else {
            self.gameScene.lvlFinished()
        }
    }
    
    func pause() {
        self.monsterTimer.invalidate()
    }
    
    func unpause() {
        self.monsterTimer = self.setUpMonsterTimer()
    }
    
}
