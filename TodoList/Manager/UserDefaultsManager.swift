//
//  UserDefaultManager.swift
//  TodoList
//
//  Created by michael on 2018/9/6.
//  Copyright © 2018年 michael. All rights reserved.
//

import Foundation

class UserDefaultsManager: NSObject {
  static func set(value : Any, key : UserInfoKey) {

    UserDefaults.standard.set(value, forKey: key.rawValue)
    UserDefaults.standard.synchronize()
  }

  static func get(key : UserInfoKey) -> Any? {
    return UserDefaults.standard.value(forKey: key.rawValue)
  }

  static func setArray(array: [Any], key : UserInfoKey) {
    UserDefaults.standard.set(array, forKey: key.rawValue)
    UserDefaults.standard.synchronize()
  }

  static func getArray(key : UserInfoKey) -> [Any]? {
    return UserDefaults.standard.array(forKey: key.rawValue)
  }
}

enum UserInfoKey : String {
  case soundIsOn =  "soundIsOn"
  case musicIsOn = "musicIsOn"
  case musicType = "musicType"
  case tomatoTime = "tomatoTime"
  case restTime = "restTime"
}
