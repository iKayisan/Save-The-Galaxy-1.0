//
//  GameOverScene.swift
//  Save The Galaxy
//
//  Created by Mary Dalmeida on 18/12/2019.
//  Copyright © 2019 iKayisan Apps. All rights reserved.
//

import Foundation
import SpriteKit

class GameOverScene: SKScene{
    
    let restartLabel = SKLabelNode(fontNamed: "ARCADECLASSIC")
    
    override func didMove(to view: SKView) {
        
        let background = SKSpriteNode(imageNamed: "Space")
        background.size = self.size
        background.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        background.zPosition = 0
        self.addChild(background)
        
        let gameOVerLabel = SKLabelNode(fontNamed: "ARCADECLASSIC")
        gameOVerLabel.text = "Game Over"
        gameOVerLabel.fontSize = 200
        gameOVerLabel.fontColor = SKColor.red
        gameOVerLabel.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.7)
        gameOVerLabel.zPosition = 1
        self.addChild(gameOVerLabel)
        
        let scoreLabel = SKLabelNode(fontNamed: "ARCADECLASSIC")
        scoreLabel.text = "Score: \(gameScore)"
        scoreLabel.fontSize = 125
        scoreLabel.fontColor = SKColor.white
        scoreLabel.position = CGPoint(x: self.size.width/2, y: self.size.height*0.55)
        scoreLabel.zPosition = 1
        self.addChild(scoreLabel)
        
        let defaults = UserDefaults()
        var highscoreNumber = defaults.integer(forKey: "highScoreSaved")
        
        if gameScore > highscoreNumber {
            highscoreNumber = gameScore
            defaults.set(highscoreNumber, forKey: "highScoreSaved")
        }
        
        let highScoreLabel = SKLabelNode(fontNamed: "ARCADECLASSIC")
        highScoreLabel.text = "High Score: \(highscoreNumber)"
        highScoreLabel.fontSize = 125
        highScoreLabel.fontColor = SKColor.green
        highScoreLabel.zPosition = 1
        highScoreLabel.position = CGPoint(x: self.size.width/2, y: self.size.height*0.45)
        self.addChild(highScoreLabel)
        
        restartLabel.text = "Restart"
        restartLabel.fontSize = 90
        restartLabel.fontColor = SKColor.white
        restartLabel.position = CGPoint(x: self.size.width/2, y: self.size.height*0.3)
        restartLabel.zPosition = 1
        self.addChild(restartLabel)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch: AnyObject in touches {
            
            let pointOfTouch = touch.location(in: self)
            
            if restartLabel.contains(pointOfTouch) {
                
                let sceneToMoveTo = GameScene(size: self.size)
                sceneToMoveTo.scaleMode = self.scaleMode
                let myTransition = SKTransition.fade(withDuration: 0.5)
                self.view!.presentScene(sceneToMoveTo, transition: myTransition)
            }
            
        }
    }
}
