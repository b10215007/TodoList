//
//  TomatoTimerView.swift
//  TodoList
//
//  Created by michael on 2018/9/16.
//  Copyright © 2018年 michael. All rights reserved.
//

import UIKit

class TomatoTimerView: UIView {

  weak var ParentVC: RootViewController?

  enum WorkState: Int{
    case begin = 0x90D4D0
    case work = 0xFF917D
    case rest = 0x213682
  }

  var workState = WorkState.begin

  let backgroundImage = UIImageView()
  let startPauseBtn = UIButton()
  let countDownLabel = UILabel()
  let font = UIFont.systemFont(ofSize: 56, weight: .semibold)

  var gamesTime = 0{
    didSet{
      let minute = gamesTime / 60
      let second = gamesTime - 60*minute
      if(second>9){
        countDownLabel.text = "\(minute):\(second)"
      }
      else{
        countDownLabel.text = "\(minute):0\(second)"
      }
    }
  }
  var downTimer: Timer?

  override init(frame: CGRect) {
    super.init(frame: frame)
    initView()
  }

  deinit {
    if downTimer != nil {
      downTimer = nil
    }
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func initView(){

    gamesTime = getGameTime()
    countDownLabel.font = font
    countDownLabel.textColor = UIColor.white
    countDownLabel.translatesAutoresizingMaskIntoConstraints = false
    self.addSubview(countDownLabel)

    var constraints = [NSLayoutConstraint]()
    constraints.append(NSLayoutConstraint(item: countDownLabel, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
    constraints.append(NSLayoutConstraint(item: countDownLabel, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 0.88, constant: 0))

    startPauseBtn.translatesAutoresizingMaskIntoConstraints = false
    self.addSubview(startPauseBtn)

    constraints.append(NSLayoutConstraint(item: startPauseBtn, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
    constraints.append(NSLayoutConstraint(item: startPauseBtn, attribute: .top, relatedBy: .equal, toItem: countDownLabel, attribute: .bottom, multiplier: 1, constant: 24))
    constraints.append(NSLayoutConstraint(item: startPauseBtn, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 0.32, constant: 0))
    constraints.append(NSLayoutConstraint(item: startPauseBtn, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 50))

    NSLayoutConstraint.activate(constraints)
  }

  func getGameTime() -> Int{
    if let value = UserDefaultsManager.get(key: .tomatoTime) as? Int {
      switch value {
      case 0:
        return 1800
      case 1:
        return 1200
      case 2:
        return 720
      case 3:
        return 480
      default:
        return 300
      }
    }else{
      return 300
    }
  }

  func getRestTime() -> Int {
    if let value = UserDefaultsManager.get(key: .restTime) as? Int {
      switch value {
      case 0:
        return 720
      case 1:
        return 480
      case 2:
        return 300
      case 3:
        return 120
      default:
        return 60
      }
    }else{
      return 60
    }
  }

  func timerPause(){
    self.downTimer?.invalidate()
    self.downTimer = nil
  }

  func timerCountDown(){
    if(self.downTimer == nil){
      self.downTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(countDown(timer:)), userInfo: nil, repeats: true)
    }
  }

  @objc func countDown(timer : Timer) {
    self.gamesTime -= 1

    if self.gamesTime == 0 || self.gamesTime < 0{
      self.downTimer?.invalidate()
      self.downTimer = nil
      self.workStateHandler()

    }
  }

  @objc func workStateHandler(){
    switch workState {
    case .begin:
      ParentVC?.backgroundImage.backgroundColor = UIColor(rgb: WorkState.begin.rawValue)
      timerPause()
      startPauseBtn.setBackgroundImage(#imageLiteral(resourceName: "start"), for: .normal)
      countDownLabel.text = "\(getGameTime()/60):00"
      ParentVC?.soundManager.stopMusic()
      ParentVC?.addTodoBtn.isUserInteractionEnabled = true

      workState = .work
    case .work:
      ParentVC?.backgroundImage.backgroundColor = UIColor(rgb: WorkState.work.rawValue)
      gamesTime = getGameTime()
      timerCountDown()
      ParentVC?.soundManager.playMusic()

      workState = .rest
    case .rest:
      ParentVC?.backgroundImage.backgroundColor = UIColor(rgb: WorkState.rest.rawValue)
      gamesTime = getRestTime()
      timerCountDown()
      ParentVC?.soundManager.playMusic()

      workState = .begin
    }
  }

  func sendNotification(second :Int, sendMeassage: String){
    let notification = UILocalNotification()
    notification.fireDate = NSDate(timeIntervalSinceNow: TimeInterval(second)) as Date
    notification.alertBody = sendMeassage
    notification.alertAction = "Ok"//  used in UIAlert button or 'slide to unlock...' slider in place of unlock
    notification.soundName = UILocalNotificationDefaultSoundName
    notification.userInfo = ["customParameterKey_from" : "Sergey"]
    notification.applicationIconBadgeNumber = 1
    UIApplication.shared.scheduleLocalNotification(notification)
  }
}
