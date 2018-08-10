//
//  RMessageDelegate.swift
//  RMessage
//
//  Created by Adonis Peralta on 8/3/18.
//  Copyright © 2018 None. All rights reserved.
//

import Foundation
import UIKit

@objc protocol RMessageDelegate {
  @objc optional func messageWillPresent(_ message: RMessage)
  @objc optional func messageWillDismiss(_ message: RMessage)
  @objc optional func messageIsPresenting(_ message: RMessage)
  @objc optional func messageIsDismissing(_ message: RMessage)
  @objc optional func messageDidPresent(_ message: RMessage)
  @objc optional func messageDidDismiss(_ message: RMessage)
  @objc optional func messageSwiped(_ message: RMessage)
  @objc optional func messageTapped(_ message: RMessage)
}
