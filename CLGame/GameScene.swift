//
//  GameScene.swift
//  CLGame
//
//  Created by cl-dev on 2018-04-18.
//  Copyright © 2018 cl-dev. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {

    let backgroundName = "background"
    func createScene(){
      // create 2 background image side by side
      for i in 0..<2
      {
        let background = SKSpriteNode(imageNamed: "bg")
        background.anchorPoint = CGPoint.init(x: 0, y: 0)
        background.position = CGPoint(x:CGFloat(i) * self.frame.width, y:0)
        background.name = backgroundName
        background.size = (self.view?.bounds.size)!
        self.addChild(background)
      }
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
