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

    // score
    var score = Int(0)
    var scoreLbl = SKLabelNode()

    // cat
    var cat = SKSpriteNode()
    let catAtlas = SKTextureAtlas(named:"player")
    var catTextureArray = Array<SKTexture>()
    var repeatActionCat = SKAction()

    // obstacle - rocks
    var groundObsticle = SKSpriteNode()
    var flyingObsticle = SKSpriteNode()


    // scene
    let backgroundName = "background"

    func currentlyPlaying () -> Bool {
      return startedGame && !lostGame
    }

    func createScene(){

      // setup contacting with the edge and collisions
      let edgeFrame = CGRect(
        origin: CGPoint(x: 0, y: 90),
        size: CGSize(width: self.frame.width, height: self.frame.height - 90)
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
        let background = SKSpriteNode(imageNamed: "bg")
        background.anchorPoint = CGPoint.init(x: 0, y: 0)
        background.position = CGPoint(x:CGFloat(i) * self.frame.width, y:0)
        background.name = backgroundName
        background.size = (self.view?.bounds.size)!
        self.addChild(background)
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

    func spawnDeadlyObsticle () {
      if currentlyPlaying() {
        run(SKAction.repeatForever(
          SKAction.sequence([
            SKAction.run(gourndObsticleAction),
            SKAction.wait(forDuration: TimeInterval(3))
            ])
        ))

        run(SKAction.repeatForever(
          SKAction.sequence([
            SKAction.run(flyingObsticleAction),
            SKAction.wait(forDuration: TimeInterval(2))
            ])
        ))
      }
    }

    func gourndObsticleAction() {
      groundObsticle = createGroundObsticle()
      addChild(groundObsticle)

      // speed of the obsticle, smaller duration, faster the obsticle
      let actualDuration = 3//random(min: CGFloat(1.0), max: CGFloat(6.0))
      let actionMove = SKAction.move(to: CGPoint(x: -groundObsticle.size.width/2, y: random(min: groundObsticle.size.height/2, max: 185)), duration: TimeInterval(actualDuration))
      print("\(groundObsticle.position), \(-groundObsticle.size.width/2), \(actualY), \(actualDuration), \(actionMove.speed)")

      let actionRemove = SKAction.removeFromParent()
      groundObsticle.run(SKAction.sequence([actionMove, actionRemove]))
    }

    func flyingObsticleAction() {
      flyingObsticle = createFlyingObsticle()
      addChild(flyingObsticle)

      let actualDuration = 1//random(min: CGFloat(1.0), max: CGFloat(6.0))
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
      let update = SKAction.run(
      {
        self.score += 1
        self.scoreLbl.text = String(self.score)
        }
      )
      let wait = SKAction.wait(forDuration: 3)
      let seq = SKAction.sequence([wait,update])
      let repeatAction = SKAction.repeatForever(seq)
      run(repeatAction)
    }

    override func didMove(to view: SKView) {
      startGame()
    }

    override func update(_ currentTime: TimeInterval) {
      if currentlyPlaying() {
        enumerateChildNodes(withName: backgroundName, using: ({
          (node, error) in
          let bg = node as! SKSpriteNode
          bg.position = CGPoint(x: bg.position.x - 2, y: bg.position.y)
          // once each image moves fully to the left so position.x is -414, set its position.x to 414
          if bg.position.x <= -bg.size.width {
            bg.position = CGPoint(x:bg.position.x + bg.size.width*2, y:bg.position.y)
          }
        }))
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
        cat.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
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
