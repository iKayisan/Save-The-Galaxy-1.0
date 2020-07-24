//
//  MainMenuScene.swift
//  Save The Galaxy
//
//  Created by Mary Dalmeida on 19/01/2020.
//  Copyright © 2020 iKayisan Apps. All rights reserved.
//

import Foundation
import SpriteKit

class MainMenuScene: SKScene{
    
     override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "Space")
        background.size = self.size
        background.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        background.zPosition = 0
        self.addChild(background)
        
        let gameBy = SKLabelNode(fontNamed: "ARCADECLASSIC")
        gameBy.text = "Game by iKayisan ©"
        gameBy.fontSize = 30
        gameBy.fontColor = SKColor.white
        gameBy.position = CGPoint(x: self.size.width/2, y: self.size.height*0.05)
        gameBy.zPosition = 1
        self.addChild(gameBy)
        
        let gameName1 = SKLabelNode(fontNamed: "ARCADECLASSIC")
        gameName1.text = "Save"
        gameName1.fontSize = 180
        gameName1.fontColor = SKColor.red
        gameName1.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.645)
        gameName1.zPosition = 1
        self.addChild(gameName1)
        
        let gameName2 = SKLabelNode(fontNamed: "ARCADECLASSIC")
        gameName2.text = "The  Galaxy"
        gameName2.fontSize = 180
        gameName2.fontColor = SKColor.blue
        gameName2.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.565)
        gameName2.zPosition = 1
        self.addChild(gameName2)
        
        let startGame = SKLabelNode(fontNamed: "ARCADECLASSIC")
        startGame.text = "Start  Game"
        startGame.fontSize = 120
        startGame.fontColor = SKColor.green
        startGame.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.4)
        startGame.zPosition = 1
        startGame.name = "StartButton"
        self.addChild(startGame)
        
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch: AnyObject in touches{
            
            let pointOfTouch = touch.location(in: self)
            let nodeITapped = atPoint(pointOfTouch)
            if nodeITapped.name == "StartButton"{
                
                let sceneToMoveTo = GameScene(size: self.size)
                sceneToMoveTo.scaleMode = self.scaleMode
                let mytransition = SKTransition.fade(withDuration: 0.5)
                self.view!.presentScene(sceneToMoveTo, transition: mytransition)
            }
            
        }
    }
}
