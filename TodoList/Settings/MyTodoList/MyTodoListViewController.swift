//
//  MyTodoListViewController.swift
//  TodoList
//
//  Created by michael on 2018/9/9.
//  Copyright © 2018年 michael. All rights reserved.
//

import UIKit

class MyTodoListViewController: UIViewController {

  let bannerView = BannerView()
  let tableView = UITableView()

  var allTodoList = [TodoItem]()
  var workTodoList = [TodoItem]()
  var offWorkTodoList = [TodoItem]()
  var datingTodoList = [TodoItem]()

  let dataManager = CoreDataManager()
  let titleArray = ["All", "工作", "下班出去玩", "朋友家人聚想"]
  var collapsedArray = [false, false, false, false]

  override func viewDidLoad() {
    super.viewDidLoad()

    initView()
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  func initView(){
    view.backgroundColor = UIColor.white
    addBanner()
    initTableView()
  }

  func addBanner(){
    bannerView.backgroundImage.backgroundColor = UIColor.black
    bannerView.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(bannerView)

    var constraints = [NSLayoutConstraint]()
    constraints.append(NSLayoutConstraint(item: bannerView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 0))
    constraints.append(NSLayoutConstraint(item: bannerView, attribute: .left, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1, constant: 0))
    constraints.append(NSLayoutConstraint(item: bannerView, attribute: .right, relatedBy: .equal, toItem: view, attribute: .right, multiplier: 1, constant: 0))
    constraints.append(NSLayoutConstraint(item: bannerView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 56))

    NSLayoutConstraint.activate(constraints)

    bannerView.backBtn.addTarget(self, action: #selector(backAction(_:)), for: .touchUpInside)
  }

  func initTableView(){
    tableView.delegate = self
    tableView.dataSource = self

    tableView.register(CollapsibleTableViewCell.self, forCellReuseIdentifier: CollapsibleTableViewCell.identifier)
    tableView.separatorStyle = .singleLineEtched
    tableView.backgroundColor = UIColor.clear
    tableView.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(tableView)

    var constraints = [NSLayoutConstraint]()
    constraints.append(NSLayoutConstraint(item: tableView, attribute: .top, relatedBy: .equal, toItem: bannerView, attribute: .bottom, multiplier: 1, constant: 5))
    constraints.append(NSLayoutConstraint(item: tableView, attribute: .left, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1, constant: 0))
    constraints.append(NSLayoutConstraint(item: tableView, attribute: .right, relatedBy: .equal, toItem: view, attribute: .right, multiplier: 1, constant: 0))
    constraints.append(NSLayoutConstraint(item: tableView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0))

    NSLayoutConstraint.activate(constraints)
    fetchAndSetTodoList()
  }

  func fetchAndSetTodoList(){
    allTodoList = dataManager.retrieve("TodoItem", predicate: nil, limit: nil) as! [TodoItem]
    workTodoList = dataManager.retrieve("TodoItem", predicate: "work", limit: nil) as! [TodoItem]
    offWorkTodoList = dataManager.retrieve("TodoItem", predicate: "offWork", limit: nil) as! [TodoItem]
    datingTodoList = dataManager.retrieve("TodoItem", predicate: "dating", limit: nil) as! [TodoItem]

    tableView.reloadData()
  }

  @objc func backAction(_ sender: UIButton) {
    self.navigationController?.popViewController(animated: false)
  }

}

extension MyTodoListViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch section {
    case 0:
      return collapsedArray[0] ? 0 : allTodoList.count
    case 1:
      return collapsedArray[1] ? 0 : workTodoList.count
    case 2:
      return collapsedArray[2] ? 0 : offWorkTodoList.count
    default:
      return collapsedArray[3] ? 0 : datingTodoList.count
    }
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: CollapsibleTableViewCell.identifier, for: indexPath) as! CollapsibleTableViewCell
    let section = indexPath.section
    let index = indexPath.row

    switch section {
    case 0:
      cell.nameLabel.text = allTodoList[index].title
      cell.detailLabel.text = allTodoList[index].content
    case 1:
      cell.nameLabel.text = workTodoList[index].title
      cell.detailLabel.text = workTodoList[index].content
    case 2:
      cell.nameLabel.text = offWorkTodoList[index].title
      cell.detailLabel.text = offWorkTodoList[index].content
    default:
      cell.nameLabel.text = datingTodoList[index].title
      cell.detailLabel.text = datingTodoList[index].content
    }

    return cell
  }

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableViewAutomaticDimension
  }

  func numberOfSections(in tableView: UITableView) -> Int {
    return titleArray.count
  }

  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header") as? CollapsibleTableViewHeader ??
      CollapsibleTableViewHeader(reuseIdentifier: "header")

    header.titleLabel.text = titleArray[section]
    header.arrowLabel.text = ">"
    header.setCollapsed(collapsedArray[section])

    header.section = section
    header.delegate = self

    return header
  }

  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 48
  }

  func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    return 12
  }

  func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
    let view = UIView()
    view.backgroundColor = UIColor.white
    return view
  }

  
}

extension MyTodoListViewController: CollapsibleTableViewHeaderDelegate {
  func toggleSelection(_ header: CollapsibleTableViewHeader, section: Int) {
    let collapsed = !collapsedArray[section]

    collapsedArray[section] = collapsed
    header.setCollapsed(collapsed)

    tableView.reloadSections(NSIndexSet(index: section) as IndexSet, with: .automatic)
  }
}
