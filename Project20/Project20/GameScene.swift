//
//  GameScene.swift
//  Project20
//
//  Created by Glenn R. Fisher on 8/13/17.
//  Copyright © 2017 Glenn R. Fisher. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var gameTimer: Timer!
    var fireworks = [SKNode]()
    
    let leftEdge = -22
    let bottomEdge = -22
    let rightEdge = 1024 + 22
    
    var score: Int = 0 {
        didSet {
            // add my code here...
        }
    }
    
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
        
        gameTimer = Timer.scheduledTimer(
            timeInterval: 6,
            target: self,
            selector: #selector(launchFireworks),
            userInfo: nil,
            repeats: true
        )
    }
    
    func createFirework(xMovement: CGFloat, x: Int, y: Int) {
        let node = SKNode()
        node.position = CGPoint(x: x, y: y)
        
        let firework = SKSpriteNode(imageNamed: "rocket")
        firework.name = "firework"
        firework.colorBlendFactor = 1
        node.addChild(firework)
        
        switch GKRandomSource.sharedRandom().nextInt(upperBound: 3) {
        case 0: firework.color = .cyan
        case 1: firework.color = .green
        case 2: firework.color = .red
        default: break
        }
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: xMovement, y: 1000))
        
        let move = SKAction.follow(path.cgPath, asOffset: true, orientToPath: true, speed: 200)
        node.run(move)
        
        let emitter = SKEmitterNode(fileNamed: "fuse")!
        emitter.position = CGPoint(x: 0, y: -22)
        node.addChild(emitter)
        
        fireworks.append(node)
        addChild(node)
    }
    
    func launchFireworks() {
        let movementAmount: CGFloat = 1800

        switch GKRandomSource.sharedRandom().nextInt(upperBound: 4) {
        case 0:
            // fire five fireworks, straight up
            createFirework(xMovement: 0, x: 512-200, y: bottomEdge)
            createFirework(xMovement: 0, x: 512-100, y: bottomEdge)
            createFirework(xMovement: 0, x: 512+000, y: bottomEdge)
            createFirework(xMovement: 0, x: 512+100, y: bottomEdge)
            createFirework(xMovement: 0, x: 512+200, y: bottomEdge)
        case 1:
            // fire five fireworks, in a fan
            createFirework(xMovement: -200, x: 512-200, y: bottomEdge)
            createFirework(xMovement: -100, x: 512-100, y: bottomEdge)
            createFirework(xMovement:  000, x: 512+000, y: bottomEdge)
            createFirework(xMovement:  100, x: 512+100, y: bottomEdge)
            createFirework(xMovement:  200, x: 512+200, y: bottomEdge)
        case 2:
            // fire five fireworks, from the left to the right
            createFirework(xMovement: movementAmount, x: leftEdge, y: bottomEdge+400)
            createFirework(xMovement: movementAmount, x: leftEdge, y: bottomEdge+300)
            createFirework(xMovement: movementAmount, x: leftEdge, y: bottomEdge+200)
            createFirework(xMovement: movementAmount, x: leftEdge, y: bottomEdge+100)
            createFirework(xMovement: movementAmount, x: leftEdge, y: bottomEdge+000)
        case 3:
            // fire five fireworks, from the right to the left
            createFirework(xMovement: -movementAmount, x: rightEdge, y: bottomEdge+400)
            createFirework(xMovement: -movementAmount, x: rightEdge, y: bottomEdge+300)
            createFirework(xMovement: -movementAmount, x: rightEdge, y: bottomEdge+200)
            createFirework(xMovement: -movementAmount, x: rightEdge, y: bottomEdge+100)
            createFirework(xMovement: -movementAmount, x: rightEdge, y: bottomEdge+000)
        default:
            break
        }
    }
    
    func explode(firework: SKNode) {
        let emitter = SKEmitterNode(fileNamed: "explode")!
        emitter.position = firework.position
        addChild(emitter)
        firework.removeFromParent()
    }
    
    func explodeFireworks() {
        var numExploded = 0
        
        for (index, container) in fireworks.enumerated().reversed() {
            let firework = container.children[0] as! SKSpriteNode
            if firework.name == "selected" {
                explode(firework: container)
                fireworks.remove(at: index)
                numExploded += 1
            }
        }
        
        switch numExploded {
        case 0: break
        case 1: score += 200
        case 2: score += 500
        case 3: score += 1500
        case 4: score += 2500
        case 5: score += 4000
        default: break
        }
    }
    
    func checkTouches(_ touches: Set<UITouch>) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        for node in nodes(at: location) {
            if let sprite = node as? SKSpriteNode, sprite.name == "firework" {
                for container in fireworks {
                    let firework = container.children[0] as! SKSpriteNode
                    if firework.name == "selected" && firework.color != sprite.color {
                        firework.name = "firework"
                        firework.colorBlendFactor = 1
                    }
                }
                
                sprite.name = "selected"
                sprite.colorBlendFactor = 0
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        checkTouches(touches)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        checkTouches(touches)
    }
    
    override func update(_ currentTime: TimeInterval) {
        for (index, firework) in fireworks.enumerated().reversed() {
            if firework.position.y > 900 {
                fireworks.remove(at: index)
                firework.removeFromParent()
            }
        }
    }
}
