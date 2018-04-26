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
  static let moonCategory:UInt32 = 0x1 << 2
}

var actualY: CGFloat = 185
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
    // flip cat zPosition
    
    // collisions/contacts
    cat.physicsBody?.categoryBitMask = CollisionBitMask.catCategory
    cat.physicsBody?.collisionBitMask = CollisionBitMask.flyingObstacleCategory | CollisionBitMask.groundObstacleCategory | CollisionBitMask.moonCategory
    cat.physicsBody?.contactTestBitMask = CollisionBitMask.flyingObstacleCategory | CollisionBitMask.groundObstacleCategory | CollisionBitMask.moonCategory

    return cat
  }

  func createGroundObsticle() -> SKSpriteNode {

    groundObsticle = SKSpriteNode(imageNamed: "moster1")

    // randomize y position
    actualY =  random(min: groundObsticle.size.height, max: 185)
    groundObsticle.position = CGPoint(x: size.width - 10, y: actualY)

    groundObsticle.physicsBody = SKPhysicsBody.init(texture: groundObsticle.texture!, alphaThreshold: 0.3, size: groundObsticle.size)

    groundObsticle.physicsBody?.categoryBitMask = CollisionBitMask.groundObstacleCategory
    groundObsticle.physicsBody?.collisionBitMask = CollisionBitMask.catCategory

    return groundObsticle
  }

  func createFlyingObsticle() -> SKSpriteNode {

    flyingObsticle = SKSpriteNode(imageNamed: "toaster")
    
    // randomize y position
    actualY =  random(min: (flyingObsticle.size.height + 340), max: frame.height)
    flyingObsticle.position = CGPoint(x: size.width - 10, y: actualY)

    flyingObsticle.physicsBody = SKPhysicsBody.init(texture: flyingObsticle.texture!, alphaThreshold: 0.3, size: flyingObsticle.size)

    flyingObsticle.physicsBody?.categoryBitMask = CollisionBitMask.flyingObstacleCategory
    flyingObsticle.physicsBody?.collisionBitMask = CollisionBitMask.catCategory

    return flyingObsticle
  }

  func createScoreLabel() -> SKLabelNode {
    let scoreLbl = SKLabelNode()
    scoreLbl.text = "\(score)"
    scoreLbl.zPosition = 5
    scoreLbl.fontSize = 44
    scoreLbl.fontColor = UIColor(hex: "1D0E48")
    scoreLbl.fontName = "Chalkduster"
    scoreLbl.position = CGPoint(x: (self.frame.width - scoreLbl.frame.size.width - 40) , y: self.frame.height - scoreLbl.frame.size.height - 40)

    // background
    let scoreBackground = SKSpriteNode(imageNamed: "Moon")
    scoreBackground.zPosition = -1
    scoreBackground.position = CGPoint(x: 0, y: 9)  //fishy y position - MUST FIX

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
