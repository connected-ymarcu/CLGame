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
    restart.size = CGSize(width:300, height:300)
    restart.position = CGPoint(x: frame.width / 2, y: frame.height / 2)
    restart.zPosition = 6
    restart.setScale(0)

    // final score label
    let winnerScoreLabel = SKLabelNode(fontNamed:"Chalkduster")
    winnerScoreLabel.text = String(score)
    winnerScoreLabel.fontColor = UIColor(hex: "C1DCA6")
    winnerScoreLabel.fontSize = 48
    winnerScoreLabel.horizontalAlignmentMode = .center
    winnerScoreLabel.verticalAlignmentMode = .center

    restart.addChild(winnerScoreLabel)
    
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
    let spaceShip = SKSpriteNode(imageNamed: "spaceShip")
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
    beam = SKSpriteNode(imageNamed: "beam")
    beam.name = "beam"
    beam.setScale(0.1)
    beam.anchorPoint = CGPoint(x: 0.5, y: 1)
    beam.position = CGPoint(x: 0, y: -spaceShip.size.height/2+10)
    return beam
  }

  func createStar() -> SKSpriteNode {
    star = SKSpriteNode(imageNamed: "star3")
    star.setScale(0.5)
    star.zPosition = -25
    star.position = CGPoint(x: Helper.random(min: 10, max: size.width - 10), y: Helper.random(min: frame.midY, max: frame.height))
    return star
  }
  
  func createObsticle1() -> SKSpriteNode {
    obsticle1 = SKSpriteNode(imageNamed: "pizza")
    obsticle1.setScale(0.5)

    // randomize y position
    randomY1 =  Helper.random(min: obsticle1.size.height + 200, max: frame.height - obsticle1.size.height - spaceShip.size.height)
    obsticle1.position = CGPoint(x: size.width - 10, y: randomY1)

    obsticle1.physicsBody = SKPhysicsBody.init(texture: obsticle1.texture!, alphaThreshold: 0.3, size: obsticle1.size)
    obsticle1.physicsBody?.categoryBitMask = CollisionBitMask.obstacleCategory
    obsticle1.physicsBody?.collisionBitMask = CollisionBitMask.catCategory

    return obsticle1
  }

  func createObsticle2() -> SKSpriteNode {
    obsticle2 = SKSpriteNode(imageNamed: "cup")
    obsticle2.setScale(0.5)

    // randomize y position
    randomY2 =  Helper.random(min: obsticle2.size.height + 200, max: frame.height - obsticle2.size.height - spaceShip.size.height)
    obsticle2.position = CGPoint(x: size.width - 10, y: randomY2)

    obsticle2.physicsBody = SKPhysicsBody.init(texture: obsticle2.texture!, alphaThreshold: 0.3, size: obsticle2.size)
    obsticle2.physicsBody?.categoryBitMask = CollisionBitMask.obstacleCategory
    obsticle2.physicsBody?.collisionBitMask = CollisionBitMask.catCategory

    return obsticle2
  }

  func createObsticle3() -> SKSpriteNode {

    obsticle3 = SKSpriteNode(imageNamed: "popcan")
    obsticle3.setScale(0.5)

    // randomize y position
    randomY3 =  Helper.random(min: obsticle3.size.height + 50, max: frame.height - obsticle3.size.height - spaceShip.size.height)
    obsticle3.position = CGPoint(x: size.width - 10, y: randomY3)

    obsticle3.physicsBody = SKPhysicsBody.init(texture: obsticle3.texture!, alphaThreshold: 0.3, size: obsticle3.size)
    obsticle3.physicsBody?.categoryBitMask = CollisionBitMask.obstacleCategory
    obsticle3.physicsBody?.collisionBitMask = CollisionBitMask.catCategory

    return obsticle3
  }

  func createScoreLabel() -> SKLabelNode {
    let scoreLbl = SKLabelNode()
    scoreLbl.text = "\(score)"
    scoreLbl.zPosition = 5
    scoreLbl.fontSize = 44
    scoreLbl.fontColor = UIColor(hex: "1D0E48")
    scoreLbl.fontName = "Chalkduster"
    scoreLbl.position = CGPoint(x: (frame.width - scoreLbl.frame.size.width - 20) , y: (frame.height - scoreLbl.frame.size.height - 40))

    // background
    let scoreBackground = SKSpriteNode(imageNamed: "points")
    scoreBackground.setScale(0.7)
    scoreBackground.zPosition = -1
    scoreBackground.position = CGPoint(x:0 , y: 15)

    scoreLbl.addChild(scoreBackground)

    return scoreLbl
  }

  func createSky(_ imageNumber: Int) -> SKSpriteNode {
    let sky = SKSpriteNode(imageNamed: "background")
    
    sky.setScale(0.7)
    sky.zPosition = -30
    sky.anchorPoint = CGPoint.zero
    sky.position = CGPoint(x: (sky.size.width * CGFloat(imageNumber)) - CGFloat(1 * imageNumber), y: 0)
    
    return sky
  }
  
  func createMountain(_ imageNumber: Int) -> SKSpriteNode {
    let mountain = SKSpriteNode(imageNamed: "mountain")
    
    mountain.setScale(0.85)
    mountain.zPosition = -20
    mountain.position = CGPoint(x: mountain.size.width/2 + mountain.size.width * CGFloat(imageNumber) , y: mountain.size.height / 2)
    
    return mountain
  }
  
  func createGround(_ imageNumber: Int) -> SKSpriteNode {
    let ground = SKSpriteNode(imageNamed: "ground")
    
    ground.setScale(0.7)
    ground.zPosition = -10
    ground.position = CGPoint(x: ground.size.width/2 + ground.size.width * CGFloat(imageNumber) , y: ground.size.height / 2)
    
    return ground
  }

}
