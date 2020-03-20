//
//  SlideAnimator.swift
//
//  Created by Adonis Peralta on 8/6/18.
//  Copyright © 2018 None. All rights reserved.
//

import Foundation
import UIKit

private enum Constants {
  enum KVC {
    static let safeAreaInsets = "view.safeAreaInsets"
  }
}

/// Implements an animator that slides the message from the top to target position or
/// bottom to target position. This animator handles the layout of its managed view in the managed
/// view's superview.
class SlideAnimator: NSObject, RMAnimator {
  /// Animator delegate.
  weak var delegate: RMessageAnimatorDelegate?

  // MARK: - Start the customizable animation properties

  /// The amount of time to perform the presentation animation in.
  var presentationDuration = 0.5

  /// The amount of time to perform the dismiss animation in.
  var dismissalDuration = 0.3

  /// The alpha value the view should have prior to starting animations.
  var animationStartAlpha: CGFloat = 0

  /// The alpha value the view should have at the end of animations.
  var animationEndAlpha: CGFloat = 1

  /// A custom vertical offset to apply to the animation. positive values move the view upward,
  /// negative values move it downward.
  var verticalOffset = CGFloat(0)

  /// Enables/disables the use animation padding so as to prevent a visual white gap from appearing when
  /// animating with a spring animation.
  var disableAnimationPadding = false

  private let superview: UIView
  @objc private let view: UIView
  private let contentView: UIView

  private let targetPosition: RMessagePosition

  /** The starting animation constraint for the view */
  private var viewStartConstraint: NSLayoutConstraint?

  /** The ending animation constraint for the view */
  private var viewEndConstraint: NSLayoutConstraint?

  private var contentViewSafeAreaGuideConstraint: NSLayoutConstraint?

  /** The amount of vertical padding/height to add to RMessage's height so as to perform a spring animation without
   visually showing an empty gap due to the spring animation overbounce. This value changes dynamically due to
   iOS changing the overbounce dynamically according to view size. */
  private var springAnimationPadding = CGFloat(0)

  private var springAnimationPaddingCalculated = false

  private var isPresenting = false
  private var isDismissing = false
  private var hasPresented = false
  private var hasDismissed = true

  private var kvcContext = 0

  init(targetPosition: RMessagePosition, view: UIView, superview: UIView, contentView: UIView) {
    self.targetPosition = targetPosition
    self.superview = superview
    self.contentView = contentView
    self.view = view
    super.init()

    // Sign up to be notified for when the safe area of our view changes
    addObserver(self, forKeyPath: Constants.KVC.safeAreaInsets, options: [.new], context: &kvcContext)
  }

  /// Ask the animator to present the view with animation. This call may or may not succeed depending on whether
  /// the animator was already previously asked to animate or where in the presentation cycle the animator is.
  /// In cases when the animator refuses to present this method returns false, otherwise it returns true.
  ///
  /// - Note: Your implementation of this method must allow for this method to be called multiple times by ignoring
  /// subsequent requests.
  /// - Parameter completion: A completion closure to execute after presentation is complete.
  /// - Returns: A boolean value indicating if the animator executed your instruction to present.
  func present(withCompletion completion: (() -> Void)?) -> Bool {
    // Guard against being called under the following conditions:
    // 1. If currently presenting or dismissing
    // 2. If already presented or have not yet dismissed
    guard !isPresenting && !hasPresented && hasDismissed else {
      return false
    }

    layoutView()
    setupFinalAnimationConstraints()
    setupStartingAnimationConstraints()
    delegate?.animatorWillAnimatePresentation?(self)
    animatePresentation(withCompletion: completion)

    return true
  }

