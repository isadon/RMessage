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
  /// Notifies the presenter's delegate that the presenter will soon present the message.
  ///
  /// - Parameters:
  ///   - presenter: The presenter presenting the message.
  ///   - message: The message being presented.
  @objc optional func presenterWillPresent(_ presenter: RMPresenter, message: RMessage)

  /// Notifies the presenter's delegate that the presenter is presenting the message.
  ///
  /// - Parameters:
  ///   - presenter: The presenter presenting the message.
  ///   - message: The message being presented.
  @objc optional func presenterIsPresenting(_ presenter: RMPresenter, message: RMessage)

  /// Notifies the presenter's delegate that the presenter did present the message.
  ///
  /// - Parameters:
  ///   - presenter: The presenter presenting the message.
  ///   - message: The message being presented.
  @objc optional func presenterDidPresent(_ presenter: RMPresenter, message: RMessage)

  /// Notifies the presenter's delegate that the presenter will soon dismiss the message.
  ///
  /// - Parameters:
  ///   - presenter: The presenter presenting the message.
  ///   - message: The message being presented.
  @objc optional func presenterWillDismiss(_ presenter: RMPresenter, message: RMessage)

  /// Notifies the presenter's delegate that the presenter is dismissing the message.
  ///
  /// - Parameters:
  ///   - presenter: The presenter presenting the message.
  ///   - message: The message being presented.
  @objc optional func presenterIsDismissing(_ presenter: RMPresenter, message: RMessage)

  /// Notifies the presenter's delegate that the presenter did dismiss the message.
  ///
  /// - Parameters:
  ///   - presenter: The presenter presenting the message.
  ///   - message: The message being presented.
  @objc optional func presenterDidDismiss(_ presenter: RMPresenter, message: RMessage)

  /// Notifies the presenter's delegate that the message was swiped.
  ///
  /// - Parameters:
  ///   - presenter: The presenter presenting the message.
  ///   - message: The message being presented.
  @objc optional func messageSwiped(forPresenter presenter: RMPresenter, message: RMessage)

  /// Notifies the presenter's delegate that the message was tapped.
  ///
  /// - Parameters:
  ///   - presenter: The presenter presenting the message.
  ///   - message: The message being presented.
  @objc optional func messageTapped(forPresenter presenter: RMPresenter, message: RMessage)
}
