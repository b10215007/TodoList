//
//  FormView.swift
//  TodoList
//
//  Created by michael on 2018/9/7.
//  Copyright © 2018年 michael. All rights reserved.
//

import UIKit

class FormView: UIView {

  weak var ParentVC: RootViewController?

  let topView = UIView()
  let cancelButton = UIButton()

  let sortTextLabel = UILabel()
  let sortButton = UIButton()
  let arrowImage = UIImageView()
  let stackView = UIStackView()
  let sort1Button = UIButton()
  let sort2Button = UIButton()
  let sort3Button = UIButton()

  let todoTitleLabel = UILabel()
  let todoTitleInput = UITextField()

  let todoTextLabel = UILabel()
  let todoInput = UITextField()

  let confirmButton = UIButton()

  let dataManager = CoreDataManager()
  let textArray = ["分類", "標題", "代辦事項","增加此待辦事項"]
  let sortTextArray = ["工作", "下班出去玩", "朋友家人聚會"]
  var btnArray = [UIButton]()
  let font = UIFont.systemFont(ofSize: 20, weight: .medium)

  override init(frame: CGRect) {
    super.init(frame: frame)
    initView()

    todoInput.delegate = self
    todoTitleInput.delegate = self
    registKeyboardEvent()
  }

  deinit {
    removeKeyboardEvent()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func initView(){
    self.layer.cornerRadius = 8
    initTopView()
    initCenterLayout()
    initTitleInput()
    initTodoTextInput()
    initStack()
    initConfirmButton()
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

  func initCenterLayout(){
    sortTextLabel.text = textArray[0]
    sortTextLabel.font = font
    sortTextLabel.translatesAutoresizingMaskIntoConstraints = false
    self.addSubview(sortTextLabel)

    var constraints = [NSLayoutConstraint]()
    constraints.append(NSLayoutConstraint(item: sortTextLabel, attribute: .top, relatedBy: .equal, toItem: topView, attribute: .bottom, multiplier: 1, constant: 16))
    constraints.append(NSLayoutConstraint(item: sortTextLabel, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 16))

    sortButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
    sortButton.setTitleColor(UIColor.black, for: .normal)
    sortButton.setTitle(sortTextArray[0], for: .normal)
    sortButton.backgroundColor = UIColor.white
    sortButton.layer.cornerRadius = 4
    sortButton.layer.borderWidth = 2
    sortButton.layer.borderColor = UIColor.darkGray.cgColor
    sortButton.addTarget(self, action: #selector(sortBtnAction(_:)), for: .touchUpInside)
    sortButton.translatesAutoresizingMaskIntoConstraints = false
    self.addSubview(sortButton)

    constraints.append(NSLayoutConstraint(item: sortButton, attribute: .top, relatedBy: .equal, toItem: sortTextLabel, attribute: .bottom, multiplier: 1, constant: 8))
    constraints.append(NSLayoutConstraint(item: sortButton, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 16))
    constraints.append(NSLayoutConstraint(item: sortButton, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 0.8, constant: 0))
    constraints.append(NSLayoutConstraint(item: sortButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 50))

    arrowImage.image = #imageLiteral(resourceName: "button_sort_on")
    arrowImage.translatesAutoresizingMaskIntoConstraints = false
    self.addSubview(arrowImage)

    constraints.append(NSLayoutConstraint(item: arrowImage, attribute: .centerY, relatedBy: .equal, toItem: sortButton, attribute: .centerY, multiplier: 1, constant: 0))
    constraints.append(NSLayoutConstraint(item: arrowImage, attribute: .right, relatedBy: .equal, toItem: sortButton, attribute: .right, multiplier: 1, constant: -16))
    constraints.append(NSLayoutConstraint(item: arrowImage, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: 20))
    constraints.append(NSLayoutConstraint(item: arrowImage, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 16))

    NSLayoutConstraint.activate(constraints)
  }

  func initTitleInput(){
    todoTitleLabel.text = textArray[1]
    todoTitleLabel.font = font
    todoTitleLabel.translatesAutoresizingMaskIntoConstraints = false
    self.addSubview(todoTitleLabel)

    var constraints = [NSLayoutConstraint]()
    constraints.append(NSLayoutConstraint(item: todoTitleLabel, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 16))
    constraints.append(NSLayoutConstraint(item: todoTitleLabel, attribute: .top, relatedBy: .equal, toItem: sortButton, attribute: .bottom, multiplier: 1, constant: 24))

    todoTitleInput.placeholder = "早上"
    todoTitleInput.borderStyle = .roundedRect
    todoTitleInput.font = font
    todoTitleInput.layer.borderWidth = 2
    todoTitleInput.layer.borderColor = UIColor.darkGray.cgColor
    todoTitleInput.layer.cornerRadius = 6
    todoTitleInput.translatesAutoresizingMaskIntoConstraints = false
    self.addSubview(todoTitleInput)

    constraints.append(NSLayoutConstraint(item: todoTitleInput, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 16))
    constraints.append(NSLayoutConstraint(item: todoTitleInput, attribute: .top, relatedBy: .equal, toItem: todoTitleLabel, attribute: .bottom, multiplier: 1, constant: 8))
    constraints.append(NSLayoutConstraint(item: todoTitleInput, attribute: .width, relatedBy: .equal, toItem: sortButton, attribute: .width, multiplier: 1, constant: 0))
    constraints.append(NSLayoutConstraint(item: todoTitleInput, attribute: .height, relatedBy: .equal, toItem: sortButton, attribute: .height, multiplier: 1, constant: 0))

    NSLayoutConstraint.activate(constraints)
  }

  func initTodoTextInput(){
    todoTextLabel.text = textArray[2]
    todoTextLabel.font = font
    todoTextLabel.translatesAutoresizingMaskIntoConstraints = false
    self.addSubview(todoTextLabel)

    var constraints = [NSLayoutConstraint]()
    constraints.append(NSLayoutConstraint(item: todoTextLabel, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 16))
    constraints.append(NSLayoutConstraint(item: todoTextLabel, attribute: .top, relatedBy: .equal, toItem: todoTitleInput, attribute: .bottom, multiplier: 1, constant: 24))

    todoInput.placeholder = "起來刷刷牙"
    todoInput.font = font
    todoInput.borderStyle = .roundedRect
    todoInput.layer.borderWidth = 2
    todoInput.layer.borderColor = UIColor.darkGray.cgColor
    todoInput.layer.cornerRadius = 6
    todoInput.translatesAutoresizingMaskIntoConstraints = false
    self.addSubview(todoInput)

    constraints.append(NSLayoutConstraint(item: todoInput, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 16))
    constraints.append(NSLayoutConstraint(item: todoInput, attribute: .top, relatedBy: .equal, toItem: todoTextLabel, attribute: .bottom, multiplier: 1, constant: 8))
    constraints.append(NSLayoutConstraint(item: todoInput, attribute: .width, relatedBy: .equal, toItem: sortButton, attribute: .width, multiplier: 1, constant: 0))
    constraints.append(NSLayoutConstraint(item: todoInput, attribute: .height, relatedBy: .equal, toItem: sortButton, attribute: .height, multiplier: 1, constant: 0))


    NSLayoutConstraint.activate(constraints)
  }

  func initStack(){
    btnArray = [sort1Button, sort2Button, sort3Button]
    for (i,btn) in btnArray.enumerated() {
      btn.backgroundColor = UIColor.yellow
      btn.layer.borderWidth = 1
      btn.layer.borderColor = UIColor.darkGray.cgColor
      btn.setTitle(sortTextArray[i], for: .normal)
      btn.setTitleColor(UIColor.lightGray, for: .normal)
      btn.addTarget(self, action: #selector(btnAction(_:)), for: .touchUpInside)
      btn.isHidden = true
      btn.translatesAutoresizingMaskIntoConstraints = false
      stackView.addArrangedSubview(btn)
    }

    stackView.axis = .vertical
    stackView.alignment = .fill
    stackView.distribution = .fillEqually
    stackView.layer.cornerRadius = 2
    stackView.layer.borderWidth = 2
    stackView.layer.borderColor = UIColor.darkGray.cgColor
    stackView.translatesAutoresizingMaskIntoConstraints = false
    self.addSubview(stackView)

    var constraints = [NSLayoutConstraint]()
    constraints.append(NSLayoutConstraint(item: stackView, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 16))

    constraints.append(NSLayoutConstraint(item: stackView, attribute: .top, relatedBy: .equal, toItem: sortButton, attribute: .bottom, multiplier: 1, constant: 0))
    constraints.append(NSLayoutConstraint(item: stackView, attribute: .width, relatedBy: .equal, toItem: sortButton, attribute: .width, multiplier: 1, constant: 0))
    constraints.append(NSLayoutConstraint(item: stackView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 96))

    NSLayoutConstraint.activate(constraints)
  }

  func initConfirmButton(){
    confirmButton.setTitle(textArray[3], for: .normal)
    confirmButton.addTarget(self, action: #selector(confirmButtonAction(_:)), for: .touchUpInside)
    confirmButton.backgroundColor = UIColor.cyan
    confirmButton.layer.cornerRadius = 8
    confirmButton.layer.borderColor = UIColor.darkGray.cgColor
    confirmButton.layer.borderWidth = 2
    confirmButton.translatesAutoresizingMaskIntoConstraints = false
    self.addSubview(confirmButton)

    var constraints = [NSLayoutConstraint]()
    constraints.append(NSLayoutConstraint(item: confirmButton, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
    constraints.append(NSLayoutConstraint(item: confirmButton, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: -12))
    constraints.append(NSLayoutConstraint(item: confirmButton, attribute: .width, relatedBy: .equal, toItem: sortButton, attribute: .width, multiplier: 1, constant: 0))
    constraints.append(NSLayoutConstraint(item: confirmButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 40))

    NSLayoutConstraint.activate(constraints)
  }

  @objc func btnAction(_ sender: UIButton){
    sortButton.setTitle(sender.titleLabel?.text, for: .normal)
    sortOn()
  }

  func checkInputTextIsEmpty() -> Bool {
    if todoTitleInput.text == "" || todoTitleInput.text == nil {
      addAlert(title: "標題")
      return true
    }
    if todoInput.text == "" || todoInput.text == nil {
      addAlert(title: "內容")
      return true
    }
    return false
  }

  func addAlert(title: String){
    let alertVC = UIAlertController(title: "\(title)忘記輸入囉", message: "", preferredStyle: .alert)
    alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
    ParentVC?.present(alertVC, animated: true, completion: nil)
  }

  @objc func confirmButtonAction(_ sender: UIButton){
    if !checkInputTextIsEmpty() {
      addToDoList()
      removeView()
    }
  }

  func switchText(text: String) -> String{
    switch text {
    case "工作":
      return "work"
    case "下班出去玩":
      return "offWork"
    default:
      return "dating"
    }
  }

  func addToDoList(){
    dataManager.insertData(entityName: "TodoItem", sort: switchText(text: (sortButton.titleLabel?.text)!), title: todoTitleInput.text!, content: todoInput.text!)
  }

  func removeView(){
    ParentVC?.addTodoBtn.isUserInteractionEnabled = true
    self.removeFromSuperview()
  }

  @objc func sortBtnAction(_ sender: UIButton){
    sortOn()
  }

  func sortOn(){
    for (i,btn) in btnArray.enumerated() {
      DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * 0.1) {
        btn.isHidden = !btn.isHidden
      }
    }
  }


  @objc func cancelAction(_ sender: UIButton){
    removeView()
  }

}

extension FormView: UITextFieldDelegate {

  func registKeyboardEvent(){
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
  }

  @objc func keyboardWillShow(notification: NSNotification){
    if ((notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue) != nil) {
      self.frame.origin.y -= 56
    }
  }

  @objc func keyboardWillHide(notification:NSNotification){
    if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
      self.frame.origin.y += 56
    }
  }

  func removeKeyboardEvent(){
    NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
    NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
  }

  func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
    textField.returnKeyType = .done
    return true
  }

  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }


}
