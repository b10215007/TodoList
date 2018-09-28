//
//  UIImageView + Extension.swift
//  TodoList
//
//  Created by michael on 2018/9/27.
//  Copyright © 2018年 michael. All rights reserved.
//

import UIKit
import QuartzCore

extension UIImageView {

  func imageFromURL(_ url: String, placeholder: UIImage, fadeIn: Bool = true, shouldChcheImage: Bool = true, closure: ((_ image: UIImage?) -> ())? = nil ) {
    self.image = UIImage.image(fromURL: url, placeHolder: placeholder, shoudCacheImage: shouldChcheImage){ (image: UIImage?) in
      if image == nil {
        return
      }
      self.image = image
      if fadeIn {
        let transition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        transition.type = kCATransitionFade
        self.layer.add(transition, forKey: nil)
      }
      closure?(image)
    }
  }
}
