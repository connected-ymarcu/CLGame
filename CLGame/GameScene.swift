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

    // cat animation
    let catAtlas = SKTextureAtlas(named:"player")
    var catTextureArray = Array<SKTexture>()
    var cat = SKSpriteNode()
    var repeatActionCat = SKAction()

    // obstacle - rocks
    var rockParentNode = SKNode()
    var moveAndRemoveRocks = SKAction()

    // scene
    let backgroundName = "background"

    func createScene(){

      // setup contacting with the edge and collisions
      let edgeFrame = CGRect(
        origin: CGPoint(x: 0, y: 90),
        size: CGSize(width: self.frame.width, height: self.frame.height - 90)
      )
      self.physicsBody = SKPhysicsBody(edgeLoopFrom: edgeFrame)
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
      catTextureArray.append(catAtlas.textureNamed("Cat1"))
      catTextureArray.append(catAtlas.textureNamed("Cat2"))
      catTextureArray.append(catAtlas.textureNamed("Cat3"))
      catTextureArray.append(catAtlas.textureNamed("Cat4"))

      self.addChild(cat)
      let animateCat = SKAction.animate(with: catTextureArray, timePerFrame: 0.1)
      repeatActionCat = SKAction.repeatForever(animateCat)
    }

    func addDeadlyObsticle() {

      let obsticle = SKSpriteNode(imageNamed: "flag")

      // randomize x and y position
      let actualY =  random(min: obsticle.size.height/2, max: 185)
      let actualX = random(min: size.width + obsticle.size.width/2, max: size.width*3 )
      obsticle.position = CGPoint(x: actualX, y: actualY)

      addChild(obsticle)

      // Determine speed of the rock
      let actualDuration = 8 //random(min: CGFloat(2.0), max: CGFloat(4.0))
      let actionMove = SKAction.move(to: CGPoint(x: -obsticle.size.width/2, y: actualY), duration: TimeInterval(actualDuration))
      let actionRemove = SKAction.removeFromParent()
      obsticle.run(SKAction.sequence([actionMove, actionRemove]))

    }

    func random(min : CGFloat, max : CGFloat) -> CGFloat{
      return random() * (max - min) + min
    }

    func random() -> CGFloat{
      return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }

    override func didMove(to view: SKView) {
      createScene()

      // spawn deadly things
      run(SKAction.repeatForever(
        SKAction.sequence([
          SKAction.run(addDeadlyObsticle),
          SKAction.wait(forDuration: TimeInterval(3))
          ])
      ))
    }

    override func update(_ currentTime: TimeInterval) {
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

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
      // cat action
      cat.physicsBody?.affectedByGravity = true
      cat.run(repeatActionCat)
      cat.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
      cat.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 250))
    }

    // MARK: - SKPhysicsContactDelegate

    func didBegin(_ contact: SKPhysicsContact) {
      cat.removeAllActions()
    }

}