  /// Ask the animator to dismiss the view with animation. This call may or may not succeed depending on whether
  /// the animator was already previously asked to animate or where in the presentation cycle the animator is.
  /// In cases when the animator refuses to dismiss this method returns false, otherwise it returns true.
  ///
  /// - Note: Your implementation of this method must allow for this method to be called multiple times by ignoring
  /// subsequent requests.
  /// - Parameter completion: A completion closure to execute after presentation is complete.
  /// - Returns: A boolean value indicating if the animator executed your instruction to dismiss.
  func dismiss(withCompletion completion: (() -> Void)?) -> Bool {
    // Guard against being called under the following conditions:
    // 1. If currently presenting or dismissing
    // 2. If already dismissed or have not yet presented
    guard !isDismissing && hasDismissed && hasPresented else {
      return false
    }

    delegate?.animatorWillAnimateDismissal?(self)
    animateDismissal(withCompletion: completion)

    return true
  }

  private func animatePresentation(withCompletion completion: (() -> Void)?) {
    guard let viewSuper = view.superview else {
      assertionFailure("view must have superview by this point")
      return
    }

    guard let viewStartConstraint = viewStartConstraint, let viewEndConstraint = viewEndConstraint else { return }

    isPresenting = true
    viewStartConstraint.isActive = true

    DispatchQueue.main.async {
      viewSuper.layoutIfNeeded()
      self.view.alpha = self.animationStartAlpha

      // For now lets be safe and not call this code inside the animation block. Though there may be some slight timing
      // issue in notifying exactly when the animator is animating it should be fine.
      self.delegate?.animatorIsAnimatingPresentation?(self)

      UIView.animate(
        withDuration: self.presentationDuration, delay: 0,
        usingSpringWithDamping: 0.7,
        initialSpringVelocity: 0,
        options: [.curveEaseInOut, .beginFromCurrentState, .allowUserInteraction],
        animations: {
          viewStartConstraint.isActive = false
          viewEndConstraint.isActive = true
          self.contentViewSafeAreaGuideConstraint?.isActive = true
          self.delegate?.animationBlockForPresentation?(self)
          self.view.alpha = self.animationEndAlpha
          viewSuper.layoutIfNeeded()
        }, completion: { finished in
          self.isPresenting = false
          self.hasPresented = true
          self.delegate?.animatorDidPresent?(self)
          if finished { completion?() }
        }
      )
    }
  }

  /** Dismiss the view with a completion block */
  private func animateDismissal(withCompletion completion: (() -> Void)?) {
    guard let viewSuper = view.superview else {
      assertionFailure("view must have superview by this point")
      return
    }

    guard let viewStartConstraint = viewStartConstraint, let viewEndConstraint = viewEndConstraint else { return }

    isDismissing = true
    DispatchQueue.main.async {
      viewSuper.layoutIfNeeded()

      // For now lets be safe and not call this code inside the animation block. Though there may be some slight timing
      // issue in notifying exactly when the animator is animating it should be fine.
      self.delegate?.animatorIsAnimatingDismissal?(self)

      UIView.animate(
        withDuration: self.dismissalDuration, animations: {
          viewEndConstraint.isActive = false
          self.contentViewSafeAreaGuideConstraint?.isActive = false
          viewStartConstraint.isActive = true
          self.delegate?.animationBlockForDismissal?(self)
          self.view.alpha = self.animationStartAlpha
          viewSuper.layoutIfNeeded()
        }, completion: { finished in
          self.isDismissing = false
          self.hasPresented = false
          self.hasDismissed = true
          self.view.removeFromSuperview()
          self.delegate?.animatorDidDismiss?(self)
          if finished { completion?() }
        }
      )
    }
  }

  // MARK: - View notifications

  override func observeValue(
    forKeyPath keyPath: String?, of _: Any?, change _: [NSKeyValueChangeKey: Any]?,
    context _: UnsafeMutableRawPointer?
  ) {
    if keyPath == Constants.KVC.safeAreaInsets {
      safeAreaInsetsDidChange(forView: view)
    }
  }

  private func safeAreaInsetsDidChange(forView view: UIView) {
    var constant = CGFloat(0)
    if targetPosition == .bottom {
      constant = springAnimationPadding + view.safeAreaInsets.bottom
    } else {
      constant = -springAnimationPadding - view.safeAreaInsets.top
    }
    viewEndConstraint?.constant = constant
  }

