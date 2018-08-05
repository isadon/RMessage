//
//  RMessage+SetupConstraints.swift
//  RMessageDemo
//
//  Created by Adonis Peralta on 8/6/18.
//  Copyright © 2018 None. All rights reserved.
//

import Foundation
import UIKit

extension RMessage {
  func setupContentViewLayoutGuideConstraint() {
    // Install a constraint that guarantees the title subtitle container view is properly spaced from the top layout
    // guide when animating from top or the bottom layout guide when animating from bottom
    let safeAreaLayoutGuide = viewController.view.safeAreaLayoutGuide
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
    contentViewSafeAreaGuideConstraint.priority = UILayoutPriority(rawValue: 749)
  }

  func setupStartingAnimationConstraints() {
    assert(superview != nil, "instance must have a superview by this point")
    if targetPosition != .bottom {
      topToVCLayoutConstraint = bottomAnchor.constraint(equalTo: superview!.topAnchor)
    } else {
      topToVCLayoutConstraint = topAnchor.constraint(equalTo: superview!.bottomAnchor)
    }
    topToVCStartingConstraint = topToVCLayoutConstraint
  }

  func setupFinalAnimationConstraints() {
    assert(springAnimationPaddingCalculated, "spring animation padding must have been calculated by now!")
    var viewAttribute: NSLayoutAttribute
    var layoutGuideAttribute: NSLayoutAttribute
    var constant = CGFloat(0)

    layoutIfNeeded()
    if targetPosition == .bottom {
      viewAttribute = .bottom
      layoutGuideAttribute = .bottom
      constant = springAnimationPadding + viewController.view.safeAreaInsets.bottom
    } else {
      viewAttribute = .top
      layoutGuideAttribute = .top
      constant = -springAnimationPadding - viewController.view.safeAreaInsets.top
    }

    topToVCFinalConstraint = NSLayoutConstraint(
      item: self, attribute: viewAttribute, relatedBy: .equal,
      toItem: viewController.view.safeAreaLayoutGuide,
      attribute: layoutGuideAttribute, multiplier: 1,
      constant: constant
    )
    topToVCFinalConstraint!.constant += spec.verticalOffset
  }

  func setupLabelConstraintsToSizeToFit() {
    assert(superview != nil, "RMessage instance must have a superview by this point!")
    guard spec.titleBodyLabelsSizeToFit else {
      return
    }
    if let trailingConstraint = contentViewTrailingConstraint {
      trailingConstraint.isActive = false
    }

    NSLayoutConstraint.deactivate([
      titleLabelLeadingConstraint, titleLabelTrailingConstraint,
      bodyLabelLeadingConstraint, bodyLabelTrailingConstraint,
    ])

    titleLabelLeadingConstraint = titleLabel.leadingAnchor.constraint(greaterThanOrEqualTo: contentView.leadingAnchor)
    titleLabelTrailingConstraint = titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor)
    bodyLabelLeadingConstraint = bodyLabel.leadingAnchor.constraint(greaterThanOrEqualTo: contentView.leadingAnchor)
    bodyLabelTrailingConstraint = bodyLabel.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor)
    NSLayoutConstraint.activate([
      titleLabelLeadingConstraint, titleLabelTrailingConstraint,
      bodyLabelLeadingConstraint, bodyLabelTrailingConstraint,
    ])
  }
}
