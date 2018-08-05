//
//  RMessageViewDelegate.swift
//  RMessage
//
//  Created by Adonis Peralta on 8/3/18.
//  Copyright © 2018 None. All rights reserved.
//

import Foundation
import UIKit

@objc protocol RMessageDelegate {
  @objc optional func messageViewIsPresenting(_ message: RMessage)
  @objc optional func messageViewDidPresent(_ message: RMessage)
  @objc optional func messageViewDidDismiss(_ message: RMessage)
  @objc optional func messageViewSwiped(_ message: RMessage)
  @objc optional func messageViewTapped(_ message: RMessage)
}
