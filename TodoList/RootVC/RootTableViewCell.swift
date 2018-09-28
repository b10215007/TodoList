//
//  RootTableViewCell.swift
//  TodoList
//
//  Created by michael on 2018/9/10.
//  Copyright © 2018年 michael. All rights reserved.
//

import UIKit

class RootTableViewCell: UITableViewCell {

  static let identifier = "RootTableViewCell"

  let backgroundImage = UIImageView()
  let checkImage = UIImageView()
  let titleLabel = UILabel()
  let contentLabel = UILabel()

  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    self.backgroundColor = UIColor.clear
    initView()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func initView(){
    backgroundImage.translatesAutoresizingMaskIntoConstraints = false
    self.addSubview(backgroundImage)

    var constraints = [NSLayoutConstraint]()
    constraints.append(NSLayoutConstraint(item: backgroundImage, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 16))
    constraints.append(NSLayoutConstraint(item: backgroundImage, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 0))
    constraints.append(NSLayoutConstraint(item: backgroundImage, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: 0))
    constraints.append(NSLayoutConstraint(item: backgroundImage, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: -16))

    checkImage.layer.cornerRadius = 12
    checkImage.backgroundColor = UIColor.lightGray
    checkImage.translatesAutoresizingMaskIntoConstraints = false
    self.addSubview(checkImage)

    constraints.append(NSLayoutConstraint(item: checkImage, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
    constraints.append(NSLayoutConstraint(item: checkImage, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 12))
    constraints.append(NSLayoutConstraint(item: checkImage, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: 24))
    constraints.append(NSLayoutConstraint(item: checkImage, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 24))

    titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
    titleLabel.textColor = UIColor.black
    titleLabel.textAlignment = .left
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    self.addSubview(titleLabel)

    constraints.append(NSLayoutConstraint(item: titleLabel, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 0.64, constant: 0))
    constraints.append(NSLayoutConstraint(item: titleLabel, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
    constraints.append(NSLayoutConstraint(item: titleLabel, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 0.56, constant: 0))


    contentLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
    contentLabel.numberOfLines = 1
    contentLabel.textAlignment = .left
    contentLabel.textColor = UIColor.darkGray
    contentLabel.translatesAutoresizingMaskIntoConstraints = false
    self.addSubview(contentLabel)

    constraints.append(NSLayoutConstraint(item: contentLabel, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.28, constant: 0))
    constraints.append(NSLayoutConstraint(item: contentLabel, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
    constraints.append(NSLayoutConstraint(item: contentLabel, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 0.6, constant: 0))


    NSLayoutConstraint.activate(constraints)
  }

}
