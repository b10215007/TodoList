//
//  UIView + Extension.swift
//  TodoList
//
//  Created by michael on 2018/9/6.
//  Copyright © 2018年 michael. All rights reserved.
//

import UIKit

@IBDesignable
extension UIView{

  @IBInspectable
  public var circleConrner: Bool{
    get{
      return min(bounds.size.width, bounds.size.height) / 2  == cornerRadius
    }
    set{
      cornerRadius = newValue ? min(bounds.size.width, bounds.size.height) / 2 : cornerRadius
    }
  }

  @IBInspectable
  public var cornerRadius: CGFloat{
    get{
      return layer.cornerRadius
    }
    set {
      layer.cornerRadius = circleConrner ? min(bounds.size.width, bounds.size.height) / 2 : newValue
    }
  }

  @IBInspectable
  /// Border color of view; also inspectable from Storyboard.
  public var borderColor: UIColor?{
    get {
      guard let color = layer.borderColor else{
        return nil
      }
      return UIColor(cgColor: color)
    }
    set {
      guard let color = newValue else{
        layer.borderColor = nil
        return
      }
      layer.borderColor = color.cgColor
    }
  }

  public var borderWidth: CGFloat {
    get {
      return layer.borderWidth
    }
    set {
      layer.borderWidth = newValue
    }
  }

  func rotate(_ toValue: CGFloat, duration: CFTimeInterval = 0.2){
    let animation = CABasicAnimation(keyPath: "transform.rotation")

    animation.toValue = toValue
    animation.duration = duration
    animation.isRemovedOnCompletion = false
    animation.fillMode = kCAFillModeForwards

    self.layer.add(animation, forKey: nil)
  }

}

