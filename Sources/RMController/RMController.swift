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

public class RMController: NSObject, RMPresenterDelegate {
  /// The view controller this message is displayed in.
  public var presentationViewController: UIViewController?

  /// Delegate of the RMController object.
  public weak var delegate: RMControllerDelegate?

  // Protect access to this variable from data races
  private(set) var messageOnScreen = false

  private let queue: OperationQueue

  public var queueCount: Int {
    return queue.operationCount
  }

  public override init() {
    queue = OperationQueue()
    // Make it a serial queue
    queue.maxConcurrentOperationCount = 1
  }

  /// Shows a notification message.
  ///
  /// - Parameters:
  ///   - spec: A message spec to use for styling the message, please see *RMessageSpec for usage details.
  ///   - targetPosition: The position *to* which the message should be presented, (default = top).
  ///   - title: The title text of the message.
  ///   - body: The body text of the message.
  ///   - viewController: The view controller in which to present the message (optional).
  ///   - leftView: A view to show as the left view of the message.
  ///   - rightView: A view to show as the right view of the message.
  ///   - backgroundView: A view to show as the background view of the message.
  ///   - tapCompletion: A callback to be called when the message is tapped.
  ///   - presentCompletion: A callback to be called when the message is presented.
  ///   - dismissCompletion: A callback to be called when the message is dismissed.
  public func showMessage(
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

    let animOpts = DefaultRMAnimationOptions()

    let presentVC = viewController ?? presentationViewController ?? UIWindow.topViewController()

    // Make sure we have a presentation view controller for the message
    guard let presentationVC = presentVC else {
      return
    }

    let animator = SlideAnimator(
      targetPosition: targetPosition, view: message,
      superview: presentationVC.view, contentView: message.contentView
    )

    let presenter = RMPresenter(
      message: message, targetPosition: targetPosition, animator: animator,
      animationOptions: animOpts, tapCompletion: tapCompletion, presentCompletion: presentCompletion,
      dismissCompletion: dismissCompletion
    )

    delegate?.customize?(message: message, controller: self)
    let presentOp = RMShowOperation(message: message, presenter: presenter)
    queue.addOperation(presentOp)
  }

  /**
   Fades out the currently displayed notification. If another notification is in the queue,
   the next one will be displayed automatically
   @return YES if the currently displayed notification was successfully dismissed. NO if no
   notification was currently displayed.
   */
  public func dismissOnScreenMessage(withCompletion completion: (() -> Void)? = nil) -> Bool {
    if let operation = queue.operations.first as? RMShowOperation {
      operation.presenter.dismiss(withCompletion: completion)
    }
    return true
  }

  public func cancelPendingDisplayMessages() {
    queue.cancelAllOperations()
  }

  // MARK: RMessageDelegate Methods

  /**
   Call this method to notify any presenting or on screen messages that the interface has rotated.
   Ideally should go inside the calling view controllers viewWillTransitionToSize:withTransitionCoordinator: method.
   */
  public func interfaceDidRotate() {
    if let operation = queue.operations.first as? RMShowOperation, operation.presenter.screenStatus == .presenting {
      operation.presenter.interfaceDidRotate()
    }
  }
}
