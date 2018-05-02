//
//  SKAction+Helper.swift
//  CLGame
//
//  Created by Yas Abdolmaleki on 2018-05-02.
//  Copyright © 2018 cl-dev. All rights reserved.
//

import SpriteKit

public extension SKAction {
  public class func setupInfiniteScroll(imageWidth: CGFloat, movingDuration: CFTimeInterval) -> SKAction {
    let moveLeft = SKAction.moveBy(x: -imageWidth, y: 0, duration: movingDuration)
    let moveReset = SKAction.moveBy(x: imageWidth, y: 0, duration: 0)
    let moveLoop = SKAction.sequence([moveLeft, moveReset])
    return SKAction.repeatForever(moveLoop)
  }
}
