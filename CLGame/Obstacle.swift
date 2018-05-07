//
//  Obstacle.swift
//  CLGame
//
//  Created by cl-dev on 2018-05-03.
//  Copyright © 2018 cl-dev. All rights reserved.
//

import Foundation
import SpriteKit

class Obstacle: SKSpriteNode {
  var imageName: String
  var yCoord: CGFloat
  var speedLimit: Double


  init(imageName: String, scale: CGFloat, xCoord:CGFloat, heightOffset: CGFloat, speedLimit: Double) {
    self.imageName = imageName
    self.yCoord = 0
    self.speedLimit = speedLimit
    super.init(texture: SKTexture(imageNamed: self.imageName), color: UIColor.red, size: SKTexture(imageNamed: self.imageName).size())
    if (scale != 0) {
      self.setScale(scale)
    }
    self.yCoord = Helper.random(min: self.size.height + 200, max: heightOffset - self.size.height)
    self.position = CGPoint(x: xCoord, y: yCoord)
    self.physicsBody = SKPhysicsBody.init(texture: self.texture!, alphaThreshold: 0.3, size: self.size)
    self.physicsBody?.categoryBitMask = CollisionBitMask.obstacleCategory
    self.physicsBody?.collisionBitMask = CollisionBitMask.catCategory
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
