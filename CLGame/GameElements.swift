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

var randomY1: CGFloat = 185
var randomY2: CGFloat = 185
var randomY3: CGFloat = 185

var showReplayButton = Bool (false)

extension GameScene {

  func createRestartButton() -> SKSpriteNode {
    let restart = SKSpriteNode(imageNamed: "replay")
    restart.size = CGSize(width:frame.size.width - 60, height:170)
    restart.position = CGPoint(x: frame.midX, y: frame.midY)
    restart.zPosition = 6

    let savedhighestScore = UserDefaults.standard.integer(forKey: "highestScore")
    
    // RIGHT - scores
    let winnerScoreLabel = SKLabelNode(fontNamed:"FredokaOne-Regular")
    winnerScoreLabel.text = "Score \(score)\nBest \(savedhighestScore)"
    winnerScoreLabel.numberOfLines = 0
    winnerScoreLabel.preferredMaxLayoutWidth = 1000
    winnerScoreLabel.fontColor = UIColor(hex: "1E0F4B")
    winnerScoreLabel.fontSize = 28
    winnerScoreLabel.horizontalAlignmentMode = .center
    winnerScoreLabel.verticalAlignmentMode = .center
    winnerScoreLabel.position = CGPoint(x: restart.size.width/4, y: -restart.size.height/4)
    
    // LEFT - reply button
    let replayButton = SKSpriteNode(imageNamed: "replayButton")
    replayButton.setScale(0.2)
    replayButton.position = CGPoint(x: -restart.size.width/4, y: -restart.size.height/4)
    
    restart.addChild(winnerScoreLabel)
    restart.addChild(replayButton)
    
    return restart
  }

  func createCat() -> SKSpriteNode {
    let cat = SKSpriteNode(texture: SKTextureAtlas(named:"player").textureNamed("cat1"))
    cat.position = CGPoint(x:frame.midX, y:frame.midY)
    
    // bounce/gravity
    cat.physicsBody = SKPhysicsBody.init(texture: cat.texture!, alphaThreshold: 0.3, size: cat.size)
    cat.physicsBody?.linearDamping = 1.1
    cat.physicsBody?.restitution = 0.0
    cat.physicsBody?.isDynamic = true
    cat.physicsBody?.affectedByGravity = true
    cat.physicsBody?.allowsRotation = false

    // collisions/contacts
    cat.physicsBody?.categoryBitMask = CollisionBitMask.catCategory
    cat.physicsBody?.collisionBitMask = CollisionBitMask.obstacleCategory | CollisionBitMask.moonCategory
    cat.physicsBody?.contactTestBitMask = CollisionBitMask.obstacleCategory | CollisionBitMask.moonCategory

    return cat
  }
  
  func createSpaceShip() -> SKSpriteNode {
    let spaceShip = SKSpriteNode(imageNamed: "spaceship")
    spaceShip.setScale(0.9)

    // position spaceShip for iPhone X
    let iPhoneXNotchOffset: CGFloat = UIScreen.main.nativeBounds.height == 2436 ? 44 : 0
    spaceShip.position = CGPoint(x:frame.midX, y:frame.size.height - spaceShip.size.height/2 - iPhoneXNotchOffset)
    
    // bounce/gravity
    spaceShip.physicsBody = SKPhysicsBody.init(texture: spaceShip.texture!, alphaThreshold: 0.3, size: spaceShip.size)
    spaceShip.physicsBody?.affectedByGravity = false
    spaceShip.physicsBody?.allowsRotation = false
    spaceShip.physicsBody?.isDynamic = false
    
    // collisions/contacts
    spaceShip.physicsBody?.categoryBitMask = CollisionBitMask.moonCategory
    spaceShip.physicsBody?.collisionBitMask = CollisionBitMask.catCategory
    spaceShip.physicsBody?.contactTestBitMask = CollisionBitMask.catCategory
    
    return spaceShip
  }

  func createBeam() -> SKSpriteNode {
    let beam = SKSpriteNode(imageNamed: "beam")
    beam.name = "beam"
    beam.setScale(0.1)
    beam.anchorPoint = CGPoint(x: 0.5, y: 1)
    beam.position = CGPoint(x: 0, y: -spaceShip.size.height/2+10)
    return beam
  }

  func createStar() -> SKSpriteNode {
    let star = SKSpriteNode(imageNamed: "star3")
    star.setScale(0.5)
    star.zPosition = -25
    star.position = CGPoint(x: Helper.random(min: 10, max: size.width - 10), y: Helper.random(min: frame.midY, max: frame.height))
    return star
  }
  
