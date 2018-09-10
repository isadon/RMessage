//
//  RMAnimator.swift
//
//  Created by Adonis Peralta on 8/6/18.
//  Copyright © 2018 None. All rights reserved.
//

import Foundation
import UIKit

@objc public protocol RMAnimator {
  /// The delegate of the animator.
  var delegate: RMessageAnimatorDelegate? { get set }

  /// The duration of the presentation animation.
  var presentationDuration: Double { get set }

  /// The duration of the dismissal animation.
  var dismissalDuration: Double { get set }

  /// Ask the animator to present the view with animation. This call may or may not succeed depending on whether
  /// the animator was already previously asked to animate or where in the presentation cycle the animator is.
  /// In cases when the animator refuses to present this method returns false, otherwise it returns true.
  ///
  /// - Note: Your implementation of this method must allow for this method to be called multiple times by ignoring
  /// subsequent requests.
  /// - Parameter completion: A completion closure to execute after presentation is complete.
  /// - Returns: A boolean value indicating if the animator executed your instruction to present.
  func present(withCompletion completion: (() -> Void)?) -> Bool

  /// Ask the animator to dismiss the view with animation. This call may or may not succeed depending on whether
  /// the animator was already previously asked to animate or where in the presentation cycle the animator is.
  /// In cases when the animator refuses to dismiss this method returns false, otherwise it returns true.
  ///
  /// - Note: Your implementation of this method must allow for this method to be called multiple times by ignoring
  /// subsequent requests.
  /// - Parameter completion: A completion closure to execute after presentation is complete.
  /// - Returns: A boolean value indicating if the animator executed your instruction to dismiss.
  func dismiss(withCompletion completion: (() -> Void)?) -> Bool
}

@objc public protocol RMessageAnimatorDelegate {
  /// Notifies the animator delegate the animator will soon start to layout the view it manages.
  /// - Parameter animator: The animator instance doing the layout.
  @objc optional func animatorWillLayout(_ animator: RMAnimator)

  /// Notifies the animator delegate the animator did layout the view it manages.
  /// - Parameter animator: The animator instance doing the layout.
  @objc optional func animatorDidLayout(_ animator: RMAnimator)

  /// Notifies the animator delegate that the animator did add the view to its superview.
  ///
  /// - Parameter animator: The animator instance doing the layout.
  @objc optional func animatorDidAddToSuperview(_ animator: RMAnimator)

  /// Notifies the animator delegate to perform any animation changes for the presentation of the view.
  ///
  /// - Parameter animator: The animator instance.
  @objc optional func animationBlockForPresentation(_ animator: RMAnimator)

  /// Notifies the animator delegate to perform any animation changes for the dismissal of the view.
  ///
  /// - Parameter animator: The animator instance.
  @objc optional func animationBlockForDismissal(_ animator: RMAnimator)

  /// Notifies the animator delegate that the animator will soon animate the presentation.
  ///
  /// - Parameter animator: The animator instance.
  @objc optional func animatorWillAnimatePresentation(_ animator: RMAnimator)

  /// Notifies the animator delegate that the animator is animating the presentation of the view.
  ///
  /// - Parameter animator: The animator instance.
  @objc optional func animatorIsAnimatingPresentation(_ animator: RMAnimator)

  /// Notifies the animator delegate that the animator will soon animate the dismissal of the view.
  ///
  /// - Parameter animator: The animator instance.
  @objc optional func animatorWillAnimateDismissal(_ animator: RMAnimator)

  /// Notifies the animator delegate that the animator is animating the dismissal of the view.
  ///
  /// - Parameter animator: The animator instance.
  @objc optional func animatorIsAnimatingDismissal(_ animator: RMAnimator)

  /// Notifies the animator delegate that the animator has fully presented the view.
  ///
  /// - Parameter animator: The animator instance.
  @objc optional func animatorDidPresent(_ animator: RMAnimator)

  /// Notifies the animator delegate that the animator has dismissed the view from the screen.
  ///
  /// - Parameter animator: The animator instance.
  @objc optional func animatorDidDismiss(_ animator: RMAnimator)
}
