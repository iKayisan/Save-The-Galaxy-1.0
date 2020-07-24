//
//  GameScene.swift
//  Save The Galaxy
//
//  Created by Kayisan Mary Dalmeida on 17/12/2019.
//  Copyright © 2019 iKayisan Apps. All rights reserved.
//

import SpriteKit

//make thsi variable global
var gameScore = 0

class GameScene: SKScene, SKPhysicsContactDelegate {
    //runs as soon as the screen loads up
    
    //public variables
    
    let scoreLabel = SKLabelNode(fontNamed: "ARCADECLASSIC")
    
    var livesNumber = 5
    let livesLabel = SKLabelNode(fontNamed:  "ARCADECLASSIC")
    
    var levelNumber = 0 // keeps track of the level
    
    let player = SKSpriteNode(imageNamed: "spaceship")
    
    let bulletSound = SKAction.playSoundFileNamed("bulletSoundEffect.m4a", waitForCompletion: false)
    let explosionSound = SKAction.playSoundFileNamed("explosionSoundEffect.m4a", waitForCompletion: false)
    
    let tapToStartLabel = SKLabelNode(fontNamed: "ARCADECLASSIC")
    
    enum gameState {
        case preGame //when the game state is before the start of the game
        case inGame // when the game state is during the game
        case postGame //when the game state is after the game
    }
    
    var currentGameState = gameState.preGame

    
    //sets physics cathegories
    struct PhysicsCategories {
        static let None : UInt32 = 0
        static let Player : UInt32 = 0b1 //binary 1
        static let Bullet : UInt32 = 0b10 //2
        static let Enemy : UInt32 = 0b100 //4 --> 3 would represent the player and bullet
    }
    
    //utility functions
    func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    //generates a random number between the max and min range
    func random(min min: CGFloat, max: CGFloat) -> CGFloat {
        return random() * (max - min) + min
    }
    
    
    
    //set up game area
    //sets a playable area on all devices
    let gameArea: CGRect
    
