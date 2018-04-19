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
  static let porcupineCategory:UInt32 = 0x1 << 1
  static let moonCategory:UInt32 = 0x1 << 2
}

extension GameScene {
  func createCat() -> SKSpriteNode {
    // size/position
    let cat = SKSpriteNode(texture: SKTextureAtlas(named:"player").textureNamed("ball"))
    cat.size = CGSize(width: 100, height: 100)
    cat.position = CGPoint(x:self.frame.midX, y:self.frame.midY)

    // bounce/gravity
    cat.physicsBody = SKPhysicsBody(circleOfRadius: cat.size.width / 2)
    cat.physicsBody?.linearDamping = 1.1
    cat.physicsBody?.restitution = 0
    cat.physicsBody?.affectedByGravity = true
    cat.physicsBody?.isDynamic = true

    // collisions/contacts
    cat.physicsBody?.categoryBitMask = CollisionBitMask.catCategory
    cat.physicsBody?.collisionBitMask = CollisionBitMask.porcupineCategory | CollisionBitMask.moonCategory
    cat.physicsBody?.contactTestBitMask = CollisionBitMask.porcupineCategory | CollisionBitMask.moonCategory

    return cat
  }
}
