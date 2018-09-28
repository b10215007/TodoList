//
//  SettingsTableViewCell.swift
//  TodoList
//
//  Created by michael on 2018/9/7.
//  Copyright © 2018年 michael. All rights reserved.
//

import UIKit

class SettingsTableViewCell: UITableViewCell {

  static let identifier = "SettingsTableViewCell"

  let titleLabel = UILabel()
  let valueLabel = UILabel()

  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    initCell()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func initCell(){
    titleLabel.font = UIFont.systemFont(ofSize: 24, weight: .medium)
    titleLabel.textColor = UIColor.black
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    self.addSubview(titleLabel)

    var constraints = [NSLayoutConstraint]()
    constraints.append(NSLayoutConstraint(item: titleLabel, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
    constraints.append(NSLayoutConstraint(item: titleLabel, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 16))

    valueLabel.font = UIFont.systemFont(ofSize: 22, weight: .medium)
    valueLabel.textColor = UIColor.gray
    valueLabel.translatesAutoresizingMaskIntoConstraints = false
    self.addSubview(valueLabel)

    constraints.append(NSLayoutConstraint(item: valueLabel, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
    constraints.append(NSLayoutConstraint(item: valueLabel, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: -16))


    NSLayoutConstraint.activate(constraints)
  }

  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }

}