  func createObsticle1() -> SKSpriteNode {
    let obsticleNode = SKSpriteNode(imageNamed: "pizza")
    obsticleNode.setScale(0.5)

    // randomize y position
    randomY1 =  Helper.random(min: obsticleNode.size.height + 200, max: frame.height - obsticleNode.size.height - spaceShip.size.height)
    obsticleNode.position = CGPoint(x: size.width - 10, y: randomY1)

    obsticleNode.physicsBody = SKPhysicsBody.init(texture: obsticleNode.texture!, alphaThreshold: 0.3, size: obsticleNode.size)
    obsticleNode.physicsBody?.categoryBitMask = CollisionBitMask.obstacleCategory
    obsticleNode.physicsBody?.collisionBitMask = CollisionBitMask.catCategory

    return obsticleNode
  }

  func createObsticle2() -> SKSpriteNode {
    let obsticleNode = SKSpriteNode(imageNamed: "cup")
    obsticleNode.setScale(0.5)

    // randomize y position
    randomY2 =  Helper.random(min: obsticleNode.size.height + 200, max: frame.height - obsticleNode.size.height - spaceShip.size.height)
    obsticleNode.position = CGPoint(x: size.width - 10, y: randomY2)

    obsticleNode.physicsBody = SKPhysicsBody.init(texture: obsticleNode.texture!, alphaThreshold: 0.3, size: obsticleNode.size)
    obsticleNode.physicsBody?.categoryBitMask = CollisionBitMask.obstacleCategory
    obsticleNode.physicsBody?.collisionBitMask = CollisionBitMask.catCategory

    return obsticleNode
  }

  func createObsticle3() -> SKSpriteNode {
    let obsticleNode = SKSpriteNode(imageNamed: "popcan")
    obsticleNode.setScale(0.5)

    // randomize y position
    randomY3 =  Helper.random(min: obsticleNode.size.height + 50, max: frame.height - obsticleNode.size.height - spaceShip.size.height)
    obsticleNode.position = CGPoint(x: size.width - 10, y: randomY3)

    obsticleNode.physicsBody = SKPhysicsBody.init(texture: obsticleNode.texture!, alphaThreshold: 0.3, size: obsticleNode.size)
    obsticleNode.physicsBody?.categoryBitMask = CollisionBitMask.obstacleCategory
    obsticleNode.physicsBody?.collisionBitMask = CollisionBitMask.catCategory

    return obsticleNode
  }

  func createScoreLabel() -> SKLabelNode {
    let scoreNode = SKLabelNode()
    scoreNode.text = "\(score)"
    scoreNode.zPosition = 5
    scoreNode.fontSize = 28
    scoreNode.fontColor = UIColor(hex: "1E0F4B")
    scoreNode.fontName = "FredokaOne-Regular"
    scoreNode.verticalAlignmentMode = .center
    scoreNode.horizontalAlignmentMode = .center
    scoreNode.position = CGPoint(x: (frame.width - scoreNode.frame.size.width - 20) , y: (frame.height - scoreNode.frame.size.height - 20))
    
    // background
    let scoreBackground = SKSpriteNode(imageNamed: "background-points")
    scoreBackground.setScale(0.7)
    scoreBackground.zPosition = -1
    
    scoreNode.addChild(scoreBackground)
    
    return scoreNode
  }

  func createSky(_ imageNumber: Int) -> SKSpriteNode {
    let skyNode = SKSpriteNode(imageNamed: "background")
    
    skyNode.setScale(0.7)
    skyNode.zPosition = -30
    skyNode.anchorPoint = CGPoint.zero
    skyNode.position = CGPoint(x: (skyNode.size.width * CGFloat(imageNumber)) - CGFloat(1 * imageNumber), y: 0)
    
    return skyNode
  }
  
  func createMountain(_ imageNumber: Int) -> SKSpriteNode {
    let mountainNode = SKSpriteNode(imageNamed: "mountain")
    
    mountainNode.setScale(0.85)
    mountainNode.zPosition = -20
    mountainNode.position = CGPoint(x: mountainNode.size.width/2 + mountainNode.size.width * CGFloat(imageNumber) , y: mountainNode.size.height / 2)
    
    return mountainNode
  }
  
  func createGround(_ imageNumber: Int) -> SKSpriteNode {
    let groundNode = SKSpriteNode(imageNamed: "ground")
    
    groundNode.setScale(0.7)
    groundNode.zPosition = -10
    groundNode.position = CGPoint(x: groundNode.size.width/2 + groundNode.size.width * CGFloat(imageNumber) , y: groundNode.size.height / 2)
    
    return groundNode
  }

}
