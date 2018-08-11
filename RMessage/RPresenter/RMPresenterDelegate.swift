//
//  RMPresenterDelegate.swift
//  RMessage
//
//  Created by Adonis Peralta on 8/3/18.
//  Copyright © 2018 None. All rights reserved.
//

import Foundation
import UIKit

@objc protocol RMPresenterDelegate {
  @objc optional func presenterWillPresent(_ presenter: RMPresenter, message: RMessage)
  @objc optional func presenterIsPresenting(_ presenter: RMPresenter, message: RMessage)
  @objc optional func presenterDidPresent(_ presenter: RMPresenter, message: RMessage)
  @objc optional func presenterWillDismiss(_ presenter: RMPresenter, message: RMessage)
  @objc optional func presenterIsDismissing(_ presenter: RMPresenter, message: RMessage)
  @objc optional func presenterDidDismiss(_ presenter: RMPresenter, message: RMessage)
  @objc optional func messageSwiped(forPresenter presenter: RMPresenter, message: RMessage)
  @objc optional func messageTapped(forPresenter presenter: RMPresenter, message: RMessage)
}
