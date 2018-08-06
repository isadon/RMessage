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

class RMessage: UIView, UIGestureRecognizerDelegate {
  /* Animation constants */
  let animationDuration = 0.3
  let onScreenTime = 1.5
  let extraOnScreenTimePerPixel = 0.04

  weak var delegate: RMessageDelegate?

  let spec: RMessageSpec
  let targetPosition: RMessagePosition
  var dimissTime: TimeInterval {
    switch spec.durationType {
    case .automatic:
      return animationDuration + onScreenTime + Double(frame.size.height) * extraOnScreenTimePerPixel
    case .tap, .swipe, .tapSwipe, .endless:
      return -1
    case .custom:
      return abs(spec.timeToDismiss)
    }
  }

  /** The view controller this message is displayed in */
  lazy var viewController: UIViewController = defaultViewControllerForPresentation()

  @IBOutlet var containerView: UIView!

  @IBOutlet private(set) var contentView: UIView!

  var leftView: UIView?
  var rightView: UIView?
  var backgroundView: UIView?

  @IBOutlet private(set) var titleLabel: UILabel!
  @IBOutlet private(set) var bodyLabel: UILabel!

  @IBOutlet var titleBodyVerticalSpacingConstraint: NSLayoutConstraint!
  @IBOutlet var titleLabelLeadingConstraint: NSLayoutConstraint!
  @IBOutlet var titleLabelTrailingConstraint: NSLayoutConstraint!
  @IBOutlet var bodyLabelLeadingConstraint: NSLayoutConstraint!
  @IBOutlet var bodyLabelTrailingConstraint: NSLayoutConstraint!

  var contentViewSafeAreaGuideConstraint: NSLayoutConstraint
  @IBOutlet var contentViewTrailingConstraint: NSLayoutConstraint!

  /** The final constant value that should be set for the topToVCTopLayoutConstraint when animating */
  var topToVCFinalConstraint: NSLayoutConstraint?

  lazy var topToVCStartingConstraint: NSLayoutConstraint = {
    assert(superview != nil, "RMessage instance must have a superview by this point!")
    return topToVCLayoutConstraint
  }()

  /** The vertical space between the message view top to its view controller top */
  lazy var topToVCLayoutConstraint: NSLayoutConstraint = {
    assert(superview != nil, "RMessage instance must have a superview by this point!")
    if targetPosition != .bottom {
      return NSLayoutConstraint(
        item: self, attribute: .bottom, relatedBy: .equal,
        toItem: superview!, attribute: .top, multiplier: 1, constant: 0
      )
    } else {
      return NSLayoutConstraint(
        item: self, attribute: .top, relatedBy: .equal, toItem: superview!,
        attribute: .bottom, multiplier: 1, constant: 0
      )
    }
  }()

  /** The opacity of the message view. When customizing RMessage always set this value to the desired opacity instead of
   the alpha property. ly the alpha property is changed during animations; this property allows RMessage to
   always know the final alpha value. */
  var targetAlpha = CGFloat(0.97)

  /** The amount of vertical padding/height to add to RMessage's height so as to perform a spring animation without
   visually showing an empty gap due to the spring animation overbounce. This value changes dynamically due to
   iOS changing the overbounce dynamically according to view size. */
  var springAnimationPadding = CGFloat(5.0)

  /** Is the message currently in the process of presenting, but not yet displayed? */
  var isPresenting = false

  /** Is the message currently on screen, fully displayed? */
  var isFullyDisplayed = false

  /** Callback block called after the user taps on the messageView */
  let tapCompletion: (() -> Void)?

  /** Callback block called after the messageView finishes presenting */
  let presentCompletion: (() -> Void)?

  /** Callback block called after the messageView finishes dismissing */
  let dismissCompletion: (() -> Void)?

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
    targetAlpha = spec.targetAlpha

    contentViewSafeAreaGuideConstraint = NSLayoutConstraint()
    super.init(frame: CGRect.zero)

    loadNib()

    titleLabel.text = title
    bodyLabel.text = body

    accessibilityIdentifier = String(describing: type(of: self))
    if let viewController = viewController {
      self.viewController = viewController
    }
    setupComponents()
    setupDesign()
    setupGestureRecognizers()
  }

  required init?(coder aDecoder: NSCoder) {
    spec = DefaultRMessageSpec()
    targetPosition = .top
    tapCompletion = nil
    presentCompletion = nil
    dismissCompletion = nil
    contentViewSafeAreaGuideConstraint = NSLayoutConstraint()
    super.init(coder: aDecoder)
  }

  func loadNib() {
    Bundle(for: RMessage.self).loadNibNamed(String(describing: RMessage.self), owner: self, options: nil)
    containerView.translatesAutoresizingMaskIntoConstraints = false

    addSubview(containerView)

    containerView.topAnchor.constraint(equalTo: topAnchor).isActive = true
    containerView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    containerView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
    containerView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
  }
}
