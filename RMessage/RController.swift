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
  case automatic, endless, custom
}

class RController: RMessageDelegate {
  var defaultViewController: UIViewController?
  private let mLock = NSLock(), nLock = NSLock()

  /// By setting this delegate it's possible to set a custom offset for the message view
  weak var delegate: RControllerDelegate?

  // Protect access to this variable from data races
  private(set) var isMessageViewOnScreen = false

  /** Returns the currently queued array of RMessage */
  var queuedMessages: [RMessage] {
    // Double check to make sure but I believe we can simply pass the array of RmessageView's here are arrays are value
    // types
    return messages
  }

  // Protect access to this variable from data races
  private var messages: [RMessage]

  init() {
    mLock.lock()
    defer { mLock.unlock() }
    messages = [RMessage]()
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
    message.delegate = self
    prepareForPresentation(message: message)
  }

  /** Prepares the message view to be displayed in the future. It is queued and then displayed in
   fadeInCurrentNotification. You don't have to use this method. */
  func prepareForPresentation(message: RMessage) {
    mLock.lock()
    messages.append(message)
    mLock.unlock()

    nLock.lock()
    if !isMessageViewOnScreen {
      nLock.unlock()
      presentQueuedMessageView()
      return
    }
    nLock.unlock()
  }

  private func presentQueuedMessageView() {
    mLock.lock()

    if messages.count == 0 {
      mLock.unlock()
      return
    }

    if let messageView = messages.first {
      mLock.unlock()
      delegate?.customize?(messageView: messageView)
      messageView.present()
    }
  }

  /**
   Fades out the currently displayed notification. If another notification is in the queue,
   the next one will be displayed automatically
   @return YES if the currently displayed notification was successfully dismissed. NO if no
   notification was currently displayed.
   */
  func dismissOnScreenMessageView(withCompletion completion: (() -> Void)? = nil) -> Bool {
    mLock.lock()
    defer { mLock.unlock() }
    if messages.count == 0 {
      return false
    }
    if let currentMessage = messages.first, currentMessage.isFullyDisplayed {
      currentMessage.dismiss(withCompletion: completion)
    }
    return true
  }

  // MARK: RMessageDelegate Methods

  func messageViewIsPresenting(_: RMessage) {
    nLock.lock()
    isMessageViewOnScreen = true
    nLock.unlock()
  }

  func messageViewDidDismiss(_: RMessage) {
    mLock.lock()
    if messages.count > 0 {
      messages.remove(at: 0)
    }
    mLock.unlock()

    nLock.lock()
    isMessageViewOnScreen = false
    nLock.unlock()

    mLock.lock()
    if messages.count > 0 {
      mLock.unlock()
      presentQueuedMessageView()
      return
    }
    mLock.unlock()
  }

  /**
   Call this method to notify any presenting or on screen messages that the interface has rotated.
   Ideally should go inside the calling view controllers viewWillTransitionToSize:withTransitionCoordinator: method.
   */
  func interfaceDidRotate() {
    mLock.lock()
    if messages.count == 0 {
      mLock.unlock()
      return
    }
    messages.first?.interfaceDidRotate()
    mLock.unlock()
  }
}
