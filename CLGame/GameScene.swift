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
    private var restartButton = SKSpriteNode()
    var startedGame = false
    var lostGame = false
    var isFlipped = false
    let levelUpScore = 2

    // score
    var score = Int(0)
    private var scoreLabel = SKLabelNode()

    // cat
    private var cat = SKSpriteNode()
    private var catTextureArray = Array<SKTexture>()
    private var repeatActionCat = SKAction()

    // scene
    var spaceShip = SKSpriteNode()
    private var beam = SKSpriteNode()
    private var star = SKSpriteNode()

    func currentlyPlaying () -> Bool {
      return startedGame && !lostGame
    }

    func setupNodes(){
      // Scene
      createScene()
      
      // SpaceShip
      spaceShip = createSpaceShip()
      addChild(spaceShip)
      
      // Cat
      cat = createCat()
      let catAtlas = SKTextureAtlas(named:"player")
      catTextureArray.append(catAtlas.textureNamed("cat1"))
      catTextureArray.append(catAtlas.textureNamed("cat2"))
      catTextureArray.append(catAtlas.textureNamed("cat3"))
      catTextureArray.append(catAtlas.textureNamed("cat4"))
      addChild(cat)
      let animateCat = SKAction.animate(with: catTextureArray, timePerFrame: 0.1)
      repeatActionCat = SKAction.repeatForever(animateCat)
      
      // Score
      scoreLabel = createScoreLabel()
      addChild(scoreLabel)
      scoreAction()
      
      // Obsticle
      spawnObsticle1()
      
      // Stars
      run(SKAction.repeatForever(
        SKAction.sequence([
          SKAction.run(starAction),
          SKAction.wait(forDuration: TimeInterval(1))
          ])
      ))
    }
  
    func createScene(){
      // setup contacting with the edges and collisions
      let edgeFrame = CGRect(
        origin: CGPoint(x: 0, y: 50),
        size: CGSize(width: frame.width, height: frame.height + 200)
      )
      physicsBody = SKPhysicsBody(edgeLoopFrom: edgeFrame)
      physicsBody?.categoryBitMask = CollisionBitMask.moonCategory
      physicsBody?.collisionBitMask = CollisionBitMask.catCategory
      physicsBody?.contactTestBitMask = CollisionBitMask.catCategory
      physicsWorld.contactDelegate = self
      physicsWorld.gravity = CGVector(dx: 0.0, dy: -9.8)
      
      // parallax endless scrolling background
      for i in 0..<2
      {
        setupSky(imageNumber: i)
        setupMountain(imageNumber: i)
        setupGround(imageNumber: i)
      }
    }
  
    // MARK - Parallax Endless Scrolling Background
  
    func setupSky(imageNumber: Int) {
      let sky = createSky(imageNumber)
      addChild(sky)
  
      let moveForever = SKAction.setupInfiniteScroll(imageWidth: sky.size.width, movingDuration: 30)
      sky.run(moveForever)
    }
  
    func setupMountain(imageNumber: Int) {
      let mountain = createMountain(imageNumber)
      addChild(mountain)

      let moveForever = SKAction.setupInfiniteScroll(imageWidth: mountain.size.width, movingDuration: 15)
      mountain.run(moveForever)
    }

    func setupGround(imageNumber: Int) {
      let ground = createGround(imageNumber)
      addChild(ground)
      
      let moveForever = SKAction.setupInfiniteScroll(imageWidth: ground.size.width, movingDuration: 7)
      ground.run(moveForever)
    }

    // MARK - Spawn Obsticles
  
    // obsticle 1
    var numObsticle1: Double = 3 // the lower, the more obsticles show up
    var speedOfObsticle1: Double  = 4  // the lower, the faster obsticles move
    // obsticle 2
    var numOfObsticle2: Double  = 2
    var speedOfObsticle2: Double = 2
    // obsticle 3
    var numOfObsticle3: Double = 1
    var speedOfObsticle3: Double  = 1
  
    func spawnObsticle1 () {
      run(SKAction.repeatForever(
        SKAction.sequence([
          SKAction.run(obsticleAction1),
          SKAction.wait(forDuration: TimeInterval(numObsticle1))
          ])
      ))
    }

    func spawnObsticle2 () {
      run(SKAction.repeatForever(
        SKAction.sequence([
          SKAction.run(obsticleAction2),
          SKAction.wait(forDuration: TimeInterval(numOfObsticle2))
          ])
      ))
    }

    func spawnObsticle3 () {
      run(SKAction.repeatForever(
        SKAction.sequence([
          SKAction.run(obsticleAction3),
          SKAction.wait(forDuration: TimeInterval(numOfObsticle3))
          ])
      ))
    }

    func obsticleAction1() {
      let obsticle1 = createObsticle1()
      addChild(obsticle1)

      let actionMove = SKAction.move(to: CGPoint(x: -obsticle1.size.width/2, y: randomY1), duration: TimeInterval(speedOfObsticle1))
      let actionRemove = SKAction.removeFromParent()
      obsticle1.run(SKAction.sequence([actionMove, actionRemove]))
    }

    func obsticleAction2() {
      let obsticle2 = createObsticle2()
      addChild(obsticle2)

      let actionMove = SKAction.move(to: CGPoint(x: -obsticle2.size.width/2, y: randomY2), duration: TimeInterval(speedOfObsticle2))
      let actionRemove = SKAction.removeFromParent()
      obsticle2.run(SKAction.sequence([actionMove, actionRemove]))
    }

    func obsticleAction3() {
      let obsticle3 = createObsticle3()
      addChild(obsticle3)

      let actionMove = SKAction.move(to: CGPoint(x: -obsticle3.size.width/2, y: randomY3), duration: TimeInterval(speedOfObsticle3))
      let actionRemove = SKAction.removeFromParent()
      obsticle3.run(SKAction.sequence([actionMove, actionRemove]))
    }
  
    // MARK - other nodes
  
    func starAction() {
      star = createStar()
      addChild(star)
      let scale = SKAction.scale(to: 0.1, duration: 0.5)
      let actionRemove = SKAction.removeFromParent()
      star.run(SKAction.sequence([scale, SKAction.fadeOut(withDuration: 0.5), actionRemove]))
    }
  
    func scoreAction()  {
      let update = SKAction.run({[weak self] in
        self?.levelUpGame()
      })
      let wait = SKAction.wait(forDuration: 3)
      let seq = SKAction.sequence([wait,update])
      let repeatAction = SKAction.repeatForever(seq)
      run(repeatAction)
    }
  
    // MARK - Game Loop
  
    func startGame() {
      // reset states
      isFlipped = false
      showReplayButton = false
      startedGame = true
      lostGame = false
      score = 0
      speedOfObsticle1 = 3
      catTextureArray.removeAll()
      removeAllChildren()
      
      setupNodes()
    }
  
    func levelUpGame() {
      score += 1
      scoreLabel.text = "\(score)"

      if (score == levelUpScore*2) {
        spawnObsticle2()
      } else if (score == levelUpScore*4){
        spawnObsticle3()
      }

      // every levelUpScoreTH score flip gravity
      if (score % levelUpScore == 0) {
        isFlipped = !isFlipped
        if (!isFlipped) {
          speedOfObsticle1 *= 0.9
          if speedOfObsticle1 == 0 {
            print("YOU BIT THE GAME")
            endGame()
          }
          // fade out beam
          beam.run(SKAction.sequence([SKAction.scale(to: 0.01, duration: 1), SKAction.fadeOut(withDuration: 0.5)]), completion: {
            self.spaceShip.removeAllChildren()
          })
        } else {
          // fade In beam
          beam = createBeam()
          spaceShip.addChild(beam)
          beam.run(SKAction.sequence([SKAction.scale(to: 2, duration: 2), SKAction.fadeIn(withDuration: 0.5)]))
        }
      }
    }
  
    func endGame() {
      // death sound
      run(SKAction.playSoundFileNamed("OhNo1.mp3", waitForCompletion: true))
      
      // save the highest score
      if (score > UserDefaults.standard.integer(forKey: "highestScore")) {
        UserDefaults.standard.set(score, forKey: "highestScore")
      }
      
      // reset states
      lostGame = true
      startedGame = false
      
      // death cat graphic
      cat.physicsBody?.allowsRotation = true
      catTextureArray.removeAll()
      cat.removeAllActions()
      cat.texture = SKTexture(imageNamed: "cat7.png")
      
      // display restart
      DispatchQueue.main.asyncAfter(deadline: .now() + 2) {[weak self] in
        self?.removeAllActions()
        self?.restartButton = (self?.createRestartButton())!
        self?.addChild((self?.restartButton)!)
        self?.restartButton.run(SKAction.scale(to: 1.0, duration: 0.3))
        showReplayButton = true
      }
    }
  
    // MARK - override functions
  
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
            if restartButton.contains(touch.location(in: self)){
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
    }
  
    // MARK: - SKPhysicsContactDelegate

    func didBegin(_ contact: SKPhysicsContact) {
      // cat and obstacles touching
      let catTouchesObstacle = contact.bodyA.categoryBitMask == CollisionBitMask.catCategory && contact.bodyB.categoryBitMask == CollisionBitMask.obstacleCategory
      let obstacleTouchesCat = contact.bodyB.categoryBitMask == CollisionBitMask.catCategory && contact.bodyA.categoryBitMask == CollisionBitMask.obstacleCategory

      if (catTouchesObstacle || obstacleTouchesCat ) {
        if currentlyPlaying() {
          print("DEATH")
          endGame()
        }
      } else {
        cat.removeAllActions()
      }
    }
      
}
