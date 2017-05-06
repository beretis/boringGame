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
//        skView.showsFPS = true
        skView.backgroundColor = UIColor.white
//        skView.showsNodeCount = true
        skView.ignoresSiblingOrder = true
//        skView.showsPhysics = true
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
        if win {
            let winAlert = UIAlertController(title: "CONGRATS", message: "YOU WON THIS BORING GAME, ENJOY", preferredStyle: UIAlertControllerStyle.alert)
            winAlert.addAction(UIAlertAction(title: "I WANNA FEEL SUCCESS AGAIN", style: UIAlertActionStyle.destructive, handler: { [unowned self] (action) in
                self.present(vc, animated: true, completion: nil)
            }))
            winAlert.show(self)
        } else {
            let loosAlert = UIAlertController(title: "GAME OVER", message: "I KNOW I KNOW ITS PRETTY BORING", preferredStyle: UIAlertControllerStyle.alert)
            loosAlert.addAction(UIAlertAction(title: "I'M GONNA TRY WHATSOEVER", style: UIAlertActionStyle.destructive, handler: { [unowned self] (action) in
                self.present(vc, animated: true, completion: nil)
            }))
            loosAlert.show(self)

        }

        
    }
    
}
