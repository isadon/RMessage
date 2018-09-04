//
//  RMController.swift
//  RMessage
//
//  Created by Adonis Peralta on 8/2/18.
//  Copyright © 2018 None. All rights reserved.
//

import Foundation
import HexColors
import UIKit

class RMController: RMPresenterDelegate {
  /** The view controller this message is displayed in */
  lazy var presentationViewController: UIViewController = UIWindow.defaultViewControllerForPresentation()

  private let queue: OperationQueue

  /// By setting this delegate it's possible to set a custom offset for the message
  weak var delegate: RMControllerDelegate?

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
      spec: spec, title: title, body: body,
      leftView: leftView, rightView: rightView, backgroundView: backgroundView
    ) else {
      return
    }

    let presentOpts = RMPresenterOptionsDefault()
    let animOpts = RMAnimationOptionsDefault()

    var presentVC: UIViewController
    if let viewController = viewController {
      presentVC = viewController
    } else {
      presentVC = presentationViewController
    }

    let animator = SlideAnimator(
      targetPosition: targetPosition, view: message,
      superview: presentVC.view, contentView: message.contentView
    )
    let presenter = RMPresenter(
      message: message, targetPosition: targetPosition, animator: animator,
      presentationOptions: presentOpts, animationOptions: animOpts,
      tapCompletion: tapCompletion, presentCompletion: presentCompletion,
      dismissCompletion: dismissCompletion
    )

    delegate?.customize?(message: message)
    let presentOp = RMShowOperation(message: message, presenter: presenter)
    queue.addOperation(presentOp)
  }

  /**
   Fades out the currently displayed notification. If another notification is in the queue,
   the next one will be displayed automatically
   @return YES if the currently displayed notification was successfully dismissed. NO if no
   notification was currently displayed.
   */
  func dismissOnScreenMessage(withCompletion completion: (() -> Void)? = nil) -> Bool {
    if let operation = queue.operations.first as? RMShowOperation {
      operation.presenter.dismiss(withCompletion: completion)
    }
    return true
  }

  func cancelPendingDisplayMessages() {
    queue.cancelAllOperations()
  }

  // MARK: RMessageDelegate Methods

  /**
   Call this method to notify any presenting or on screen messages that the interface has rotated.
   Ideally should go inside the calling view controllers viewWillTransitionToSize:withTransitionCoordinator: method.
   */
  func interfaceDidRotate() {
    if let operation = queue.operations.first as? RMShowOperation, operation.presenter.screenStatus == .presenting {
      operation.presenter.interfaceDidRotate()
    }
  }
}
