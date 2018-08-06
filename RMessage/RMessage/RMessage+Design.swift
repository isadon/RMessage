//
//  RMessage+Setup.swift
//  RMessageDemo
//
//  Created by Adonis Peralta on 8/6/18.
//  Copyright © 2018 None. All rights reserved.
//

import Foundation
import UIKit

extension RMessage {
  func setupDesign() {
    setupDesignDefaults()
    setupLabelsDesign()
  }

  func setupDesignDefaults() {
    if spec.cornerRadius > 0 { clipsToBounds = true }

    backgroundColor = spec.backgroundColor
    titleLabel.numberOfLines = 0
    titleLabel.lineBreakMode = .byWordWrapping
    titleLabel.font = UIFont.boldSystemFont(ofSize: 14)
    titleLabel.textAlignment = .left
    titleLabel.textColor = .black
    titleLabel.shadowColor = nil
    titleLabel.shadowOffset = CGSize.zero
    titleLabel.backgroundColor = nil

    bodyLabel.numberOfLines = 0
    bodyLabel.lineBreakMode = .byWordWrapping
    bodyLabel.font = UIFont.boldSystemFont(ofSize: 12)
    bodyLabel.textAlignment = .left
    bodyLabel.textColor = .darkGray
    bodyLabel.shadowColor = nil
    bodyLabel.shadowOffset = CGSize.zero
    bodyLabel.backgroundColor = nil
  }

  func setupLabelsDesign() {
    titleLabel.font = spec.titleFont
    titleLabel.textAlignment = spec.titleTextAlignment
    titleLabel.textColor = spec.titleColor
    titleLabel.shadowColor = spec.titleShadowColor
    titleLabel.shadowOffset = spec.titleShadowOffset
    bodyLabel.font = spec.bodyFont
    bodyLabel.textAlignment = spec.bodyTextAlignment
    bodyLabel.textColor = spec.bodyColor
    bodyLabel.shadowColor = spec.bodyShadowColor
    bodyLabel.shadowOffset = spec.bodyShadowOffset

    if spec.titleBodyLabelsSizeToFit { setupLabelConstraintsToSizeToFit() }
  }

  func sizeContentViewLabelsLayoutWidth(toSuperview superview: UIView) {
    var accessoryViewsAndPadding: CGFloat = 0
    if let leftView = leftView { accessoryViewsAndPadding = leftView.bounds.size.width + 15 }
    if let rightView = rightView { accessoryViewsAndPadding += rightView.bounds.size.width + 15 }

    var preferredLayoutWidth = CGFloat(superview.bounds.size.width - accessoryViewsAndPadding - 30)

    if spec.titleBodyLabelsSizeToFit {
      // Get the biggest occupied width of the two strings, set the max preferred layout width to that of the longest
      // label
      let titleOneLineSize = titleLabel.text?.size(withAttributes: [.font: UIFont.boldSystemFont(ofSize: 14)])
      let bodyOneLineSize = bodyLabel.text?.size(withAttributes: [.font: UIFont.boldSystemFont(ofSize: 12)])
      if titleOneLineSize != nil && bodyOneLineSize != nil {
        let maxOccupiedLineWidth =
          (titleOneLineSize!.width > bodyOneLineSize!.width) ? titleOneLineSize!.width : bodyOneLineSize!.width
        if maxOccupiedLineWidth < preferredLayoutWidth {
          preferredLayoutWidth = maxOccupiedLineWidth
        }
      }
    }
    titleLabel.preferredMaxLayoutWidth = preferredLayoutWidth
    bodyLabel.preferredMaxLayoutWidth = preferredLayoutWidth
  }
}
