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

    setupAttributedLabels()
    if spec.titleBodyLabelsSizeToFit { setupLabelConstraintsToSizeToFit() }
  }

  func setupAttributedLabels() {
    guard let titleText = titleLabel?.text, let titleAttributes = spec.titleAttributes else {
      return
    }
    let titleAttributedText = NSAttributedString(string: titleText, attributes: titleAttributes)
    titleLabel?.attributedText = titleAttributedText

    guard let bodyText = bodyLabel?.text, let bodyAttributes = spec.bodyAttributes else {
      return
    }
    let bodyAttributedText = NSAttributedString(string: bodyText, attributes: bodyAttributes)
    bodyLabel?.attributedText = bodyAttributedText
  }

  func sizeContentViewLabelsLayoutWidth(toSuperview superview: UIView) {
    guard let titleLabel = titleLabel, let bodyLabel = bodyLabel else {
      return
    }
    var accessoryViewsAndPadding: CGFloat = 0
    if let leftView = leftView { accessoryViewsAndPadding = leftView.bounds.size.width + 15 }
    if let rightView = rightView { accessoryViewsAndPadding += rightView.bounds.size.width + 15 }

    var preferredLayoutWidth = CGFloat(superview.bounds.size.width - accessoryViewsAndPadding - 30)

    // Always set the preferredLayoutWidth before exit. Note that titleBodyLabelsSizeToFit changes
    // preferredLayoutWidth further down below if it is true
    defer {
      titleLabel.preferredMaxLayoutWidth = preferredLayoutWidth
      bodyLabel.preferredMaxLayoutWidth = preferredLayoutWidth
    }

    guard spec.titleBodyLabelsSizeToFit else {
      return
    }
    // Get the biggest occupied width of the two strings, set the max preferred layout width to that of the longest label
    var titleOneLineSize: CGSize?
    var bodyOneLineSize: CGSize?

    if let titleAttributedText = titleLabel.attributedText {
      titleOneLineSize = titleAttributedText.size()
    }
    if let titleText = titleLabel.text {
      titleOneLineSize = titleText.size(withAttributes: [.font: spec.titleFont])
    }

    if let bodyAttributedText = bodyLabel.attributedText {
      bodyOneLineSize = bodyAttributedText.size()
    }
    if let bodyText = titleLabel.text {
      bodyOneLineSize = bodyText.size(withAttributes: [.font: spec.bodyFont])
    }

    if titleOneLineSize != nil && bodyOneLineSize != nil {
      let maxOccupiedLineWidth =
        (titleOneLineSize!.width > bodyOneLineSize!.width) ? titleOneLineSize!.width : bodyOneLineSize!.width
      if maxOccupiedLineWidth < preferredLayoutWidth {
        preferredLayoutWidth = maxOccupiedLineWidth
      }
    }
  }
}
