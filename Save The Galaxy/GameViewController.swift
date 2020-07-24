//
//  GameViewController.swift
//  Save The Galaxy
//
//  Created by Mary Dalmeida on 17/12/2019.
//  Copyright © 2019 iKayisan Apps. All rights reserved.
//

import UIKit
import SpriteKit
import AVFoundation


class GameViewController: UIViewController {

    //audio
    var backingAudio = AVAudioPlayer()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let filePath = Bundle.main.path(forResource: "BackingAudio", ofType: "m4a")
        let audioNSURL = NSURL(fileURLWithPath: filePath!)
        
        
        do {
            backingAudio = try AVAudioPlayer(contentsOf: audioNSURL as URL)
        }
        catch {
            return print("Cannot find The Audio")
        }
         
        backingAudio.numberOfLoops = -1 //loops forever
        backingAudio.play()
        
        
        // Load 'GameScene.sks' as a GKScene. This provides gameplay related content
        // including entities and graphs.
        let scene = MainMenuScene(size: CGSize(width: 1536, height: 2048))
             
            // Get the SKScene from the loaded GKScene
           // if let sceneNode = scene.rootNode as! GameScene? {
                
                // Copy gameplay related content over to the scene
                //sceneNode.entities = scene.entities
                //sceneNode.graphs = scene.graphs
                
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
               
                // Present the scene
                if let view = self.view as! SKView? {
                    view.presentScene(scene)
                    
                    view.ignoresSiblingOrder = true
                    
                    view.showsFPS = false
                    view.showsNodeCount = false
                }
            }
       
    }

