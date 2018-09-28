//
//  HeaderTapViewController.swift
//  TomatoTimerPro
//
//  Created by michael on 2018/4/3.
//  Copyright © 2018年 michael. All rights reserved.
//

import UIKit

protocol CollapsibleTableViewHeaderDelegate {
  func toggleSelection(_ header: CollapsibleTableViewHeader, section: Int)
}

class CollapsibleTableViewHeader: UITableViewHeaderFooterView {

  var delegate : CollapsibleTableViewHeaderDelegate?
  var section = 0

  let menuImage = UIImageView()
  let titleLabel = UILabel()
  let arrowLabel = UILabel()

  override init(reuseIdentifier: String?) {
    super.init(reuseIdentifier: reuseIdentifier)

    //ContentView
    contentView.backgroundColor = UIColor.black

    let marginGuide = contentView.layoutMarginsGuide

    //menuImage
    contentView.addSubview(menuImage)
    menuImage.image = UIImage(named: "menu")
    menuImage.translatesAutoresizingMaskIntoConstraints = false
    menuImage.topAnchor.constraint(equalTo: marginGuide.topAnchor).isActive = true
    menuImage.bottomAnchor.constraint(equalTo: marginGuide.bottomAnchor).isActive = true
    menuImage.leadingAnchor.constraint(equalTo: marginGuide.leadingAnchor).isActive = true
    menuImage.widthAnchor.constraint(equalToConstant: 24).isActive = true

    //ArrowLabel
    contentView.addSubview(arrowLabel)
    arrowLabel.textColor = UIColor.white
    arrowLabel.translatesAutoresizingMaskIntoConstraints = false
    arrowLabel.widthAnchor.constraint(equalToConstant: 12).isActive = true
    arrowLabel.topAnchor.constraint(equalTo: marginGuide.topAnchor).isActive = true
    arrowLabel.trailingAnchor.constraint(equalTo: marginGuide.trailingAnchor).isActive = true
    arrowLabel.bottomAnchor.constraint(equalTo: marginGuide.bottomAnchor).isActive = true
    arrowLabel.font = UIFont.systemFont(ofSize: 18)

    // Title label
    contentView.addSubview(titleLabel)
    titleLabel.textColor = UIColor.white
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    titleLabel.topAnchor.constraint(equalTo: marginGuide.topAnchor).isActive = true
    titleLabel.trailingAnchor.constraint(equalTo: arrowLabel.leadingAnchor).isActive = true
    titleLabel.bottomAnchor.constraint(equalTo: marginGuide.bottomAnchor).isActive = true
    titleLabel.leadingAnchor.constraint(equalTo: menuImage.trailingAnchor, constant: 8).isActive = true

    //
    // Call the TapHeader when tap on this header
    //
    addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(CollapsibleTableViewHeader.tapHeader(_ :))))
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  //
  // Trigger toggle section when tapping on the header
  //
  @objc func tapHeader(_ gestureRecognizer: UITapGestureRecognizer){
    guard let cell = gestureRecognizer.view as? CollapsibleTableViewHeader else {
      return
    }

    delegate?.toggleSelection(self, section: cell.section)
  }

  func setCollapsed(_ collapsed: Bool){
    arrowLabel.rotate(collapsed ? 0.0 : .pi / 2)
  }



}
