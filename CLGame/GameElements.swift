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
  static let groundObstacleCategory:UInt32 = 0x1 << 1
  static let flyingObstacleCategory:UInt32 = 0x1 << 1
  static let flyingObstacleCategory2:UInt32 = 0x1 << 1
  static let moonCategory:UInt32 = 0x1 << 2
}

var randomY1: CGFloat = 185
var randomY2: CGFloat = 185
var randomY3: CGFloat = 185
var showReplayButton = Bool (false)

extension GameScene {

  func displayRestartButton() {
    restartBtn = SKSpriteNode(imageNamed: "replay")
    restartBtn.size = CGSize(width:300, height:300)
    restartBtn.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
    restartBtn.zPosition = 6
    restartBtn.setScale(0)

    // final score label
    let winnerScoreLabel = SKLabelNode(fontNamed:"Chalkduster")
    winnerScoreLabel.text = String(score)
    winnerScoreLabel.fontColor = UIColor(hex: "C1DCA6")
    winnerScoreLabel.fontSize = 48
    winnerScoreLabel.horizontalAlignmentMode = .center
    winnerScoreLabel.verticalAlignmentMode = .center

    restartBtn.addChild(winnerScoreLabel)
    self.addChild(restartBtn)
    restartBtn.run(SKAction.scale(to: 1.0, duration: 0.3))
    showReplayButton = true
  }

  func createCat() -> SKSpriteNode {
    // size/position
    let cat = SKSpriteNode(texture: SKTextureAtlas(named:"player").textureNamed("cat1"))
    cat.position = CGPoint(x:self.frame.midX, y:self.frame.midY)
    
    // bounce/gravity
    cat.physicsBody = SKPhysicsBody.init(texture: cat.texture!, alphaThreshold: 0.3, size: cat.size)
    cat.physicsBody?.linearDamping = 1.1
    cat.physicsBody?.restitution = 0.0
    cat.physicsBody?.isDynamic = true
    cat.physicsBody?.affectedByGravity = true
    cat.physicsBody?.allowsRotation = false

    // collisions/contacts
    cat.physicsBody?.categoryBitMask = CollisionBitMask.catCategory
    cat.physicsBody?.collisionBitMask = CollisionBitMask.flyingObstacleCategory | CollisionBitMask.groundObstacleCategory | CollisionBitMask.moonCategory
    cat.physicsBody?.contactTestBitMask = CollisionBitMask.flyingObstacleCategory | CollisionBitMask.groundObstacleCategory | CollisionBitMask.moonCategory

    return cat
  }
  
  func createSpaceShip() -> SKSpriteNode {
    
    let spaceShip = SKSpriteNode(imageNamed: "spaceShip")
    spaceShip.setScale(0.9)

    var iPhoneXNotchOffset: CGFloat = 0
    if UIScreen.main.nativeBounds.height == 2436 {
      iPhoneXNotchOffset = 44
    }
    
    spaceShip.position = CGPoint(x:self.frame.midX, y:self.frame.size.height - spaceShip.size.height/2 - iPhoneXNotchOffset)
    
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
    beam.position = CGPoint(x: 0, y: -spaceShip.size.height/2)
    return beam
  }

  func createStar() -> SKSpriteNode {
    star = SKSpriteNode(imageNamed: "star3")
    star.setScale(0.5)
    star.zPosition = -25
    star.position = CGPoint(x: random(min: 10, max: size.width - 10), y: random(min: frame.midY, max: frame.height))
    return star
  }
  
  func createGroundObsticle() -> SKSpriteNode {

    groundObsticle = SKSpriteNode(imageNamed: "pizza")
    groundObsticle.setScale(0.5)

    // randomize y position
    randomY1 =  random(min: groundObsticle.size.height + 200, max: frame.height - groundObsticle.size.height - spaceShip.size.height)
    groundObsticle.position = CGPoint(x: size.width - 10, y: randomY1)

    groundObsticle.physicsBody = SKPhysicsBody.init(texture: groundObsticle.texture!, alphaThreshold: 0.3, size: groundObsticle.size)

    groundObsticle.physicsBody?.categoryBitMask = CollisionBitMask.groundObstacleCategory
    groundObsticle.physicsBody?.collisionBitMask = CollisionBitMask.catCategory

    return groundObsticle
  }

  func createFlyingObsticle() -> SKSpriteNode {

    flyingObsticle = SKSpriteNode(imageNamed: "cup")
    flyingObsticle.setScale(0.5)

    // randomize y position
    randomY2 =  random(min: flyingObsticle.size.height + 200, max: frame.height - flyingObsticle.size.height - spaceShip.size.height)
    flyingObsticle.position = CGPoint(x: size.width - 10, y: randomY2)

    flyingObsticle.physicsBody = SKPhysicsBody.init(texture: flyingObsticle.texture!, alphaThreshold: 0.3, size: flyingObsticle.size)

    flyingObsticle.physicsBody?.categoryBitMask = CollisionBitMask.flyingObstacleCategory
    flyingObsticle.physicsBody?.collisionBitMask = CollisionBitMask.catCategory

    return flyingObsticle
  }

  func createFlyingObsticle2() -> SKSpriteNode {

    flyingObsticle2 = SKSpriteNode(imageNamed: "popcan")
    flyingObsticle2.setScale(0.5)

    // randomize y position
    randomY3 =  random(min: flyingObsticle2.size.height + 50, max: frame.height - flyingObsticle2.size.height - spaceShip.size.height)
    flyingObsticle2.position = CGPoint(x: size.width - 10, y: randomY3)

    flyingObsticle2.physicsBody = SKPhysicsBody.init(texture: flyingObsticle2.texture!, alphaThreshold: 0.3, size: flyingObsticle2.size)

    flyingObsticle2.physicsBody?.categoryBitMask = CollisionBitMask.flyingObstacleCategory2
    flyingObsticle2.physicsBody?.collisionBitMask = CollisionBitMask.catCategory

    return flyingObsticle2
  }

  func createScoreLabel() -> SKLabelNode {
    let scoreLbl = SKLabelNode()
    scoreLbl.text = "\(score)"
    scoreLbl.zPosition = 5
    scoreLbl.fontSize = 44
    scoreLbl.fontColor = UIColor(hex: "1D0E48")
    scoreLbl.fontName = "Chalkduster"
    scoreLbl.position = CGPoint(x: (self.frame.width - scoreLbl.frame.size.width - 20) , y: (self.frame.height - scoreLbl.frame.size.height - 40))

    // background
    let scoreBackground = SKSpriteNode(imageNamed: "points")
    scoreBackground.setScale(0.7)
    scoreBackground.zPosition = -1
    scoreBackground.position = CGPoint(x:0 , y: 15)

    scoreLbl.addChild(scoreBackground)

    return scoreLbl
  }

}

extension UIColor {
  convenience init(hex: String) {
    let scanner = Scanner(string: hex)
    scanner.scanLocation = 0

    var rgbValue: UInt64 = 0

    scanner.scanHexInt64(&rgbValue)

    let r = (rgbValue & 0xff0000) >> 16
    let g = (rgbValue & 0xff00) >> 8
    let b = rgbValue & 0xff

    self.init(
      red: CGFloat(r) / 0xff,
      green: CGFloat(g) / 0xff,
      blue: CGFloat(b) / 0xff, alpha: 1
    )
  }
}
