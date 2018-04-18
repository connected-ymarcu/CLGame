//
//  GameScene.swift
//  CLGame
//
//  Created by cl-dev on 2018-04-18.
//  Copyright © 2018 cl-dev. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {

    // cat animation
    let catAtlas = SKTextureAtlas(named:"player")
    var catTextureArray = Array<SKTexture>()
    var cat = SKSpriteNode()
    var repeatActionCat = SKAction()

    let backgroundName = "background"

    func createScene(){

      // setup contacting with the edge and collisions
      self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)

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
      catTextureArray.append(catAtlas.textureNamed("bird1"))
      catTextureArray.append(catAtlas.textureNamed("bird2"))
      catTextureArray.append(catAtlas.textureNamed("bird3"))
      catTextureArray.append(catAtlas.textureNamed("bird4"))

      self.cat = createCat()
      self.addChild(cat)

      let animateCat = SKAction.animate(with: self.catTextureArray, timePerFrame: 0.1)
      self.repeatActionCat = SKAction.repeatForever(animateCat)

    }

    func didBegin(_ contact: SKPhysicsContact) {
        self.cat.removeAllActions()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.cat.run(repeatActionCat)
    }

    override func didMove(to view: SKView) {
        createScene()
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



}