    override init(size: CGSize) {
        
        let maxAspectRation: CGFloat = 16.0/9.0
        let playableWidth = size.height / maxAspectRation
        let margin = (size.width - playableWidth)/2
        gameArea = CGRect(x: margin, y: 0, width: playableWidth, height: size.height)
        
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func didMove(to view: SKView) {
        
        gameScore = 0
        
        self.physicsWorld.contactDelegate = self
        
        /**
         Creates a moving backgrounf
         */
        //for loop
        for i in 0...1 {
            
        //let to declare something new
        let background = SKSpriteNode (imageNamed: "Space")
        //declares the size of the background same as the scene (self)
        background.size = self.size
        background.anchorPoint = CGPoint(x: 0.5, y: 0)
        //positions the background at the center of the scene
        background.position = CGPoint(x: self.size.width/2,
                                      y: self.size.height*CGFloat(i))
        //zPosition is the layering of the background, the lower the number the further back is
        background.zPosition = 0
            background.name = "Background"
        //take all of this information and make the background
        self.addChild(background)
            
        }
        /**
         Creates the player
         */
        
        player.setScale(0.5) //1 normal size, 2 double the size
        player.position = CGPoint(x: self.size.width/2, y: 0 - player.size.height) //sets the y position to 20% of the height of the screen
        player.zPosition = 2 //in front of background
        //adds physics body to player
        player.physicsBody = SKPhysicsBody(rectangleOf: player.size)
        player.physicsBody!.affectedByGravity = false //player will not be affected by gravity
        player.physicsBody!.categoryBitMask = PhysicsCategories.Player //assigned physics body of the player to the player category
        player.physicsBody!.collisionBitMask = PhysicsCategories.None
        player.physicsBody!.contactTestBitMask = PhysicsCategories.Enemy
        self.addChild(player)
        
        scoreLabel.text = "Score: 0"
        scoreLabel.fontSize = 60
        scoreLabel.fontColor = SKColor.white
        scoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        scoreLabel.position = CGPoint(x: self.size.width * 0.21, y: self.size.height + scoreLabel.frame.size.height)
        scoreLabel.zPosition = 100
        self.addChild(scoreLabel)
        
        livesLabel.text = "Lives: \(livesNumber)"
        livesLabel.fontSize = 60
        livesLabel.fontColor = SKColor.red
        livesLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.right
        livesLabel.position = CGPoint(x: self.size.width * 0.79, y: self.size.height + livesLabel.frame.size.height)
        livesLabel.zPosition = 100
        self.addChild(livesLabel)
        
        let moveOnToScreenAction = SKAction.moveTo(y: self.size.height*0.9, duration: 0.3)
        scoreLabel.run(moveOnToScreenAction)
        livesLabel.run(moveOnToScreenAction)
        
        
        tapToStartLabel.text = "Tap  To  Start"
        tapToStartLabel.fontSize = 100
        tapToStartLabel.fontColor = SKColor.white
        tapToStartLabel.zPosition = 1
        tapToStartLabel.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        tapToStartLabel.alpha = 0
        self.addChild(tapToStartLabel)
        
        let fadeInAction = SKAction.fadeIn(withDuration: 0.3)
        tapToStartLabel.run(fadeInAction)
        
        //startNewLevel()
    
    }
    
    //stores time of the last frame
    var lastUpdateTime: TimeInterval = 0
    var deltaFrameTime: TimeInterval = 0
    var amountToMovePerSecond: CGFloat = 600.0
    
    override func update(_ currentTime: TimeInterval) {
        
        if lastUpdateTime == 0 {
            lastUpdateTime = currentTime
        }
        else {
            deltaFrameTime = currentTime - lastUpdateTime
            lastUpdateTime = currentTime
        }
        
        let amountToMoveBackground = amountToMovePerSecond * CGFloat(deltaFrameTime)
        
        self.enumerateChildNodes(withName: "Background"){
            background, stop in
            //only make background scroll if current game state is in Game
            if self.currentGameState == gameState.inGame{
            background.position.y -= amountToMoveBackground
            }
            
            if background.position.y < -self.size.height {
                background.position.y += self.size.height*2
            }
        }
    }
    
    func startGame() {
        
        currentGameState = gameState.inGame
        
        let fadeOutAction = SKAction.fadeOut(withDuration: 0.5)
        let deleteAction = SKAction.removeFromParent()
        let deleteSequence = SKAction.sequence([fadeOutAction, deleteAction])
        tapToStartLabel.run(deleteSequence)
        
        let moveShipOntoScreenAction = SKAction.moveTo(y: self.size.height*0.2, duration: 0.5)
        let startLevelAction = SKAction.run(startNewLevel)
        let startGameSequence = SKAction.sequence([moveShipOntoScreenAction, startLevelAction])
        player.run(startGameSequence)
    }
    
    
    /**
     Fucntion that takes away a life
     */
    func loseALife() {
        
        livesNumber -= 1
        livesLabel.text = "Lives: \(livesNumber)"
        
        let scaleUp = SKAction.scale(to: 1.5, duration: 0.2)
        let scaleDown = SKAction.scale(to: 1, duration: 0.2)
        let scaleSequence = SKAction.sequence([scaleUp, scaleDown])
        livesLabel.run(scaleSequence)
        
        if livesNumber == 0 {
            runGameOver()
        }
    }
    
    
    
    
    /**
     Add score function
     */
    func addScore() {
        
        gameScore += 1
        scoreLabel.text = "Score: \(gameScore)"
        
        if gameScore == 10  || gameScore == 20  || gameScore == 30  || gameScore == 40  || gameScore == 50  || gameScore == 60 || gameScore == 70  || gameScore == 80 || gameScore == 100 {
            
            startNewLevel()
        }
    }
    
    /**
     Runs game over
     */
    func runGameOver() {
        
        currentGameState = gameState.postGame
        
        self.removeAllActions() //stops enemies from spawning
        
        self.enumerateChildNodes(withName: "Bullet") {
            bullet, stop in
            bullet.removeAllActions()
        }
        
        self.enumerateChildNodes(withName: "Enemy") {
            enemy, stop in
            enemy.removeAllActions()
        }
        
        //waits for a second and changes scene 
        let changeSceneAction = SKAction.run(changeScene)
        let waitToChangeScene = SKAction.wait(forDuration: 1)
        let changeSceneSequence = SKAction.sequence([waitToChangeScene, changeSceneAction])
        self.run(changeSceneSequence)
    }
    
    
    func changeScene(){
        
        let sceneToMoveTo = GameOverScene(size: self.size)
        sceneToMoveTo.scaleMode = self.scaleMode
        let myTransition = SKTransition.fade(withDuration: 0.5)
        self.view!.presentScene(sceneToMoveTo, transition: myTransition)
    }
    
    
    /**
     Function that runs when two objects make contact
     */
    func didBegin(_ contact: SKPhysicsContact) {
        
        var body1 = SKPhysicsBody()
        var body2 = SKPhysicsBody()
        //lower category body number = body1, highest category body number = body2
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            body1 = contact.bodyA
            body2 = contact.bodyB
        }
        else {
            body1 = contact.bodyB
            body2 = contact.bodyA
        }
        
        if body1.categoryBitMask == PhysicsCategories.Player && body2.categoryBitMask == PhysicsCategories.Enemy {
            //if the player has hit the enemy --> delete player and enemy
            //"?" optional because any of the bodies might not have a node -> avoids potential glitch/ game from crashing
            
            //Show explosion if there is a node
            if body1.node != nil {
            spawnExplosion(spawnPosition: body1.node!.position)
            }
            
            if body2.node != nil {
            spawnExplosion(spawnPosition: body2.node!.position)
            }
            
            body1.node?.removeFromParent() //take body1 and the node associated with it and delete it
            body2.node?.removeFromParent()
            
            runGameOver()
        }
        
        
        if body1.categoryBitMask == PhysicsCategories.Bullet && body2.categoryBitMask == PhysicsCategories.Enemy && (body2.node?.position.y)! < self.size.height {
            //if the bullet has hit the enemy and if the enemy is on the screen
            
            addScore()
            
            if body2.node != nil {
            spawnExplosion(spawnPosition: body2.node!.position)
            }
            
            body1.node?.removeFromParent()
            body2.node?.removeFromParent()
        }
    }
    
