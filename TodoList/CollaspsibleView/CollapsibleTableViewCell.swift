//
//  CollapsibleTableViewCell.swift
//  TomatoTimerPro
//
//  Created by michael on 2018/4/3.
//  Copyright © 2018年 michael. All rights reserved.
//

import UIKit

class CollapsibleTableViewCell: UITableViewCell {
  static let identifier = "CollapsibleTableViewCell"

  let nameLabel = UILabel()
  let detailLabel = UILabel()

  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)

    let marginGuide = contentView.layoutMarginsGuide

    contentView.addSubview(nameLabel)
    nameLabel.translatesAutoresizingMaskIntoConstraints = false
    nameLabel.leadingAnchor.constraint(equalTo: marginGuide.leadingAnchor).isActive = true
    nameLabel.topAnchor.constraint(equalTo: marginGuide.topAnchor).isActive = true
    nameLabel.trailingAnchor.constraint(equalTo: marginGuide.trailingAnchor).isActive = true
    nameLabel.numberOfLines = 0
    nameLabel.font = UIFont.systemFont(ofSize: 16)

    contentView.addSubview(detailLabel)
    detailLabel.translatesAutoresizingMaskIntoConstraints = false
    detailLabel.leadingAnchor.constraint(equalTo: marginGuide.leadingAnchor).isActive = true
    detailLabel.bottomAnchor.constraint(equalTo: marginGuide.bottomAnchor).isActive = true
    detailLabel.trailingAnchor.constraint(equalTo: marginGuide.trailingAnchor).isActive = true
    detailLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5).isActive = true
    detailLabel.numberOfLines = 0
    detailLabel.font = UIFont.systemFont(ofSize: 12)
    detailLabel.textColor = UIColor.lightGray
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }



  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }

  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)

    // Configure the view for the selected state
  }

}
