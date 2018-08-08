//
//  RMessageAnimator.swift
//  RMessageDemo
//
//  Created by Adonis Peralta on 8/6/18.
//  Copyright © 2018 None. All rights reserved.
//

import Foundation
import UIKit

@objc protocol RMessageAnimator {
  /// Tells the animator to present the view with its animation.
  ///
  /// - Parameter completion: A code block to be run after the animation finishes presenting.
  @objc func present(withCompletion completion: (() -> Void)?)

  /// Tells the animator to dismiss the view with its animation.
  ///
  /// - Parameter completion: A code block to be run after the animation finishes dismissing.
  @objc func dismiss(withCompletion completion: (() -> Void)?)

  /// Notifies the animator that the views' superview safe area did change.
  ///
  /// - Parameter view: The view whose safe area changed.
  @objc optional func safeAreaInsetsDidChange(forView view: UIView)
}

@objc protocol RMessageAnimatorDelegate {
  /// Notifies the animator delegate the animator will soon start to layout the view it manages.
  /// - Parameter animator: The animator instance doing the layout.
  @objc optional func animatorWillLayout(animator: RMessageAnimator)

  /// Notifies the animator delegate the animator did layout the view it manages.
  /// - Parameter animator: The animator instance doing the layout.
  @objc optional func animatorDidLayout(animator: RMessageAnimator)

  /// Notifies the animator delegate that the animator did add the view to its superview.
  ///
  /// - Parameter animator: The animator instance doing the layout.
  @objc optional func animatorDidAddToSuperview(animator: RMessageAnimator)

  /// Notifies the animator delegate to perform any animation changes for the presentation of the view.
  ///
  /// - Parameter animator: The animator instance.
  @objc optional func animationBlockForPresentation(animator: RMessageAnimator)

  /// Notifies the animator delegate to perform any animation changes for the dismissal of the view.
  ///
  /// - Parameter animator: The animator instance.
  @objc optional func animationBlockForDismissal(animator: RMessageAnimator)

  /// Notifies the animator delegate that the animator will soon animate the presentation.
  ///
  /// - Parameter animator: The animator instance.
  @objc optional func animatorWillAnimatePresentation(animator: RMessageAnimator)

  /// Notifies the animator delegate that the animator will soon animate the dismissal.
  ///
  /// - Parameter animator: The animator instance.
  @objc optional func animatorWillAnimateDismissal(animator: RMessageAnimator)

  /// Notifies the animator delegate that the animator has fully presented the view.
  ///
  /// - Parameter animator: The animator instance.
  @objc optional func animatorDidPresent(animator: RMessageAnimator)

  /// Notifies the animator delegate that the animator has dismissed the view from the screen.
  ///
  /// - Parameter animator: The animator instance.
  @objc optional func animatorDidDismiss(animator: RMessageAnimator)
}
