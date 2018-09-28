//
//  PickerView.swift
//  TodoList
//
//  Created by michael on 2018/9/10.
//  Copyright © 2018年 michael. All rights reserved.
//

import UIKit

class PickerView: UIPickerView {

  weak var parentVC: SettingsViewController?
  let coverView = UIView()

  let topView = UIView()
  let cancelButton = UIButton()
  var title = ""
  var titleArray = ["30分鐘", "20分鐘", "12分鐘", "8分鐘", "5分鐘"]

  let soundManager = SoundManager.shared()

  override init(frame: CGRect) {
    super.init(frame: frame)
    initView()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func initView(){

    initTopView()
    self.backgroundColor = UIColor.white
    self.dataSource = self
    self.delegate = self
  }

  func initTopView(){
    topView.layer.cornerRadius = 8
    topView.backgroundColor = UIColor.cyan
    topView.translatesAutoresizingMaskIntoConstraints = false
    self.addSubview(topView)

    var constraints = [NSLayoutConstraint]()
    constraints.append(NSLayoutConstraint(item: topView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0))
    constraints.append(NSLayoutConstraint(item: topView, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 0))
    constraints.append(NSLayoutConstraint(item: topView, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: 0))
    constraints.append(NSLayoutConstraint(item: topView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 36))

    cancelButton.setBackgroundImage(#imageLiteral(resourceName: "button_cancel"), for: .normal)
    cancelButton.addTarget(self, action: #selector(cancelAction(_:)), for: .touchUpInside)
    cancelButton.translatesAutoresizingMaskIntoConstraints = false
    topView.addSubview(cancelButton)

    constraints.append(NSLayoutConstraint(item: cancelButton, attribute: .centerY, relatedBy: .equal, toItem: topView, attribute: .centerY, multiplier: 1, constant: 0))
    constraints.append(NSLayoutConstraint(item: cancelButton, attribute: .right, relatedBy: .equal, toItem: topView, attribute: .right, multiplier: 1, constant: -8))
    constraints.append(NSLayoutConstraint(item: cancelButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: 28))
    constraints.append(NSLayoutConstraint(item: cancelButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 28))

    NSLayoutConstraint.activate(constraints)
  }

  func getUserInfoKeyAndSet(index: Int) -> UserInfoKey {
    switch title {
    case "背景音樂":
      soundManager.musicIndex = index
      return .musicType
    case "蕃茄鐘長度":
      parentVC?.timerIndex = index
      return .tomatoTime
    default:
      parentVC?.restIndex = index
      return .restTime
    }
  }

  func saveAndExit(index: Int){
    UserDefaultsManager.set(value: index, key: getUserInfoKeyAndSet(index: index))
    parentVC?.tableView.reloadData()
    self.removeFromSuperview()
  }

  @objc func cancelAction(_ sender: UIButton){
    self.removeFromSuperview()
  }
}

extension PickerView: UIPickerViewDelegate, UIPickerViewDataSource {
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }

  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return titleArray.count
  }

  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    return titleArray[row]
  }

  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    saveAndExit(index: row)
  }
}
