//
//  MathLevel.swift
//  testgame
//
//  Created by Jozef Matus on 06/05/2017.
//  Copyright © 2017 Jozef Matus. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit

class MathLevel {
    
    
    var mathView: UIView!
    var remainingTimeLabel: UILabel!
    var resultTextField: UITextField!
    var enquasionLabel: UILabel!
    var submitButton: UIButton!
    var remainingTime: Int = 10
    var result: Int = 0
    weak var gameScene: GameScene!
    var bonusData: BonusData
    
    init(gameScene: GameScene, bonusData: BonusData) {
        self.gameScene = gameScene
        self.bonusData = bonusData
    }
    
    func createWindow() {
        self.setupWindow(scene: self.gameScene)
    }
    
    func setupWindow(scene: GameScene) {
        self.mathView = UIView()
        var view = scene.view!
        view.isUserInteractionEnabled = true
        view.addSubview(self.mathView)
        self.mathView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addConstraint(NSLayoutConstraint(item: self.mathView, attribute: NSLayoutAttribute.leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 20))
        view.addConstraint(NSLayoutConstraint(item: self.mathView, attribute: NSLayoutAttribute.trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: -20))
        view.addConstraint(NSLayoutConstraint(item: self.mathView, attribute: NSLayoutAttribute.top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 20))
        view.addConstraint(NSLayoutConstraint(item: self.mathView, attribute: NSLayoutAttribute.height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 200))
        
//        self.addTimeLable()
        self.addEnquasionLable()
        self.addTextField()
        self.addSubmitButton()
        self.generateEnquasion()
        self.resultTextField.becomeFirstResponder()
    }
    
    func addTimeLable() {
        self.remainingTimeLabel = UILabel()
        self.remainingTimeLabel.text = "\(remainingTime)"
        self.remainingTimeLabel.font = UIFont.boldSystemFont(ofSize: 20)
        self.remainingTimeLabel.textColor = UIColor.white
        self.remainingTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        self.mathView.addSubview(remainingTimeLabel)
        self.mathView.addConstraint(NSLayoutConstraint(item: self.remainingTimeLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 40))
        self.mathView.addConstraint(NSLayoutConstraint(item: self.remainingTimeLabel, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 40))
        self.mathView.addConstraint(NSLayoutConstraint(item: self.remainingTimeLabel, attribute: .leading, relatedBy: .equal, toItem: self.mathView, attribute: .leading, multiplier: 1, constant: 10))
        self.mathView.addConstraint(NSLayoutConstraint(item: self.remainingTimeLabel, attribute: .top, relatedBy: .equal, toItem: self.mathView, attribute: .top, multiplier: 1, constant: 0))
    }
    
    func addEnquasionLable() {
        self.enquasionLabel = UILabel()
        self.enquasionLabel.text = "SOME RANDOM ENQUASION"
        self.enquasionLabel.textColor = UIColor.white
        self.enquasionLabel.font = UIFont.boldSystemFont(ofSize: 20)
        self.enquasionLabel.textAlignment = .center
        self.enquasionLabel.translatesAutoresizingMaskIntoConstraints = false
        self.mathView.addSubview(enquasionLabel)
        self.mathView.addConstraint(NSLayoutConstraint(item: self.enquasionLabel, attribute: .leading, relatedBy: .equal, toItem: self.mathView, attribute: .leading, multiplier: 1, constant: 10))
        self.mathView.addConstraint(NSLayoutConstraint(item: self.enquasionLabel, attribute: .trailing, relatedBy: .equal, toItem: self.mathView, attribute: .trailing, multiplier: 1, constant: -10))
        self.mathView.addConstraint(NSLayoutConstraint(item: self.enquasionLabel, attribute: .top, relatedBy: .equal, toItem: self.mathView, attribute: .top, multiplier: 1, constant: 20))
    }
    
    func addTextField() {
        self.resultTextField = UITextField()
        self.resultTextField.placeholder = "RESULT HERE"
        self.resultTextField.font = UIFont.boldSystemFont(ofSize: 20)
        self.resultTextField.translatesAutoresizingMaskIntoConstraints = false
        self.resultTextField.backgroundColor = UIColor.white
        self.resultTextField.textAlignment = .center
        self.resultTextField.keyboardType = .numberPad
        self.mathView.addSubview(resultTextField)
        self.mathView.addConstraint(NSLayoutConstraint(item: self.resultTextField, attribute: .leading, relatedBy: .equal, toItem: self.mathView, attribute: .leading, multiplier: 1, constant: 40))
        self.mathView.addConstraint(NSLayoutConstraint(item: self.resultTextField, attribute: .trailing, relatedBy: .equal, toItem: self.mathView, attribute: .trailing, multiplier: 1, constant: -40))
        self.mathView.addConstraint(NSLayoutConstraint(item: self.resultTextField, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 40))
        self.mathView.addConstraint(NSLayoutConstraint(item: self.resultTextField, attribute: .top, relatedBy: .equal, toItem: self.enquasionLabel, attribute: .bottom, multiplier: 1, constant: 10))
    }
    
    func addSubmitButton() {
        self.submitButton = UIButton(type: .custom)
        self.submitButton.setTitleColor(UIColor.white, for: .normal)
        self.submitButton.setTitle("SUBMIT", for: .normal)
        self.submitButton.addTarget(self, action: #selector(submit), for: .touchUpInside)
        self.submitButton.translatesAutoresizingMaskIntoConstraints = false
        self.mathView.addSubview(submitButton)
        self.mathView.addConstraint(NSLayoutConstraint(item: self.submitButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 90))
        self.mathView.addConstraint(NSLayoutConstraint(item: self.submitButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 40))
        self.mathView.addConstraint(NSLayoutConstraint(item: self.submitButton, attribute: .top, relatedBy: .equal, toItem: self.resultTextField, attribute: .bottom, multiplier: 1, constant: 30))
        self.mathView.addConstraint(NSLayoutConstraint(item: self.submitButton, attribute: .centerX, relatedBy: .equal, toItem: self.mathView, attribute: .centerX, multiplier: 1, constant: 0))
        
        //        self.mathView.addConstraint(NSLayoutConstraint(item: self.submitButton, attribute: .centerX, relatedBy: .equal, toItem: self.mathView, attribute: .centerX, multiplier: 1, constant: 0))
    }
    //this is redudant af, i just dont care anymore
    @objc func submit() {
        guard let resultText = self.resultTextField.text else {
            self.mathView.removeFromSuperview()
            self.gameScene.unpause()
            return
        }
        guard Int(resultText) == self.result else {
            self.mathView.removeFromSuperview()
            self.gameScene.unpause()
            return
        }
        self.mathView.removeFromSuperview()
        self.gameScene.player.upgradeGun(bonus: self.bonusData)
        self.gameScene.unpause()
        
    }
    
    func generateEnquasion() {
        let firstNumber = arc4random_uniform(20)
        let secondNumber = arc4random_uniform(20)
        var sign: String = ""
        if arc4random_uniform(2) == 1 {
            self.result = Int(firstNumber + secondNumber)
            sign = "+"
        } else {
            if  firstNumber < secondNumber  {
                return self.generateEnquasion()
            }
            self.result = Int(firstNumber - secondNumber)
            sign = "-"
        }
        self.enquasionLabel.text = "\(firstNumber) \(sign) \(secondNumber) "
    }
    
}
