//
//  SoundManager.swift
//  TodoList
//
//  Created by michael on 2018/9/6.
//  Copyright © 2018年 michael. All rights reserved.
//

import AVFoundation

class SoundManager{

  private static var singleton: SoundManager?
  static func shared() -> SoundManager {
    if singleton == nil {
      singleton = SoundManager()
    }
    return singleton!
  }

  struct BGM {
    private static let url = URL(fileURLWithPath:
      Bundle.main.path(forResource: BGMType.bgm.rawValue, ofType: "mp3")!)
    private static let url2 = URL(fileURLWithPath:
      Bundle.main.path(forResource: BGMType.bgm2.rawValue, ofType: "mp3")!)
    private static let url3 = URL(fileURLWithPath:
      Bundle.main.path(forResource: BGMType.bgm3.rawValue, ofType: "mp3")!)

    static var player = AVAudioPlayer()

    static func set(index: Int) {
      switch index {
      case 0:
        player = try! AVAudioPlayer(contentsOf: url)
      default:
        player = try! AVAudioPlayer(contentsOf: url2)
      }
      player.prepareToPlay()
      player.numberOfLoops = -1
    }

    static func set(bgmType: BGMType) {
      switch bgmType {
      case .bgm:
        player = try! AVAudioPlayer(contentsOf: url)
      case .bgm2:
        player = try! AVAudioPlayer(contentsOf: url2)
      case .bgm3:
        player = try! AVAudioPlayer(contentsOf: url3)
      }
      player.prepareToPlay()
      player.numberOfLoops = -1
    }
  }

  struct SoundEffect {
    private static let sound = URL(fileURLWithPath:
      Bundle.main.path(forResource: SoundType.normal.rawValue, ofType: "mp3")!)
    private static let sound2 = URL(fileURLWithPath:
      Bundle.main.path(forResource: SoundType.rain.rawValue, ofType: "mp3")!)
    private static let sound3 = URL(fileURLWithPath:
      Bundle.main.path(forResource: SoundType.whistle.rawValue, ofType: "mp3")!)
    private static let sound4 = URL(fileURLWithPath:
      Bundle.main.path(forResource: SoundType.crystal.rawValue, ofType: "mp3")!)
    private static let sound5 = URL(fileURLWithPath:
      Bundle.main.path(forResource: SoundType.drop.rawValue, ofType: "mp3")!)
    private static let sound6 = URL(fileURLWithPath:
      Bundle.main.path(forResource: SoundType.universe.rawValue, ofType: "mp3")!)

    static var player = AVAudioPlayer()

    static func set(soundType: SoundType) {
      switch soundType {
      case .normal:
        player = try! AVAudioPlayer(contentsOf: sound)
      case .rain:
        player = try! AVAudioPlayer(contentsOf: sound2)
      case .whistle:
        player = try! AVAudioPlayer(contentsOf: sound3)
      case .crystal:
        player = try! AVAudioPlayer(contentsOf: sound4)
      case .drop:
        player = try! AVAudioPlayer(contentsOf: sound5)
      case .universe:
        player = try! AVAudioPlayer(contentsOf: sound6)
      }
      player.prepareToPlay()
      player.numberOfLoops = 1
    }

  }

  enum BGMType: String {
    case bgm = "backgroundMusic"
    case bgm2 = "backgroundMusic2"
    case bgm3 = "backgroundJazz"
  }

  enum SoundType: String {
    case normal = "一般"
    case rain = "下雨"
    case whistle = "口哨"
    case crystal = "水晶"
    case drop = "水滴"
    case universe = "宇宙"
  }

  var musicIndex = 0 {
    didSet{
      setMusicIndex()
    }
  }
  var musicIsOn = true{
    didSet{
      UserDefaultsManager.set(value: musicIsOn, key: .musicIsOn)
      playMusic()
    }
  }
  var soundIsOn = true

  func configure(){
    configureBGM()
    configureSoundEffect()
  }

  private func configureBGM(){
    if let index = UserDefaultsManager.get(key: UserInfoKey.musicType) as? Int {
      musicIndex = index
    }else{
      BGM.set(index: 0)
    }
    if let value = UserDefaultsManager.get(key: UserInfoKey.musicIsOn) as? Bool {
      musicIsOn = value
    }
  }

  private func configureSoundEffect(){
    if let value = UserDefaultsManager.get(key: UserInfoKey.soundIsOn) as? Bool {
      soundIsOn = value
    }
  }

  func setMusicIndex(){
    BGM.set(index: musicIndex)
  }

  func playMusic(){
    if musicIsOn {
      BGM.player.play()
    }else{
      BGM.player.stop()
    }
  }

  func stopMusic(){
    BGM.player.stop()
  }

  func playSoundEffect(type: SoundType){
    if soundIsOn {
      SoundEffect.set(soundType: type)
      SoundEffect.player.play()
    }
  }
}
