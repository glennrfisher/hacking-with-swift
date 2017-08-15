//
//  GameScene.swift
//  Project23
//
//  Created by Glenn R. Fisher on 8/15/17.
//  Copyright © 2017 Glenn R. Fisher. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var starfield: SKEmitterNode!
    var player: SKSpriteNode!
    var enemies = ["ball", "hammer", "tv"]
    
    var scoreLabel: SKLabelNode!
    var score: Int = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    var gameTimer: Timer!
    var isGameOver = false
    
    override func didMove(to view: SKView) {
        backgroundColor = .black
        
        starfield = SKEmitterNode(fileNamed: "Starfield")!
        starfield.position = CGPoint(x: 1024, y: 384)
        starfield.advanceSimulationTime(10)
        addChild(starfield)
        starfield.zPosition = -1
        
        player = SKSpriteNode(imageNamed: "player")
        player.position = CGPoint(x: 100, y: 384)
        player.physicsBody = SKPhysicsBody(texture: player.texture!, size: player.size)
        player.physicsBody!.contactTestBitMask = 1
        addChild(player)
        
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.position = CGPoint(x: 16, y: 16)
        scoreLabel.horizontalAlignmentMode = .left
        addChild(scoreLabel)
        
        score = 0
        
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        physicsWorld.contactDelegate = self
        
        gameTimer = Timer.scheduledTimer(
            timeInterval: 0.35,
            target: self,
            selector: #selector(createEnemy),
            userInfo: nil,
            repeats: true
        )
    }
    
    func createEnemy() {
        enemies = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: enemies) as! [String]
        let random = GKRandomDistribution(lowestValue: 50, highestValue: 736)
        
        let enemy = SKSpriteNode(imageNamed: enemies[0])
        enemy.position = CGPoint(x: 1200, y: random.nextInt())
        addChild(enemy)
        
        enemy.physicsBody = SKPhysicsBody(texture: enemy.texture!, size: enemy.size)
        enemy.physicsBody?.categoryBitMask = 1
        enemy.physicsBody?.velocity = CGVector(dx: -500, dy: 0)
        enemy.physicsBody?.angularVelocity = 5
        enemy.physicsBody?.linearDamping = 0
        enemy.physicsBody?.angularDamping = 0
    }
    
    override func update(_ currentTime: TimeInterval) {
        for node in children {
            if node.position.x < -300 {
                node.removeFromParent()
            }
        }
        
        if !isGameOver {
            score += 1
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        var location = touch.location(in: self)
        if location.y < 100 { location.y = 100 }
        else if location.y > 668 { location.y = 668 }
        player.position = location
    }
}

extension GameScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        let explosion = SKEmitterNode(fileNamed: "explosion")!
        explosion.position = player.position
        addChild(explosion)
        player.removeFromParent()
        isGameOver = true
    }
}
