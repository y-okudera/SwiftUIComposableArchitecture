//
//  SnapshotDevices.swift
//  SwiftUIComposableArchitectureTests
//
//  Created by Yuki Okudera on 2021/09/13.
//

import SnapshotTesting

enum SnapshotDevices: CaseIterable {
  case iPhoneXr
  case iPhoneXsMax
  case iPhoneX
  case iPhone8Plus
  case iPhone8
  case iPhoneSe

  var layout: SwiftUISnapshotLayout {
    switch self {
    case .iPhoneXr:
      return .device(config: .iPhoneXr)
    case .iPhoneXsMax:
      return .device(config: .iPhoneXsMax)
    case .iPhoneX:
      return .device(config: .iPhoneX)
    case .iPhone8Plus:
      return .device(config: .iPhone8Plus)
    case .iPhone8:
      return .device(config: .iPhone8)
    case .iPhoneSe:
      return .device(config: .iPhoneSe)
    }
  }
}
