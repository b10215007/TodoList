//
//  ViewController.swift
//  TodoList
//
//  Created by michael on 2018/9/6.
//  Copyright © 2018年 michael. All rights reserved.
//

import UIKit

class RootViewController: UIViewController {

  let settingsBtn = UIButton()
  let addTodoBtn = UIButton()
  let musicBtn = UIButton()

  let backgroundImage = UIImageView()

  let tomatoTimerView = TomatoTimerView()

  let tableView = UITableView()
  var todoList = [TodoItem]()

  let segment = UISegmentedControl()

  let soundManager = SoundManager.shared()
  let coreDataManager = CoreDataManager()

  let shapeLayer = CAShapeLayer()
  let circle = UIView()

  override func viewDidLoad() {
    super.viewDidLoad()
    
    soundManager.configure()

    initView()

    let longPressed = UILongPressGestureRecognizer(target: self, action: #selector(longPressedHandler(sender:)))
    longPressed.minimumPressDuration = 0.5
    tomatoTimerView.addGestureRecognizer(longPressed)
  }

  @objc func longPressedHandler(sender: UILongPressGestureRecognizer){
    if tomatoTimerView.workState == .rest || tomatoTimerView.workState == .begin {
      if sender.state == .began {
        let location = sender.location(in: tomatoTimerView)

        addCircle(center: location)
        let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.toValue = 12
        animation.duration = 1.5
        animation.delegate = self
        circle.layer.add(animation, forKey: animation.keyPath)

      }

      if sender.state == .ended {
        circle.removeFromSuperview()
      }
    }
  }

  func addCircle(center: CGPoint){
    circle.frame = CGRect(x: center.x - 60, y: center.y - 60, width: 120, height: 120)
    circle.alpha = 0.7
    circle.layer.cornerRadius = circle.frame.width / 2
    circle.backgroundColor = tomatoTimerView.workState == .rest ? UIColor(rgb: 0x213682) : UIColor(rgb: 0x90D4D0)
    tomatoTimerView.addSubview(circle)
  }

  //  func drawCircle(center: CGPoint){
  //    let radius:CGFloat = 60
  //    let startAngle: CGFloat = 0
  //    let endAngle = CGFloat.pi * 2
  //    let path = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
  //    shapeLayer.path = path.cgPath
  //    shapeLayer.fillColor = UIColor(rgb: 0x213682).cgColor
  //    shapeLayer.strokeColor = UIColor.clear.cgColor
  //
  //    tomatoTimerView.layer.addSublayer(shapeLayer)
  //  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  func initView(){
    initCenterLayout()
    initTableView()
    initTopButton()
    initSegmentControl()
  }

