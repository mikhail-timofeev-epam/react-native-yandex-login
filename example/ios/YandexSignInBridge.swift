//
//  YandexHelper.swift
//  example
//
//  Created by Mikhail Timofeev on 4/15/21.
//

import Foundation

@objc
class YandexSignInBridge : NSObject {

  @objc
  func handleOpen(url: URL, id: String) -> Bool{
      return YXLSdk.shared.handleOpen(url, sourceApplication: id)
    }
}
