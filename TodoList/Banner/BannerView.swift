//
//  BannerView.swift
//  TodoList
//
//  Created by michael on 2018/9/9.
//  Copyright © 2018年 michael. All rights reserved.
//

import UIKit

class BannerView: UIView {

  let backgroundImage = UIImageView()
  let backBtn = UIButton()
  let label = UILabel()

  let font = UIFont.systemFont(ofSize: 24, weight: .medium)

  override init(frame: CGRect) {
    super.init(frame: frame)
    initView()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func initView(){
    backgroundImage.backgroundColor = UIColor.black
    backgroundImage.translatesAutoresizingMaskIntoConstraints = false
    self.addSubview(backgroundImage)

    var constraints = [NSLayoutConstraint]()
    constraints.append(NSLayoutConstraint(item: backgroundImage, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0))
    constraints.append(NSLayoutConstraint(item: backgroundImage, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 0))
    constraints.append(NSLayoutConstraint(item: backgroundImage, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: 0))
    constraints.append(NSLayoutConstraint(item: backgroundImage, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0))

    backBtn.setBackgroundImage(#imageLiteral(resourceName: "button_back"), for: .normal)
    backBtn.translatesAutoresizingMaskIntoConstraints = false
    self.addSubview(backBtn)

    constraints.append(NSLayoutConstraint(item: backBtn, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
    constraints.append(NSLayoutConstraint(item: backBtn, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 24))
    constraints.append(NSLayoutConstraint(item: backBtn, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: 32))
    constraints.append(NSLayoutConstraint(item: backBtn, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 28))

    label.text = ""
    label.font = font
    label.textColor = UIColor.white
    label.translatesAutoresizingMaskIntoConstraints = false
    self.addSubview(label)

    constraints.append(NSLayoutConstraint(item: label, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
    constraints.append(NSLayoutConstraint(item: label, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))

    NSLayoutConstraint.activate(constraints)
  }

}