  func initCenterLayout(){
    backgroundImage.backgroundColor = UIColor.yellow
    backgroundImage.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(backgroundImage)

    var constraints = [NSLayoutConstraint]()
    constraints.append(NSLayoutConstraint(item: backgroundImage, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 0))
    constraints.append(NSLayoutConstraint(item: backgroundImage, attribute: .left, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1, constant: 0))
    constraints.append(NSLayoutConstraint(item: backgroundImage, attribute: .right, relatedBy: .equal, toItem: view, attribute: .right, multiplier: 1, constant: 0))
    constraints.append(NSLayoutConstraint(item: backgroundImage, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0))

    tomatoTimerView.backgroundColor = UIColor.clear
    tomatoTimerView.startPauseBtn.addTarget(self, action: #selector(startPauseBtnAction(_:)), for: .touchUpInside)
    tomatoTimerView.ParentVC = self
    tomatoTimerView.workStateHandler()
    tomatoTimerView.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(tomatoTimerView)

    constraints.append(NSLayoutConstraint(item: tomatoTimerView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 0))
    constraints.append(NSLayoutConstraint(item: tomatoTimerView, attribute: .left, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1, constant: 0))
    constraints.append(NSLayoutConstraint(item: tomatoTimerView, attribute: .right, relatedBy: .equal, toItem: view, attribute: .right, multiplier: 1, constant: 0))
    constraints.append(NSLayoutConstraint(item: tomatoTimerView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0))

    NSLayoutConstraint.activate(constraints)
  }

  func initTopButton(){
    settingsBtn.setBackgroundImage(#imageLiteral(resourceName: "menu"), for: .normal)
    settingsBtn.addTarget(self, action: #selector(btnAcion(_:)), for: .touchUpInside)
    settingsBtn.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(settingsBtn)

    var constraints = [NSLayoutConstraint]()
    constraints.append(NSLayoutConstraint(item: settingsBtn, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 24))
    constraints.append(NSLayoutConstraint(item: settingsBtn, attribute: .left, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1, constant: 24))
    constraints.append(NSLayoutConstraint(item: settingsBtn, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: 40))
    constraints.append(NSLayoutConstraint(item: settingsBtn, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 40))

    musicBtn.setBackgroundImage( soundManager.musicIsOn ? #imageLiteral(resourceName: "music_on") : #imageLiteral(resourceName: "music_off"), for: .normal)
    musicBtn.addTarget(self, action: #selector(btnAcion(_:)), for: .touchUpInside)
    musicBtn.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(musicBtn)

    constraints.append(NSLayoutConstraint(item: musicBtn, attribute: .centerY, relatedBy: .equal, toItem: settingsBtn, attribute: .centerY, multiplier: 1, constant: 0))
    constraints.append(NSLayoutConstraint(item: musicBtn, attribute: .right, relatedBy: .equal, toItem: view, attribute: .right, multiplier: 1, constant: -24))
    constraints.append(NSLayoutConstraint(item: musicBtn, attribute: .width, relatedBy: .equal, toItem: settingsBtn, attribute: .width, multiplier: 1, constant: 0))
    constraints.append(NSLayoutConstraint(item: musicBtn, attribute: .height, relatedBy: .equal, toItem: settingsBtn, attribute: .height, multiplier: 1, constant: 0))

    addTodoBtn.setBackgroundImage(#imageLiteral(resourceName: "button_add"), for: .normal)
    addTodoBtn.addTarget(self, action: #selector(btnAcion(_:)), for: .touchUpInside)
    addTodoBtn.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(addTodoBtn)

    constraints.append(NSLayoutConstraint(item: addTodoBtn, attribute: .centerY, relatedBy: .equal, toItem: settingsBtn, attribute: .centerY, multiplier: 1, constant: 0))
    constraints.append(NSLayoutConstraint(item: addTodoBtn, attribute: .right, relatedBy: .equal, toItem: musicBtn, attribute: .left, multiplier: 1, constant: -8))
    constraints.append(NSLayoutConstraint(item: addTodoBtn, attribute: .width, relatedBy: .equal, toItem: settingsBtn, attribute: .width, multiplier: 1, constant: 0))
    constraints.append(NSLayoutConstraint(item: addTodoBtn, attribute: .height, relatedBy: .equal, toItem: settingsBtn, attribute: .height, multiplier: 1, constant: 0))


    NSLayoutConstraint.activate(constraints)
  }

  func initTableView(){
    tableView.delegate = self
    tableView.dataSource = self

    tableView.isHidden = true
    tableView.register(RootTableViewCell.self, forCellReuseIdentifier: RootTableViewCell.identifier)
    tableView.rowHeight = 100
    tableView.separatorStyle = .none
    tableView.backgroundColor = UIColor.clear
    tableView.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(tableView)

    var constraints = [NSLayoutConstraint]()
    constraints.append(NSLayoutConstraint(item: tableView, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0))
    constraints.append(NSLayoutConstraint(item: tableView, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1, constant: 0))
    constraints.append(NSLayoutConstraint(item: tableView, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 0.88, constant: 0))
    constraints.append(NSLayoutConstraint(item: tableView, attribute: .height, relatedBy: .equal, toItem: view, attribute: .height, multiplier: 0.72, constant: 0))

    NSLayoutConstraint.activate(constraints)
    fetchTodoList()
  }

  func fetchTodoList(){
    todoList = coreDataManager.retrieve("TodoItem", predicate: nil, limit: nil) as! [TodoItem]
    tableView.reloadData()
  }

  func initSegmentControl(){
    segment.insertSegment(withTitle: "1", at: 0, animated: true)
    segment.insertSegment(withTitle: "2", at: 1, animated: true)
    segment.addTarget(self, action: #selector(segmentControlAction(_:)), for: .valueChanged)
    segment.selectedSegmentIndex = 0
    segment.tintColor = UIColor.yellow
    segment.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(segment)

    var constraints = [NSLayoutConstraint]()
    constraints.append(NSLayoutConstraint(item: segment, attribute: .right, relatedBy: .equal, toItem: view, attribute: .right, multiplier: 1, constant: -24))
    constraints.append(NSLayoutConstraint(item: segment, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: -24))
    constraints.append(NSLayoutConstraint(item: segment, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: 64))
    constraints.append(NSLayoutConstraint(item: segment, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 32))

    NSLayoutConstraint.activate(constraints)
  }

  @objc func startPauseBtnAction(_ sender: UIButton) {
    if sender.backgroundImage(for: .normal) == #imageLiteral(resourceName: "start") {
      sender.setBackgroundImage(#imageLiteral(resourceName: "pause"), for: .normal)
      if(tomatoTimerView.workState == .work){
        tomatoTimerView.workStateHandler()
      }else{
        tomatoTimerView.timerCountDown()
      }
    }else{
      sender.setBackgroundImage(#imageLiteral(resourceName: "start"), for: .normal)
      tomatoTimerView.timerPause()
    }
  }

  @objc func btnAcion(_ sender: UIButton) {
    switch sender {
    case settingsBtn:
      let vc = SettingsViewController()
      self.navigationController?.pushViewController(vc, animated: false)
    case addTodoBtn:
      addTodoBtn.isUserInteractionEnabled = false
      addFormView()
    default:
      soundManager.musicIsOn = !soundManager.musicIsOn
      sender.setBackgroundImage(soundManager.musicIsOn ? #imageLiteral(resourceName: "music_on") : #imageLiteral(resourceName: "music_off"), for: .normal)
    }
  }

  @objc func segmentControlAction(_ sender: UISegmentedControl){
    switch sender.selectedSegmentIndex {
    case 0:
      tomatoTimerView.isHidden = false
      tableView.isHidden = true
    default:
      tomatoTimerView.isHidden = true
      tableView.isHidden = false
    }
  }

  func addFormView(){
    let formView = FormView()
    formView.ParentVC = self
    formView.backgroundColor = UIColor.white
    formView.translatesAutoresizingMaskIntoConstraints = false
    self.view.addSubview(formView)

    var constraints = [NSLayoutConstraint]()
    constraints.append(NSLayoutConstraint(item: formView, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0))
    constraints.append(NSLayoutConstraint(item: formView, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1, constant: 0))
    constraints.append(NSLayoutConstraint(item: formView, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 0.8, constant: 0))
    constraints.append(NSLayoutConstraint(item: formView, attribute: .height, relatedBy: .equal, toItem: view, attribute: .height, multiplier: 0.64, constant: 0))

    NSLayoutConstraint.activate(constraints)
  }

  //When touch the view end the editing => hide the keyboard
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    self.view.endEditing(true)
  }
}

extension RootViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return todoList.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: RootTableViewCell.identifier, for: indexPath) as! RootTableViewCell
    let index = indexPath.row

    cell.titleLabel.text = todoList[index].title
    cell.contentLabel.text = todoList[index].content
    cell.backgroundImage.image = #imageLiteral(resourceName: "task_on")

    return cell
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let index = indexPath.row

    if coreDataManager.delete("TodoItem", predicate: todoList[index].content!) {
      todoList.remove(at: index)
      self.tableView.reloadData()
    }
  }

}

extension RootViewController: CAAnimationDelegate {
  func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
    if flag { //animation is finish
      print("---Animation finish---")
      tomatoTimerView.workState = .begin
      tomatoTimerView.workStateHandler()

      
      for subview in tomatoTimerView.subviews {
        if circle == subview {
          circle.removeFromSuperview()
        }
      }
    }
  }
}

