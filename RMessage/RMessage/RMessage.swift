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

class RMessage: UIView, RMessageAnimatorDelegate, UIGestureRecognizerDelegate {
  /* Animation constants */
  private let animationDuration = 0.5
  private let onScreenTime = 1.5
  private let extraOnScreenTimePerPixel = 0.04

  weak var delegate: RMessageDelegate?

  private(set) var spec: RMessageSpec
  private(set) var targetPosition: RMessagePosition
  var dimissTime: TimeInterval {
    switch spec.durationType {
    case .automatic:
      return animationDuration + onScreenTime + Double(bounds.size.height) * extraOnScreenTimePerPixel
    case .tap, .swipe, .tapSwipe, .endless:
      return -1
    case .custom:
      return abs(spec.timeToDismiss)
    }
  }

  /** The view controller this message is displayed in */
  private(set) lazy var viewController: UIViewController = UIWindow.defaultViewControllerForPresentation()

  @IBOutlet private(set) var containerView: UIView!

  @IBOutlet private(set) var contentView: UIView!

  private(set) var leftView: UIView?
  private(set) var rightView: UIView?
  private(set) var backgroundView: UIView?

  @IBOutlet private(set) var titleLabel: UILabel!
  @IBOutlet private(set) var bodyLabel: UILabel!

  @IBOutlet private var titleBodyVerticalSpacingConstraint: NSLayoutConstraint!
  @IBOutlet private var titleLabelLeadingConstraint: NSLayoutConstraint!
  @IBOutlet private var titleLabelTrailingConstraint: NSLayoutConstraint!
  @IBOutlet private var bodyLabelLeadingConstraint: NSLayoutConstraint!
  @IBOutlet private var bodyLabelTrailingConstraint: NSLayoutConstraint!

  @IBOutlet private var contentViewTrailingConstraint: NSLayoutConstraint!

  private lazy var animator: RMessageAnimator = {
    var animator = SlideAnimator(
      targetPosition: targetPosition, view: self, superview: viewController.view,
      contentView: contentView
    )
    animator.delegate = self
    animator.disableAnimationPadding = spec.disableSpringAnimationPadding
    animator.animationPresentDuration = animationDuration
    animator.animationDismissDuration = animationDuration - 0.2
    animator.animationStartAlpha = 0
    /* As per apple docs when using UIVisualEffectView and blurring the superview of the blur view
     must have an opacity of 1.f */
    animator.animationEndAlpha = spec.blurBackground ? 1.0 : spec.targetAlpha
    return animator
  }()

  /** Is the message currently in the process of presenting, but not yet displayed? */
  private(set) var isPresenting = false

  /** Is the message currently on screen, fully displayed? */
  private(set) var isFullyDisplayed = false

  /** Callback block called after the user taps on the message */
  private(set) var tapCompletion: (() -> Void)?

  /** Callback block called after the message finishes presenting */
  private(set) var presentCompletion: (() -> Void)?

  /** Callback block called after the message finishes dismissing */
  private(set) var dismissCompletion: (() -> Void)?

  var messageSpecIconImageViewSet = false

  var messageSpecBackgroundImageViewSet = false

  var springAnimationPaddingCalculated = false

  // MARK: Instance Methods

  init?(
    spec: RMessageSpec, targetPosition: RMessagePosition = .top, title: String, body: String?,
    viewController: UIViewController? = nil, leftView: UIView? = nil, rightView: UIView? = nil, backgroundView: UIView? = nil, tapCompletion: (() -> Void)? = nil, presentCompletion: (() -> Void)? = nil, dismissCompletion: (() -> Void)? = nil
  ) {
    self.spec = spec
    self.targetPosition = targetPosition
    self.tapCompletion = tapCompletion
    self.presentCompletion = presentCompletion
    self.dismissCompletion = dismissCompletion
    self.leftView = leftView
    self.rightView = rightView
    self.backgroundView = backgroundView

    super.init(frame: CGRect.zero)

    loadNib()

    titleLabel.text = title
    bodyLabel.text = body

    accessibilityIdentifier = String(describing: type(of: self))
    if let viewController = viewController {
      self.viewController = viewController
    }

    setupComponents(withMessageSpec: spec)
    setupDesign(withMessageSpec: spec, titleLabel: titleLabel, bodyLabel: bodyLabel)
    setupGestureRecognizers()
  }