    func spawnExplosion(spawnPosition: CGPoint) {
        
        let explosion = SKSpriteNode(imageNamed: "explosion2")
        explosion.position = spawnPosition
        explosion.zPosition = 3
        explosion.setScale(0)
        self.addChild(explosion)
       
        let scaleIn = SKAction.scale(to: 0.8, duration: 0.1)
        let fadeOut = SKAction.fadeOut(withDuration: 0.1)
        let delete = SKAction.removeFromParent()
        
        let explpsionSequence = SKAction.sequence([explosionSound,scaleIn, fadeOut, delete])
        
        explosion.run(explpsionSequence)

    }
    
    /**
     function Start new Level
     */
    func startNewLevel() {
        
        levelNumber += 1
        
        if self.action(forKey: "spawningEnemies") != nil {
            self.removeAction(forKey: "spawningEnemies")
        }
        
        var levelDuration  = TimeInterval()
        
        switch levelNumber {
            
        case 1: levelDuration = 2
        case 2: levelDuration = 1.8
        case 3: levelDuration = 1.6
        case 4: levelDuration = 1.4
        case 5: levelDuration = 1.2
        case 6: levelDuration = 1
        case 7: levelDuration = 0.8
        case 8: levelDuration = 0.6
        case 9: levelDuration = 0.4
        case 10: levelDuration = 0.2
        default:
            levelDuration = 0.5
            print("Cannot Find Level info")
        }
        
        //action to spawn the enemy
        let spawn = SKAction.run(spawnEnemy)
        let waitToSpawn = SKAction.wait(forDuration: levelDuration) //wait for a second
        let spawnSequence = SKAction.sequence([waitToSpawn, spawn])
        //repeat sequence in a loop
        let spawnForever = SKAction.repeatForever(spawnSequence)
        self.run(spawnForever, withKey: "spawningEnemies")
    }

    
    /**
     Fire bullets function
     */
    func fireBullet() {
        
        let bullet = SKSpriteNode(imageNamed: "laserbullet")
        bullet.name = "Bullet" //reference name
        bullet.setScale(0.5)
        bullet.position = player.position
        bullet.zPosition = 1
        
        //physics body
        bullet.physicsBody = SKPhysicsBody(rectangleOf: bullet.size)
        bullet.physicsBody!.affectedByGravity = false
        bullet.physicsBody!.categoryBitMask = PhysicsCategories.Bullet
        bullet.physicsBody!.collisionBitMask = PhysicsCategories.None
        bullet.physicsBody!.contactTestBitMask = PhysicsCategories.Enemy
        self.addChild(bullet)
        
        let moveBullet = SKAction.moveTo(y: self.size.height + bullet.size.height, duration: 1)
        let deleteBullet = SKAction.removeFromParent()
    
        let bulletSequence = SKAction.sequence([bulletSound,moveBullet, deleteBullet])
        bullet.run(bulletSequence)
    
    }
    