  // MARK: - Layout

  /// Lay's out the view in its superview for presentation
  private func layoutView() {
    setupContentViewLayoutGuideConstraint()

    // Add RMessage to superview and prepare the ending constraints
    if view.superview == nil { superview.addSubview(view) }
    view.translatesAutoresizingMaskIntoConstraints = false

    delegate?.animatorDidAddToSuperview?(self)

    NSLayoutConstraint.activate([
      view.centerXAnchor.constraint(equalTo: superview.centerXAnchor),
      view.leadingAnchor.constraint(equalTo: superview.leadingAnchor),
      view.trailingAnchor.constraint(equalTo: superview.trailingAnchor)
      ])

    delegate?.animatorDidLayout?(self)
    calculateSpringAnimationPadding()
  }

  private func setupContentViewLayoutGuideConstraint() {
    // Install a constraint that guarantees the title subtitle container view is properly spaced from the top layout
    // guide when animating from top or the bottom layout guide when animating from bottom
    let safeAreaLayoutGuide = superview.safeAreaLayoutGuide

    switch targetPosition {
    case .top, .navBarOverlay:
      contentViewSafeAreaGuideConstraint = contentView.topAnchor.constraint(
        equalTo: safeAreaLayoutGuide.topAnchor,
        constant: 10
      )
    case .bottom:
      contentViewSafeAreaGuideConstraint = contentView.bottomAnchor.constraint(
        equalTo: safeAreaLayoutGuide.bottomAnchor,
        constant: -10
      )
    }
  }

  private func setupStartingAnimationConstraints() {
    guard let viewSuper = view.superview else {
      assertionFailure("view must have superview by this point")
      return
    }

    if targetPosition != .bottom {
      viewStartConstraint = view.bottomAnchor.constraint(equalTo: viewSuper.topAnchor)
    } else {
      viewStartConstraint = view.topAnchor.constraint(equalTo: viewSuper.bottomAnchor)
    }
  }

  private func setupFinalAnimationConstraints() {
    assert(springAnimationPaddingCalculated, "spring animation padding must have been calculated by now!")

    guard let viewSuper = view.superview else {
      assertionFailure("view must have superview by this point")
      return
    }

    var viewAttribute: NSLayoutConstraint.Attribute
    var layoutGuideAttribute: NSLayoutConstraint.Attribute
    var constant = CGFloat(0)

    view.layoutIfNeeded()
    if targetPosition == .bottom {
      viewAttribute = .bottom
      layoutGuideAttribute = .bottom
      constant = springAnimationPadding + viewSuper.safeAreaInsets.bottom
    } else {
      viewAttribute = .top
      layoutGuideAttribute = .top
      constant = -springAnimationPadding - viewSuper.safeAreaInsets.top
    }

    viewEndConstraint = NSLayoutConstraint(
      item: view, attribute: viewAttribute, relatedBy: .equal,
      toItem: viewSuper.safeAreaLayoutGuide,
      attribute: layoutGuideAttribute, multiplier: 1,
      constant: constant
    )
    viewEndConstraint?.constant += verticalOffset
  }

  // Calculate the padding after the view has had a chance to perform its own custom layout changes via the delegate
  // call to animatorWillLayout, animatorDidLayout
  private func calculateSpringAnimationPadding() {
    guard !disableAnimationPadding else {
      springAnimationPadding = CGFloat(0)
      springAnimationPaddingCalculated = true
      return
    }

    // Tell the view to layout so that we may properly calculate the spring padding
    view.layoutIfNeeded()

    // Base the spring animation padding on an estimated height considering we need the spring animation padding itself
    // to truly calculate the height of the view.

    springAnimationPadding = (view.bounds.size.height / 120.0).rounded(.up) * 5
    springAnimationPaddingCalculated = true
  }

  deinit {
    removeObserver(self, forKeyPath: Constants.KVC.safeAreaInsets)
  }
}