  required init?(coder aDecoder: NSCoder) {
    spec = DefaultRMessageSpec()
    targetPosition = .top
    tapCompletion = nil
    presentCompletion = nil
    dismissCompletion = nil
    super.init(coder: aDecoder)
  }

  private func loadNib() {
    Bundle(for: RMessage.self).loadNibNamed(String(describing: RMessage.self), owner: self, options: nil)
    containerView.translatesAutoresizingMaskIntoConstraints = false

    addSubview(containerView)

    containerView.topAnchor.constraint(equalTo: topAnchor).isActive = true
    containerView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    containerView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
    containerView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
  }

  func setupComponents(withMessageSpec spec: RMessageSpec) {
    if let image = spec.iconImage, leftView == nil {
      leftView = iconImageView(withImage: image, imageTintColor: spec.iconImageTintColor, superview: self)
    }

    // Let any left view passed in programmatically override any icon image view initiated via a message spec
    if let leftView = leftView {
      setup(leftView: leftView, inSuperview: self)
    }

    if let rightView = rightView {
      setup(rightView: rightView, inSuperview: self)
    }

    if let backgroundImage = spec.backgroundImage, backgroundView == nil {
      backgroundView = backgroundImageView(withImage: backgroundImage, superview: self)
    }

    // Let any background view passed in programmatically override any background image view initiated
    // via a message spec
    if let backgroundView = backgroundView {
      setup(backgroundView: backgroundView, inSuperview: self)
    }

    if spec.blurBackground {
      setupBlurBackgroundView(inSuperview: self)
    }
  }
  override func safeAreaInsetsDidChange() {
    animator.safeAreaInsetsDidChange?(forView: self)
  }

  func interfaceDidRotate() {
    if isPresenting && spec.durationType != .endless {
      // Cancel the previous dismissal and restart dismissal clock
      DispatchQueue.main.async {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.dismiss), object: nil)
        self.perform(#selector(self.dismiss), with: nil, afterDelay: self.dimissTime)
      }
    }
  }

  /** Present the message */
  func present(withCompletion completion: (() -> Void)? = nil) {
    animator.present(withCompletion: completion)
    if spec.durationType == .automatic {
      perform(#selector(animator.dismiss), with: nil, afterDelay: dimissTime)
    }
  }

  @objc func dismiss(withCompletion completion: (() -> Void)? = nil) {
    NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(animator.dismiss), object: nil)
    animator.dismiss(withCompletion: completion)
  }

  // MARK: - RMessageAnimatorDelegate Methods

  func animatorWillLayout(animator _: RMessageAnimator) {
    if titleLabel.text == nil || bodyLabel.text == nil { titleBodyVerticalSpacingConstraint.constant = 0 }
  }

  func animatorDidLayout(animator _: RMessageAnimator) {
    // Pass in the expected superview since we don't have one yet
    // Allow the labels to size themselves by telling them their layout width
    guard let superview = superview else {
      return
    }
    setPreferredLayoutWidth(
      forTitleLabel: titleLabel, bodyLabel: bodyLabel, inSuperview: superview,
      sizingToFit: spec.titleBodyLabelsSizeToFit
    )
  }

  func animationBlockForPresentation(animator _: RMessageAnimator) {
    isPresenting = true
    delegate?.messageIsPresenting?(self)
  }

  func animatorDidPresent(animator _: RMessageAnimator) {
    isPresenting = false
    isFullyDisplayed = true
    delegate?.messageDidPresent?(self)
    presentCompletion?()
  }

  func animatorDidDismiss(animator _: RMessageAnimator) {
    delegate?.messageDidDismiss?(self)
    dismissCompletion?()
  }

  func animatorWillAnimateDismissal(animator _: RMessageAnimator) {
    isFullyDisplayed = false
  }
}
