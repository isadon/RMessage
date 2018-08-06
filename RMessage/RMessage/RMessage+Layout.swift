//
//  RMessage+Layout.swift
//  RMessageDemo
//
//  Created by Adonis Peralta on 8/6/18.
//  Copyright © 2018 None. All rights reserved.
//

import Foundation
import UIKit

extension RMessage {
  func setupLayout() {
    translatesAutoresizingMaskIntoConstraints = false
    if titleLabel.text == nil || bodyLabel.text == nil { titleBodyVerticalSpacingConstraint.constant = 0 }

    calculateSpringAnimationPadding()
    setupContentViewLayoutGuideConstraint()
    setupFinalAnimationConstraints()

    // Add RMessage to superview and prepare the ending constraints
    if superview == nil { viewController.view.addSubview(self) }

    // Keep this assert here in case the logic to add RMessage to a superview gets complex at some point
    assert(superview != nil, "RMessage instance must have a superview by this point!")

    setupStartingAnimationConstraints()

    centerXAnchor.constraint(equalTo: superview!.centerXAnchor).isActive = true
    leadingAnchor.constraint(equalTo: superview!.leadingAnchor).isActive = true
    trailingAnchor.constraint(equalTo: superview!.trailingAnchor).isActive = true
    contentViewSafeAreaGuideConstraint.isActive = true
    topToVCLayoutConstraint.isActive = true
  }

  // MARK: - Respond to Layout Changes

  override func layoutSubviews() {
    super.layoutSubviews()
    if let leftView = leftView, messageSpecIconImageViewSet, spec.iconImageRelativeCornerRadius > 0 {
      leftView.layer.cornerRadius = spec.iconImageRelativeCornerRadius * leftView.bounds.size.width
    }

    if spec.cornerRadius >= 0 { layer.cornerRadius = spec.cornerRadius }
    if let superview = superview {
      sizeContentViewLabelsLayoutWidth(toSuperview: superview)
    }
  }

  override func safeAreaInsetsDidChange() {
    var constant = CGFloat(0)
    if targetPosition == .bottom {
      constant = springAnimationPadding + viewController.view.safeAreaInsets.bottom
    } else {
      constant = -springAnimationPadding - viewController.view.safeAreaInsets.top
    }
    topToVCFinalConstraint?.constant = constant
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
}
