//
//  UIImage + Extension.swift
//  TodoList
//
//  Created by michael on 2018/9/27.
//  Copyright © 2018年 michael. All rights reserved.
//

import UIKit
import QuartzCore
import CoreGraphics
import Accelerate

extension UIImage {

  static var shared: NSCache<AnyObject, AnyObject>! {
    struct StaticSharedCache {
      static var shared: NSCache<AnyObject, AnyObject>? = NSCache()
    }

    return StaticSharedCache.shared
  }


  class func image(fromURL url: String, placeHolder: UIImage, shoudCacheImage: Bool = true, closure: @escaping (_ image: UIImage?) -> ()) -> UIImage?{

    if shoudCacheImage {
      if let image = UIImage.shared.object(forKey: url as AnyObject) as? UIImage {
        closure(nil)
        return image
      }
    }
    //Fetch Image
    let session = URLSession(configuration: URLSessionConfiguration.default)
    if let nsUrl = URL(string: url) {
      session.dataTask(with: nsUrl) { (data, response, error) in
        if error != nil {
          DispatchQueue.main.async {
            closure(nil)
          }
        }

        if let data = data, let image = UIImage(data: data) {
          if shoudCacheImage {
            UIImage.shared.setObject(image, forKey: url as AnyObject)
          }
          DispatchQueue.main.async {
            closure(image)
          }
        }
        session.finishTasksAndInvalidate()
      }.resume()
    }

    return placeHolder
  }
}
