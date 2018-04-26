//
//  GameScene.swift
//  CLGame
//
//  Created by cl-dev on 2018-04-18.
//  Copyright © 2018 cl-dev. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate{

    // game loop
    var restartBtn = SKSpriteNode()
    var startedGame = false
    var lostGame = false
    var isFlipped = false
    let levelUpScore = 5
  
    // flying
    var numberOfFlyingObsticles: Double  = 2
    var speedOfFlyingObsticles: Double = 1
    // ground
    var numberOfGroundObsticles: Double = 3 // the lower, the more obsticles show up
    var speedOfGroundObsticles: Double  = 3  // the lower, the faster obsticles move
  
    // score
    var score = Int(0)
    var scoreLbl = SKLabelNode()

    // cat
    var cat = SKSpriteNode()
    let catAtlas = SKTextureAtlas(named:"player")
    var catTextureArray = Array<SKTexture>()
    var repeatActionCat = SKAction()

    // obstacle
    var groundObsticle = SKSpriteNode()
    var flyingObsticle = SKSpriteNode()


    // scene
    let backgroundName = "background"
    var ground = SKSpriteNode()

    func currentlyPlaying () -> Bool {
      return startedGame && !lostGame
    }

    func createScene(){

      // setup contacting with the edge and collisions
      let edgeFrame = CGRect(
        origin: CGPoint(x: 0, y: 50),
        size: CGSize(width: self.frame.width, height: self.frame.height - 50)
      )
      self.physicsBody = SKPhysicsBody(edgeLoopFrom: edgeFrame)
      self.physicsBody?.categoryBitMask = CollisionBitMask.moonCategory
      self.physicsBody?.collisionBitMask = CollisionBitMask.catCategory
      self.physicsBody?.contactTestBitMask = CollisionBitMask.catCategory
      self.physicsWorld.contactDelegate = self
      self.physicsWorld.gravity = CGVector(dx: 0.0, dy: -9.8)  // Jupiter gravity -24.8, moon gravity is -1.62
      
      // setup background - create 2 background image side by side
      for i in 0..<2
      {
        createBackground(imageNumber: i)
        createGround(imageNumber: i)
      }
      
      // setup cat animation
      cat = createCat()
      catTextureArray.append(catAtlas.textureNamed("cat1"))
      catTextureArray.append(catAtlas.textureNamed("cat2"))
      catTextureArray.append(catAtlas.textureNamed("cat3"))
      catTextureArray.append(catAtlas.textureNamed("cat4"))

      self.addChild(cat)
      let animateCat = SKAction.animate(with: catTextureArray, timePerFrame: 0.1)
      repeatActionCat = SKAction.repeatForever(animateCat)

      // score
      scoreLbl = createScoreLabel()
      self.addChild(scoreLbl)
    }
  
    func createBackground(imageNumber: Int) {
      let backgroundTexture = SKTexture(imageNamed: "background")
      let background = SKSpriteNode(texture: backgroundTexture)
      background.setScale(0.7)
      background.zPosition = -30
      background.anchorPoint = CGPoint.zero
      background.position = CGPoint(x: (background.size.width * CGFloat(imageNumber)) - CGFloat(1 * imageNumber), y: 0)
      addChild(background)
      
      let moveLeft = SKAction.moveBy(x: -background.size.width, y: 0, duration: 30)
      let moveReset = SKAction.moveBy(x: background.size.width, y: 0, duration: 0)
      let moveLoop = SKAction.sequence([moveLeft, moveReset])
      let moveForever = SKAction.repeatForever(moveLoop)
      
      background.run(moveForever)
    }
  
    func createGround(imageNumber: Int) {
      //ground
      let groundTexture = SKTexture(imageNamed: "ground")
      ground = SKSpriteNode(texture: groundTexture)
      ground.setScale(0.7)
      ground.zPosition = -10
      ground.position = CGPoint(x: ground.size.width/2 + ground.size.width * CGFloat(imageNumber) , y: ground.size.height / 2)
      
      addChild(ground)
      
      let moveLeft = SKAction.moveBy(x: -ground.size.width, y: 0, duration: 5)
      let moveReset = SKAction.moveBy(x: ground.size.width, y: 0, duration: 0)
      let moveLoop = SKAction.sequence([moveLeft, moveReset])
      let moveForever = SKAction.repeatForever(moveLoop)
      
      ground.run(moveForever)
    }
  
    func spawnDeadlyObsticle () {
      if currentlyPlaying() {
        run(SKAction.repeatForever(
          SKAction.sequence([
            SKAction.run(groundObsticleAction),
            SKAction.wait(forDuration: TimeInterval(numberOfGroundObsticles))
            ])
        ))
        run(SKAction.repeatForever(
          SKAction.sequence([
            SKAction.run(flyingObsticleAction),
            SKAction.wait(forDuration: TimeInterval(numberOfFlyingObsticles))
            ])
        ))
      }
    }

    func groundObsticleAction() {
      groundObsticle = createGroundObsticle()
      addChild(groundObsticle)

      // speed of the obsticle, smaller duration, faster the obsticle
      let actualDuration = speedOfGroundObsticles
      let actionMove = SKAction.move(to: CGPoint(x: -groundObsticle.size.width/2, y: random(min: groundObsticle.size.height/2, max: 185)), duration: TimeInterval(actualDuration))
      print("\(groundObsticle.position), \(-groundObsticle.size.width/2), \(actualY), \(actualDuration), \(actionMove.speed)")

      let actionRemove = SKAction.removeFromParent()
      groundObsticle.run(SKAction.sequence([actionMove, actionRemove]))
    }

    func flyingObsticleAction() {
      flyingObsticle = createFlyingObsticle()
      addChild(flyingObsticle)

      let actualDuration = speedOfFlyingObsticles
      let actionMove = SKAction.move(to: CGPoint(x: -flyingObsticle.size.width/2, y: actualY), duration: TimeInterval(actualDuration))
      print("\(flyingObsticle.position), \(-flyingObsticle.size.width/2), \(actualY), \(actualDuration), \(actionMove.speed)")

      let actionRemove = SKAction.removeFromParent()
      flyingObsticle.run(SKAction.sequence([actionMove, actionRemove]))
    }

    func random(min : CGFloat, max : CGFloat) -> CGFloat{
      return random() * (max - min) + min
    }

    func random() -> CGFloat{
      return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }

    func endGame() {
      cat.physicsBody?.allowsRotation = true
      lostGame = true
      startedGame = false

      // death cat graphic
      catTextureArray.removeAll()
      cat.removeAllActions()
      cat.texture = SKTexture(imageNamed: "cat7.png")

      DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
        self.removeAllActions()
        self.displayRestartButton()
      }
    }

    func startGame() {
      isFlipped = false
      showReplayButton = false
      startedGame = true
      lostGame = false
      score = 0
      catTextureArray.removeAll()

      removeAllChildren()

      setupScoringAction()
      createScene()
      spawnDeadlyObsticle()
    }

    func setupScoringAction()  {
      let update = SKAction.run({self.levelUpGame()})
      let wait = SKAction.wait(forDuration: 3)
      let seq = SKAction.sequence([wait,update])
      let repeatAction = SKAction.repeatForever(seq)
      run(repeatAction)
    }
  
    func levelUpGame() {
      score += 1
      scoreLbl.text = String(score)
      // every 5th score flip gravity
      if (score % levelUpScore == 0) {
        isFlipped = !isFlipped
        if (!isFlipped) {
          speedOfGroundObsticles *= 0.9
          if speedOfGroundObsticles == 0 {
            print("YOU BIT THE GAME")
            endGame()
          }
        }
      }
      
    }
  
    override func didMove(to view: SKView) {
      startGame()
    }

    override func update(_ currentTime: TimeInterval) {
      if currentlyPlaying() {
        if (isFlipped) {
          physicsWorld.gravity = CGVector(dx: 0.0, dy: 9.8)
          cat.zRotation = CGFloat(Double.pi)
          cat.xScale = -1
        } else {
          physicsWorld.gravity = CGVector(dx: 0.0, dy: -9.8)
          cat.zRotation = 0
          cat.xScale = 1
        }
      }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
      // start game
      if !currentlyPlaying() {
        if (showReplayButton) {
          for touch in touches {
            if restartBtn.contains(touch.location(in: self)){
              startGame()
            }
          }
        }
      } else {
        // repeat cat animation
        cat.physicsBody?.affectedByGravity = true
        cat.run(repeatActionCat)
        if (isFlipped) {
          cat.physicsBody?.applyImpulse(CGVector(dx: 0, dy: -300))
        } else {
          cat.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 300))
      }
    }

    // MARK: - SKPhysicsContactDelegate

    func didBegin(_ contact: SKPhysicsContact) {
      // cat and obstacles touching
      let catTouchesObstacle = contact.bodyA.categoryBitMask == CollisionBitMask.catCategory && contact.bodyB.categoryBitMask == CollisionBitMask.obstacleCategory
      let obstacleTouchesCat = contact.bodyB.categoryBitMask == CollisionBitMask.catCategory && contact.bodyA.categoryBitMask == CollisionBitMask.obstacleCategory

      if (catTouchesObstacle || obstacleTouchesCat) {
        if currentlyPlaying() {
          print("DEATH")
          endGame()
        }
      } else {
        cat.removeAllActions()
      }
    }
  }
}
