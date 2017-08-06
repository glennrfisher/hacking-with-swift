//
//  GameScene.swift
//  Project11
//
//  Created by Glenn R. Fisher on 8/6/17.
//  Copyright © 2017 Glenn R. Fisher. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var scoreLabel: SKLabelNode!
    var score: Int = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    var editLabel: SKLabelNode!
    var editingMode: Bool = false {
        didSet {
            editLabel.text = editingMode ? "Done" : "Edit"
        }
    }
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        
        let background = SKSpriteNode(imageNamed: "background.jpg")
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
        
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.text = "Score: 0"
        scoreLabel.horizontalAlignmentMode = .right
        scoreLabel.position = CGPoint(x: 980, y: 700)
        addChild(scoreLabel)
        
        editLabel = SKLabelNode(fontNamed: "Chalkduster")
        editLabel.text = "Edit"
        editLabel.position = CGPoint(x: 80, y: 700)
        addChild(editLabel)
        
        let points = [(0, 0), (256, 0), (512, 0), (768, 0), (1024, 0)]
        points.forEach { point in makeBouncer(at: CGPoint(x: point.0, y: point.1)) }
        
        let slots = [(128, 0, true), (384, 0, false), (640, 0, true), (896, 0, false)]
        slots.forEach { slot in makeSlot(at: CGPoint(x: slot.0, y: slot.1), isGood: slot.2) }
    }
    
    func makeBouncer(at position: CGPoint) {
        let bouncer = SKSpriteNode(imageNamed: "bouncer.png")
        bouncer.position = position
        bouncer.physicsBody = SKPhysicsBody(circleOfRadius: bouncer.size.width / 2.0)
        bouncer.physicsBody!.isDynamic = false
        addChild(bouncer)
    }
    
    func makeSlot(at position: CGPoint, isGood: Bool) {
        let slotBaseImage = isGood ? "slotBaseGood.png" : "slotBaseBad.png"
        let slotBase = SKSpriteNode(imageNamed: slotBaseImage)
        slotBase.name = isGood ? "good" : "bad"
        slotBase.position = position
        slotBase.physicsBody = SKPhysicsBody(rectangleOf: slotBase.size)
        slotBase.physicsBody!.isDynamic = false
        addChild(slotBase)
        
        let slotGlowImage = isGood ? "slotGlowGood.png" : "slotGlowBad.png"
        let slotGlow = SKSpriteNode(imageNamed: slotGlowImage)
        slotGlow.position = position
        addChild(slotGlow)
        
        let spin = SKAction.rotate(byAngle: CGFloat.pi, duration: 10)
        let spinForever = SKAction.repeatForever(spin)
        slotGlow.run(spinForever)
    }
    
    func makeBall(at position: CGPoint) {
        let ball = SKSpriteNode(imageNamed: "ballRed")
        ball.name = "ball"
        ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width / 2.0)
        ball.physicsBody!.contactTestBitMask = ball.physicsBody!.collisionBitMask
        ball.physicsBody!.restitution = 0.4
        ball.position = position
        addChild(ball)
    }
    
    func makeBox(at position: CGPoint) {
        let width = GKRandomDistribution(lowestValue: 16, highestValue: 128).nextInt()
        let size = CGSize(width: width, height: 16)
        let box = SKSpriteNode(color: RandomColor(), size: size)
        box.zRotation = RandomCGFloat(min: 0, max: 3)
        box.position = position
        box.physicsBody = SKPhysicsBody(rectangleOf: box.size)
        box.physicsBody!.isDynamic = false
        addChild(box)
    }
    
    func collision(ball: SKNode, object: SKNode) {
        if object.name == "good" {
            destroy(ball: ball)
            score += 1
        } else if object.name == "bad" {
            destroy(ball: ball)
            score -= 1
        }
    }
    
    func destroy(ball: SKNode) {
        if let fireParticles = SKEmitterNode(fileNamed: "FireParticles") {
            fireParticles.position = ball.position
            addChild(fireParticles)
        }
        ball.removeFromParent()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: self)
            let objects = nodes(at: location)
            if objects.contains(editLabel) {
                editingMode = !editingMode
            } else {
                editingMode ? makeBox(at: location) : makeBall(at: location)
            }
        }
    }
}

extension GameScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        if contact.bodyA.node?.name == "ball" {
            collision(ball: contact.bodyA.node!, object: contact.bodyB.node!)
        } else if contact.bodyB.node?.name == "ball" {
            collision(ball: contact.bodyB.node!, object: contact.bodyA.node!)
        }
    }
}