    /**
     Adds enemies
     */
    func spawnEnemy() {
        
        let randomXStart = random(min: gameArea.minX, max: gameArea.maxX)
        let randomXEnd = random(min: gameArea.minX, max: gameArea.maxX)
        
        let startPoint = CGPoint(x: randomXStart, y: self.size.height * 1.2)
        let endPoint = CGPoint(x:randomXEnd, y: -(self.size.height * 0.2))
        
        let enemy = SKSpriteNode(imageNamed: "enemyship")
        enemy.name = "Enemy"
        enemy.setScale(0.5)
        enemy.position = startPoint
        enemy.zPosition = 2
        
        if enemy.position.x > gameArea.maxX - (enemy.size.width) {
        enemy.position.x = gameArea.maxX - (enemy.size.width)
            }
    
        //if player goes over the max left of game area positionbumb back into the game area
        if enemy.position.x < gameArea.minX + (enemy.size.width) {
        enemy.position.x = gameArea.minX + (enemy.size.width)
            }
        
        //adds physics body to enemy
        enemy.physicsBody = SKPhysicsBody(rectangleOf: enemy.size)
        enemy.physicsBody!.affectedByGravity = false
        enemy.physicsBody!.categoryBitMask = PhysicsCategories.Enemy
        enemy.physicsBody!.collisionBitMask = PhysicsCategories.None //no collision
        enemy.physicsBody!.contactTestBitMask = PhysicsCategories.Player | PhysicsCategories.Bullet  //make contact w/P or B
        //"if enemy hits a player or bullet let us know"
        
        self.addChild(enemy)
        
        let moveEnemy = SKAction.move(to: endPoint, duration: 2)
        let deleteEnemy = SKAction.removeFromParent()
        let loseALifeAction = SKAction.run(loseALife)
        let enemySequence = SKAction.sequence([moveEnemy, deleteEnemy, loseALifeAction])
        
        
        if currentGameState == gameState.inGame {
        enemy.run(enemySequence)
        }
        
        //rotate enemy as it moves
        //find difference (d) in X and difference in Y
        let dx = endPoint.x - startPoint.x
        let dy = endPoint.y - startPoint.y
        let amountToRotate = atan2(dy, dx) //how much to rotate
        enemy.zRotation = amountToRotate //enemy rotating
    }
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if currentGameState == gameState.preGame {
            startGame()
        }
        
        else if currentGameState == gameState.inGame {
            fireBullet()
        }
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches{
            
            let pointOfTouch = touch.location(in: self)
            let previousPointOfTouch = touch.previousLocation(in: self)
            
            let amountDragged = pointOfTouch.x - previousPointOfTouch.x
            
            if currentGameState == gameState.inGame {
            player.position.x  += amountDragged
            }
            
            //locks player in game area
            //if player goes over right of the game area, bumb it back into the game area
            //the furthest area in the right of the game area
            if player.position.x > gameArea.maxX - (player.size.width) {
                player.position.x = gameArea.maxX - (player.size.width)
            }
            
            //if player goes over the max left of game area positionbumb back into the game area
            if player.position.x < gameArea.minX + (player.size.width) {
                player.position.x = gameArea.minX + (player.size.width)
            }
        }
        
    }
    
}
