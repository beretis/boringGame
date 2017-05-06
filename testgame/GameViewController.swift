//
//  GameViewController.swift
//  testgame
//
//  Created by Jozef Matus on 03/05/2017.
//  Copyright © 2017 Jozef Matus. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit


class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let scene = GameScene(size: view.bounds.size)
        scene.gameNavigationProtocol = self
        let skView = view as! SKView
        skView.showsFPS = true
        skView.backgroundColor = UIColor.white
        skView.showsNodeCount = true
        skView.ignoresSiblingOrder = true
        skView.showsPhysics = true
        scene.scaleMode = .resizeFill
        skView.presentScene(scene)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
}

extension GameViewController: GameNavigationProtocol {
    
    func gameOver(win: Bool) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateInitialViewController()!
        self.present(vc, animated: true) { 
            if win {
                UIAlertController(title: "CONGRATS", message: "YOU WON THIS BORING GAME, ENJOY", preferredStyle: UIAlertControllerStyle.alert).show(vc, sender: self)
            }
        }
        
    }
    
}
