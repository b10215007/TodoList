//
//  SettingsViewController.swift
//  TodoList
//
//  Created by michael on 2018/9/6.
//  Copyright © 2018年 michael. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

  let bannerView = BannerView()
  let tableView = UITableView()

  let titleArray = [
                    ["背景音樂","蕃茄鐘長度","休息時間"],
                    ["我的待辦事項","完成"]
                  ]

  let soundManager = SoundManager.shared()
  var timerIndex = 0
  var restIndex = 0
  let musicTypeArray = ["森林", "流水聲", "大自然"]
  let tomatoTimerArray = ["30分鐘", "20分鐘", "12分鐘", "8分鐘", "5分鐘"]
  let tomatoRestArray = ["12分鐘", "8分鐘", "5分鐘", "2分鐘", "1分鐘"]

  override func viewDidLoad() {
    super.viewDidLoad()
    initView()
    // Do any additional setup after loading the view.
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  func initView(){
    view.backgroundColor = UIColor.white
    initBannerImage()
    initIndex()
    initTableView()
  }

  func initBannerImage(){
    bannerView.backgroundImage.backgroundColor = UIColor.orange
    bannerView.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(bannerView)

    var constraints = [NSLayoutConstraint]()
    constraints.append(NSLayoutConstraint(item: bannerView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 0))
    constraints.append(NSLayoutConstraint(item: bannerView, attribute: .left, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1, constant: 0))
    constraints.append(NSLayoutConstraint(item: bannerView, attribute: .right, relatedBy: .equal, toItem: view, attribute: .right, multiplier: 1, constant: 0))
    constraints.append(NSLayoutConstraint(item: bannerView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 64))

    NSLayoutConstraint.activate(constraints)

    bannerView.backBtn.addTarget(self, action: #selector(backAction(_:)), for: .touchUpInside)
  }

  func initIndex() {
    if let value = UserDefaultsManager.get(key: .tomatoTime) as? Int {
      timerIndex = value
    }

    if let value = UserDefaultsManager.get(key: .restTime) as? Int {
      restIndex = value
    }
  }

  func initTableView(){
    tableView.dataSource = self
    tableView.delegate = self

    tableView.register(SettingsTableViewCell.self, forCellReuseIdentifier: SettingsTableViewCell.identifier)
    tableView.separatorStyle = .singleLineEtched
    tableView.backgroundColor = UIColor.clear
    tableView.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(tableView)

    var constraints = [NSLayoutConstraint]()
    constraints.append(NSLayoutConstraint(item: tableView, attribute: .top, relatedBy: .equal, toItem: bannerView, attribute: .bottom, multiplier: 1, constant: 0))
    constraints.append(NSLayoutConstraint(item: tableView, attribute: .left, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1, constant: 0))
    constraints.append(NSLayoutConstraint(item: tableView, attribute: .right, relatedBy: .equal, toItem: view, attribute: .right, multiplier: 1, constant: 0))
    constraints.append(NSLayoutConstraint(item: tableView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0))

    NSLayoutConstraint.activate(constraints)
  }


  @objc func backAction(_ sender: UIButton){
    self.navigationController?.popViewController(animated: false)
  }

  func addBottomPicker(_ titleArray: Array<String>, title: String){
    let picker = PickerView()
    picker.parentVC = self
    picker.title = title
    picker.titleArray = titleArray
    picker.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(picker)

    var constraints = [NSLayoutConstraint]()
    constraints.append(NSLayoutConstraint(item: picker, attribute: .left, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1, constant: 0))
    constraints.append(NSLayoutConstraint(item: picker, attribute: .right, relatedBy: .equal, toItem: view, attribute: .right, multiplier: 1, constant: 0))
    constraints.append(NSLayoutConstraint(item: picker, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0))
    constraints.append(NSLayoutConstraint(item: picker, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 150))

    NSLayoutConstraint.activate(constraints)
  }
}


extension SettingsViewController: UITableViewDataSource, UITableViewDelegate {

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

    return titleArray[section].count
  }

  func numberOfSections(in tableView: UITableView) -> Int {
    return 2
  }

  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let view = UIView()
    view.backgroundColor = UIColor.lightGray
    return view
  }

  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 30
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: SettingsTableViewCell.identifier, for: indexPath) as! SettingsTableViewCell
    let section = indexPath.section
    let index = indexPath.row

    cell.titleLabel.text = titleArray[section][index]
    if section == 0 {
      switch index {
      case 0:
        cell.valueLabel.text = musicTypeArray[soundManager.musicIndex]
      case 1:
        cell.valueLabel.text = tomatoTimerArray[timerIndex]
      default:
        cell.valueLabel.text = tomatoRestArray[restIndex]
      }
    }

    return cell
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let cell = tableView.cellForRow(at: indexPath) as! SettingsTableViewCell

    switch cell.titleLabel.text {
    case titleArray[0][0]:
      addBottomPicker(musicTypeArray,title: titleArray[0][0])
    case titleArray[0][1]:
      addBottomPicker(tomatoTimerArray,title: titleArray[0][1])
    case titleArray[0][2]:
      addBottomPicker(tomatoRestArray,title: titleArray[0][2])
    case titleArray[1][0]:
      let vc = MyTodoListViewController()
      self.navigationController?.pushViewController(vc, animated: false)
    default:
      print("Finished")
    }
  }
}
