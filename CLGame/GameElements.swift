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
var showPlayButton = Bool (false)

extension GameScene {

  func createRestartButton() -> SKSpriteNode {
    let playModal = SKSpriteNode(imageNamed: "replay")
    playModal.size = CGSize(width: playModal.size.width*0.9, height: playModal.size.height*0.9)
    playModal.position = CGPoint(x: frame.midX, y: frame.midY)
    playModal.zPosition = 6

    let savedhighestScore = UserDefaults.standard.integer(forKey: "highestScore")
    let scoreLabel = SKLabelNode(fontNamed:"FredokaOne-Regular")
    scoreLabel.text = "Score \(score)\nBest \(savedhighestScore)"
    scoreLabel.numberOfLines = 0
    scoreLabel.preferredMaxLayoutWidth = 1000
    scoreLabel.fontColor = UIColor(hex: "1E0F4B")
    scoreLabel.fontSize = 30
    scoreLabel.horizontalAlignmentMode = .center
    scoreLabel.verticalAlignmentMode = .center
    scoreLabel.position = CGPoint(x: 0, y: 0)

    let replayButton = SKSpriteNode(imageNamed: "replay-button")
    replayButton.position = CGPoint(x: 0, y: -playModal.size.height/4)
    
    playModal.addChild(scoreLabel)
    playModal.addChild(replayButton)
    
    return playModal
  }

  func createPlayButton() -> SKSpriteNode {
    let playModal = SKSpriteNode(imageNamed: "replay")
    playModal.size = CGSize(width: playModal.size.width*0.9, height: playModal.size.height*0.9)
    playModal.position = CGPoint(x: frame.midX, y: frame.midY)
    playModal.zPosition = 6

    let introLabel = SKLabelNode(fontNamed:"FredokaOne-Regular")
    introLabel.text = "Astro Kitty needs to\nsurvive on the moon.\nTap to play!"
    introLabel.numberOfLines = 0
    introLabel.preferredMaxLayoutWidth = 1000
    introLabel.fontColor = UIColor(hex: "1E0F4B")
    introLabel.fontSize = 22
    introLabel.horizontalAlignmentMode = .center
    introLabel.verticalAlignmentMode = .center
    introLabel.position = CGPoint(x: 0, y: 0)

    let playButton = SKSpriteNode(imageNamed: "play-button")
    playButton.position = CGPoint(x: 0, y: -playModal.size.height/4)

    playModal.addChild(introLabel)
    playModal.addChild(playButton)

    return playModal
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
    star.setScale(0.2)
    star.zPosition = -25
    star.position = CGPoint(x: Helper.random(min: 10, max: size.width - 10), y: Helper.random(min: frame.midY/2, max: frame.height))
    return star
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
    let mountainNode = SKSpriteNode(imageNamed: "mountain1")
    
    mountainNode.setScale(0.7)

    mountainNode.zPosition = -20
    mountainNode.anchorPoint = CGPoint.zero
    mountainNode.position = CGPoint(x: mountainNode.size.width * CGFloat(imageNumber) , y: 0)
    
    return mountainNode
  }

  func createMountain2(_ imageNumber: Int) -> SKSpriteNode {
    let mountainNode = SKSpriteNode(imageNamed: "mountain2")

    mountainNode.setScale(0.7)

    mountainNode.zPosition = -18
    mountainNode.anchorPoint = CGPoint.zero
    mountainNode.position = CGPoint(x: mountainNode.size.width * CGFloat(imageNumber) , y: 0)

    return mountainNode
  }

  func createMountain3(_ imageNumber: Int) -> SKSpriteNode {
    let mountainNode = SKSpriteNode(imageNamed: "mountain3")

    mountainNode.setScale(0.7)

    mountainNode.zPosition = -16
    mountainNode.anchorPoint = CGPoint.zero
    mountainNode.position = CGPoint(x: mountainNode.size.width * CGFloat(imageNumber) , y: 0)

    return mountainNode
  }
  
  func createGround(_ imageNumber: Int) -> SKSpriteNode {
    let groundNode = SKSpriteNode(imageNamed: "ground")

    groundNode.setScale(0.7)

    groundNode.zPosition = -10
    groundNode.anchorPoint = CGPoint.zero
    groundNode.position = CGPoint(x: groundNode.size.width * CGFloat(imageNumber) , y: 0)
    
    return groundNode
  }

}
