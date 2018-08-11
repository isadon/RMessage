//
//  RMessage.swift
//  RMessage
//
//  Created by Adonis Peralta on 8/2/18.
//  Copyright © 2018 None. All rights reserved.
//

import Foundation
import HexColors
import UIKit

enum RMessagePosition {
  case top, bottom, navBarOverlay
}

enum RMessageDuration {
  case automatic, endless, tap, swipe, tapSwipe, timed
}

class RController: RMessageDelegate {
  var defaultViewController: UIViewController?
  let queue: OperationQueue

  /// By setting this delegate it's possible to set a custom offset for the message
  weak var delegate: RControllerDelegate?

  // Protect access to this variable from data races
  private(set) var messageOnScreen = false

  init() {
    queue = OperationQueue()
    // Make it a serial queue
    queue.maxConcurrentOperationCount = 1
  }

  /**
   Shows a notification message in a specific view controller
   @param viewController The view controller to show the notification in.
   @param title The title of the message view
   @param subtitle The message that is displayed underneath the title (optional)
   @param iconImage A custom icon image (optional)
   @param type The message type (Message, Warning, Error, Success, Custom)
   @param customTypeName The string identifier/key for the custom style to use from specified custom
   design file. Only use when specifying an additional custom design file and when the type parameter in this call is
   RMessageTypeCustom
   @param duration The duration of the notification being displayed
   @param callback The block that should be executed, when the user tapped on the message
   @param presentingCompletionCallback The block that should be executed on presentation of the message
   @param dismissCompletionCallback The block that should be executed on dismissal of the message
   @param buttonTitle The title for button (optional)
   @param buttonCallback The block that should be executed, when the user tapped on the button
   @param messagePosition The position of the message on the screen
   @param dismissingEnabled Should the message be dismissed when the user taps/swipes it
   */
  func showMessage(
    withSpec spec: RMessageSpec, atPosition targetPosition: RMessagePosition = .top,
    title: String, body: String? = nil, viewController: UIViewController? = nil,
    leftView: UIView? = nil, rightView: UIView? = nil, backgroundView: UIView? = nil,
    tapCompletion: (() -> Void)? = nil, presentCompletion: (() -> Void)? = nil,
    dismissCompletion: (() -> Void)? = nil
  ) {
    guard let message = RMessage(
      spec: spec, targetPosition: targetPosition, title: title, body: body,
      viewController: viewController, leftView: leftView, rightView: rightView, backgroundView: backgroundView, tapCompletion: tapCompletion,
      presentCompletion: presentCompletion, dismissCompletion: dismissCompletion
    ) else {
      return
    }
    delegate?.customize?(message: message)
    let presentOp = RMOperation(message: message)
    queue.addOperation(presentOp)
  }

  /**
   Fades out the currently displayed notification. If another notification is in the queue,
   the next one will be displayed automatically
   @return YES if the currently displayed notification was successfully dismissed. NO if no
   notification was currently displayed.
   */
  func dismissOnScreenMessage(withCompletion completion: (() -> Void)? = nil) -> Bool {
    if let operation = queue.operations.first as? RMOperation {
      operation.message.dismiss(withCompletion: completion)
    }
    return true
  }

  // MARK: RMessageDelegate Methods

  /**
   Call this method to notify any presenting or on screen messages that the interface has rotated.
   Ideally should go inside the calling view controllers viewWillTransitionToSize:withTransitionCoordinator: method.
   */
  func interfaceDidRotate() {
    if let operation = queue.operations.first as? RMOperation, operation.message.screenStatus == .presenting {
      operation.message.interfaceDidRotate()
    }
  }
}