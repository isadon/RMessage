//
//  RMPresenter.swift
//  RMessageDemo
//
//  Created by Adonis Peralta on 8/11/18.
//  Copyright © 2018 None. All rights reserved.
//

import Foundation
import UIKit

@objc class RMPresenter: NSObject, RMessageAnimatorDelegate {
  weak var delegate: RMPresenterDelegate?

  private(set) var message: RMessage
  var targetPosition: RMessagePosition

  private let animator: RMAnimator
  private(set) var presentationOpts: RMPresenterOptions
  private(set) var animationOpts: RMAnimationOptions

  var dimissTime: TimeInterval {
    switch message.spec.durationType {
    case .automatic:
      return animator.presentationDuration + animator.dismissalDuration + presentationOpts.onScreenTime + Double(message.bounds.size.height) * presentationOpts.extraOnScreenTimePerPixel
    case .tap, .swipe, .tapSwipe, .endless:
      return -1
    case .timed:
      return abs(message.spec.timeToDismiss)
    }
  }

  /** Did the message already present */
  private(set) var didPresent = false

  /** Did the message already present */
  private(set) var didDismiss = false

  /// The current presentation status of the message
  enum PresentationStatus {
    /// The message will soon present though is not on screen yet.
    case willPresent

    /// The message is on screen and presenting.
    case presenting

    /// The message is on screen but will soon dismiss.
    case willDismiss

    /// The message has started dismissing.
    case dismissing
  }

  private(set) var screenStatus: PresentationStatus = .willPresent

  /** Callback block called after the user taps on the message */
  private(set) var tapCompletion: (() -> Void)?

  /** Callback block called after the message finishes presenting */
  private(set) var presentCompletion: (() -> Void)?

  /** Callback block called after the message finishes dismissing */
  private(set) var dismissCompletion: (() -> Void)?

  init(
    message: RMessage, targetPosition: RMessagePosition, animator: RMAnimator,
    presentationOptions presentOpts: RMPresenterOptions,
    animationOptions animationOpts: RMAnimationOptions,
    tapCompletion _: (() -> Void)? = nil, presentCompletion _: (() -> Void)? = nil, dismissCompletion _: (() -> Void)? = nil
  ) {
    self.message = message
    self.targetPosition = targetPosition
    self.animator = animator
    presentationOpts = presentOpts
    self.animationOpts = animationOpts
    super.init()
    setupAnimator()
    setupGestureRecognizers()
  }

  func setupAnimator() {
    animator.delegate = self
    if let animator = animator as? SlideAnimator {
      animator.disableAnimationPadding = message.spec.disableSpringAnimationPadding
      animator.presentationDuration = animationOpts.presentationDuration
      animator.dismissalDuration = animationOpts.presentationDuration - 0.2
      animator.animationStartAlpha = 0
      /* As per apple docs when using UIVisualEffectView and blurring the superview of the blur view
       must have an opacity of 1.f */
      animator.animationEndAlpha = message.spec.blurBackground ? 1.0 : message.spec.targetAlpha
    }
  }

  /** Present the message */
  func present(withCompletion completion: (() -> Void)? = nil) {
    guard animator.present(withCompletion: completion) else {
      return
    }
    if message.spec.durationType == .automatic || message.spec.durationType == .timed {
      perform(#selector(animatorDismiss), with: nil, afterDelay: dimissTime)
    }
  }

  func dismiss(withCompletion completion: (() -> Void)? = nil) {
    guard animator.dismiss(withCompletion: completion) else {
      return
    }
    NSObject.cancelPreviousPerformRequests(
      withTarget: self,
      selector: #selector(animatorDismiss),
      object: nil
    )
  }

  @objc private func animatorDismiss() {
    _ = animator.dismiss(withCompletion: nil)
  }

  // MARK: - Respond to window events

  func interfaceDidRotate() {
    guard screenStatus == .presenting &&
      (message.spec.durationType == .automatic || message.spec.durationType == .timed) else {
      return
    }
    // Cancel the previous dismissal and restart dismissal clock
    DispatchQueue.main.async {
      NSObject.cancelPreviousPerformRequests(
        withTarget: self,
        selector: #selector(self.animator.dismiss(withCompletion:)), object: nil
      )
      NSObject.perform(#selector(self.animator.dismiss(withCompletion:)), with: nil, afterDelay: self.dimissTime)
    }
  }

  // MARK: - RMessageAnimatorDelegate Methods

  func animatorWillAnimatePresentation(_: RMAnimator) {
    screenStatus = .willPresent
    delegate?.presenterWillPresent?(self, message: message)
  }

  func animatorIsAnimatingPresentation(_: RMAnimator) {
    screenStatus = .presenting
    delegate?.presenterIsPresenting?(self, message: message)
  }

  func animatorDidPresent(_: RMAnimator) {
    didPresent = true
    delegate?.presenterDidPresent?(self, message: message)
    presentCompletion?()
  }

  func animatorWillAnimateDismissal(_: RMAnimator) {
    screenStatus = .willDismiss
    delegate?.presenterWillDismiss?(self, message: message)
  }

  func animatorIsAnimatingDismissal(_: RMAnimator) {
    screenStatus = .dismissing
    delegate?.presenterIsDismissing?(self, message: message)
  }

  func animatorDidDismiss(_: RMAnimator) {
    didDismiss = true
    delegate?.presenterDidDismiss?(self, message: message)
    dismissCompletion?()
  }
}
