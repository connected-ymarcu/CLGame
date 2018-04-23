//
//  GameElements.swift
//  CLGame
//
//  Created by cl-dev on 2018-04-18.
//  Copyright © 2018 cl-dev. All rights reserved.
//

import SpriteKit

struct CollisionBitMask {
  static let catCategory:UInt32 = 0x1 << 0
  static let obstacleCategory:UInt32 = 0x1 << 1
  static let moonCategory:UInt32 = 0x1 << 2
}

var actualY: CGFloat = 185

extension GameScene {

  func displayRestartButton() {
    restartBtn = SKSpriteNode(imageNamed: "restart")
    restartBtn.size = CGSize(width:100, height:100)
    restartBtn.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
    restartBtn.zPosition = 6
    restartBtn.setScale(0)
    self.addChild(restartBtn)
    restartBtn.run(SKAction.scale(to: 1.0, duration: 0.3))
  }

  func createCat() -> SKSpriteNode {
    // size/position
    let cat = SKSpriteNode(texture: SKTextureAtlas(named:"player").textureNamed("Cat1"))
    cat.setScale(0.15)
    cat.position = CGPoint(x:self.frame.midX, y:self.frame.midY)

    // bounce/gravity
    cat.physicsBody = SKPhysicsBody(circleOfRadius: cat.size.width / 2)
    cat.physicsBody?.linearDamping = 1.1
    cat.physicsBody?.restitution = 0
    cat.physicsBody?.affectedByGravity = true
    cat.physicsBody?.isDynamic = true

    // collisions/contacts
    cat.physicsBody?.categoryBitMask = CollisionBitMask.catCategory
    cat.physicsBody?.collisionBitMask = CollisionBitMask.obstacleCategory | CollisionBitMask.moonCategory
    cat.physicsBody?.contactTestBitMask = CollisionBitMask.obstacleCategory | CollisionBitMask.moonCategory

    return cat
  }

  func createObsticle() -> SKSpriteNode {

    obsticle = SKSpriteNode(imageNamed: "flag")

    // randomize x and y position
    actualY =  random(min: obsticle.size.height/2, max: 185)
    let actualX = random(min: size.width + obsticle.size.width/2, max: size.width*3 )
    obsticle.position = CGPoint(x: actualX, y: actualY)

    // physics body using texture’s alpha channel
    let obsticleTexture = SKTexture(imageNamed: "flag.png")
    let circularObsticle = SKSpriteNode(texture: obsticleTexture)
    circularObsticle.physicsBody = SKPhysicsBody(circleOfRadius: max(circularObsticle.size.width / 2, circularObsticle.size.height / 2))
    obsticle.physicsBody = SKPhysicsBody(texture: obsticleTexture,
                                         size: CGSize(width: circularObsticle.size.width,
                                                      height: circularObsticle.size.height))

    obsticle.physicsBody?.categoryBitMask = CollisionBitMask.obstacleCategory
    obsticle.physicsBody?.collisionBitMask = CollisionBitMask.catCategory
    obsticle.physicsBody?.collisionBitMask = CollisionBitMask.catCategory

    return obsticle
  }
}
