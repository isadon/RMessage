//
//  RMessage+Presentation.swift
//  RMessageDemo
//
//  Created by Adonis Peralta on 8/6/18.
//  Copyright © 2018 None. All rights reserved.
//

import Foundation
import UIKit

extension RMessage {
  func calculateSpringAnimationPadding() {
    if spec.disableSpringAnimationPadding {
      springAnimationPadding = 0
      springAnimationPaddingCalculated = true
      return
    }

    // Pass in the expected superview since we don't have one yet
    // Allow the labels to size themselves by telling them their layout width
    sizeContentViewLabelsLayoutWidth(toSuperview: viewController.view!)

    // Tell the view to relayout
    layoutIfNeeded()

    // Base the spring animation padding on an estimated height considering we need the spring animation padding itself
    // to truly calculate the height of the view.
    springAnimationPadding = CGFloat(ceilf(Float(bounds.size.height) / 120.0) * 5)
    springAnimationPaddingCalculated = true
  }

  /** Present the message view */
  func present() {
    animateMessage()
    if spec.durationType == .automatic {
      perform(#selector(dismiss), with: nil, afterDelay: dimissTime)
    }
  }

  func animateMessage() {
    DispatchQueue.main.async {
      self.setupLayout()
      self.superview!.layoutIfNeeded()
      if !self.spec.blurBackground { self.alpha = 0 }
      UIView.animate(
        withDuration: self.animationDuration + 0.2, delay: 0,
        usingSpringWithDamping: 0.7,
        initialSpringVelocity: 0,
        options: [.curveEaseInOut, .beginFromCurrentState, .allowUserInteraction],
        animations: {
          self.topToVCLayoutConstraint.isActive = false
          self.topToVCLayoutConstraint = self.topToVCFinalConstraint!
          self.topToVCLayoutConstraint.isActive = true
          self.isPresenting = true
          self.delegate?.messageViewIsPresenting?(self)
          if !self.spec.blurBackground { self.alpha = self.targetAlpha }
          self.superview!.layoutIfNeeded()
        }, completion: { _ in
          self.isPresenting = false
          self.isFullyDisplayed = true
          self.delegate?.messageViewDidPresent?(self)
          self.presentCompletion?()
        }
      )
    }
  }

  /** Dismiss the view with a completion block */
  @objc func dismiss(withCompletion completion: (() -> Void)? = nil) {
    DispatchQueue.main.async {
      NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.dismiss), object: nil)
      assert(self.superview != nil, "RMessage instance must have a superview by this point!")
      self.isFullyDisplayed = false
      self.superview!.layoutIfNeeded()
      UIView.animate(withDuration: self.animationDuration, animations: {
        if !self.spec.blurBackground { self.alpha = 0 }
        self.topToVCLayoutConstraint.isActive = false
        self.topToVCLayoutConstraint = self.topToVCStartingConstraint
        self.topToVCLayoutConstraint.isActive = true
        self.superview!.layoutIfNeeded()
      }, completion: { _ in
        self.removeFromSuperview()
        self.delegate?.messageViewDidDismiss?(self)
        self.dismissCompletion?()
        completion?()
      })
    }
  }
}
