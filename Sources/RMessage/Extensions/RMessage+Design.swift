//
//  RMessage+Design.swift
//
//  Created by Adonis Peralta on 8/6/18.
//  Copyright © 2018 None. All rights reserved.
//

import Foundation
import UIKit

extension RMessage {
  func setupDesign(withMessageSpec spec: RMessageSpec, titleLabel: UILabel, bodyLabel: UILabel) {
    setupDesign(messageSpec: spec)
    setupDesign(forTitleLabel: titleLabel, messageSpec: spec)
    setupDesign(forBodyLabel: bodyLabel, messageSpec: spec)

    if let titleAttributes = spec.titleAttributes {
      setup(attributedTitleLabel: titleLabel, withAttributes: titleAttributes)
    }

    if let bodyAttributes = spec.bodyAttributes {
      setup(attributedTitleLabel: bodyLabel, withAttributes: bodyAttributes)
    }

    if spec.titleBodyLabelsSizeToFit { setupLabelConstraintsToSizeToFit() }
  }

  private func setupDesign(messageSpec spec: RMessageSpec) {
    if spec.cornerRadius > 0 { clipsToBounds = true }
    backgroundColor = spec.backgroundColor
  }

  private func setupDesign(forTitleLabel titleLabel: UILabel, messageSpec spec: RMessageSpec) {
    titleLabel.numberOfLines = 0
    titleLabel.lineBreakMode = .byWordWrapping
    titleLabel.font = UIFont.boldSystemFont(ofSize: 14)
    titleLabel.textAlignment = .left
    titleLabel.textColor = .black
    titleLabel.shadowColor = nil
    titleLabel.shadowOffset = CGSize.zero
    titleLabel.backgroundColor = nil
    titleLabel.font = spec.titleFont
    titleLabel.textAlignment = spec.titleTextAlignment
    titleLabel.textColor = spec.titleColor
    titleLabel.shadowColor = spec.titleShadowColor
    titleLabel.shadowOffset = spec.titleShadowOffset
  }

  private func setupDesign(forBodyLabel bodyLabel: UILabel, messageSpec spec: RMessageSpec) {
    bodyLabel.numberOfLines = 0
    bodyLabel.lineBreakMode = .byWordWrapping
    bodyLabel.font = UIFont.boldSystemFont(ofSize: 12)
    bodyLabel.textAlignment = .left
    bodyLabel.textColor = .darkGray
    bodyLabel.shadowColor = nil
    bodyLabel.shadowOffset = CGSize.zero
    bodyLabel.backgroundColor = nil
    bodyLabel.font = spec.bodyFont
    bodyLabel.textAlignment = spec.bodyTextAlignment
    bodyLabel.textColor = spec.bodyColor
    bodyLabel.shadowColor = spec.bodyShadowColor
    bodyLabel.shadowOffset = spec.bodyShadowOffset
  }

  private func setup(attributedTitleLabel titleLabel: UILabel, withAttributes attrs: [NSAttributedString.Key: Any]) {
    guard let titleText = titleLabel.text else { return }

    let titleAttributedText = NSAttributedString(string: titleText, attributes: attrs)
    titleLabel.attributedText = titleAttributedText
  }

  private func setup(attributedBodyLabel bodyLabel: UILabel, withAttributes attrs: [NSAttributedString.Key: Any]) {
    guard let bodyText = bodyLabel.text else { return }

    let bodyAttributedText = NSAttributedString(string: bodyText, attributes: attrs)
    bodyLabel.attributedText = bodyAttributedText
  }

  func setPreferredLayoutWidth(forTitleLabel titleLabel: UILabel,
                               bodyLabel: UILabel,
                               inSuperview superview: UIView,
                               sizingToFit: Bool) {

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

    guard sizingToFit else { return }

    // Get the biggest occupied width of the two strings, set the max preferred layout width to that of the longest label
    let titleOneLineSize: CGSize
    let bodyOneLineSize: CGSize

    if let titleAttributedText = titleLabel.attributedText {
      titleOneLineSize = titleAttributedText.size()
    } else if let titleText = titleLabel.text {
      let titleFont = titleLabel.font ?? UIFont.systemFont(ofSize: 12)
      titleOneLineSize = titleText.size(withAttributes: [.font: titleFont])
    } else {
      titleOneLineSize = .zero
    }

    if let bodyAttributedText = bodyLabel.attributedText {
      bodyOneLineSize = bodyAttributedText.size()
    } else if let bodyText = bodyLabel.text {
      let bodyFont = titleLabel.font ?? UIFont.systemFont(ofSize: 14)
      bodyOneLineSize = bodyText.size(withAttributes: [.font: bodyFont])
    } else {
      bodyOneLineSize = .zero
    }

    guard titleOneLineSize != .zero, bodyOneLineSize != .zero else { return }

    let maxOccupiedLineWidth =
      (titleOneLineSize.width > bodyOneLineSize.width) ? titleOneLineSize.width : bodyOneLineSize.width

    if maxOccupiedLineWidth < preferredLayoutWidth {
      preferredLayoutWidth = maxOccupiedLineWidth
    }
  }
}
