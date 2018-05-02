//
//  Utilities.swift
//  CLGame
//
//  Created by Yas Abdolmaleki on 2018-05-02.
//  Copyright © 2018 cl-dev. All rights reserved.
//

import Foundation
import UIKit

class Helper {
  static func random(min : CGFloat, max : CGFloat) -> CGFloat{
    return random() * (max - min) + min
  }
  
  static func random() -> CGFloat{
    return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
  }
}
