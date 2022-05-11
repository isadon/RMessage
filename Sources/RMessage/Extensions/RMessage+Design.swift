//
//  RMessage+Design.swift
//
//  Created by Adonis Peralta on 8/6/18.
//  Copyright © 2018 None. All rights reserved.
//

import UIKit

extension RMessage {
  func setupDesign(withMessageSpec spec: RMessageSpec, titleTextView: UITextView, bodyTextView: UITextView) {
    setupDesign(messageSpec: spec)
    setupDesign(forTitleTextView: titleTextView, messageSpec: spec)
    setupDesign(forBodyTextView: bodyTextView, messageSpec: spec)

    if let titleText = titleTextView.text, let attrs = spec.titleAttributes {
      titleTextView.attributedText = NSAttributedString(string: titleText, attributes: attrs)
    }

    if let bodyText = bodyTextView.text, let attrs = spec.bodyAttributes {
      bodyTextView.attributedText = NSAttributedString(string: bodyText, attributes: attrs)
    }

    if spec.titleBodyLabelsSizeToFit { setupLabelConstraintsToSizeToFit() }
  }

  private func setupDesign(messageSpec spec: RMessageSpec) {
    if spec.cornerRadius > 0 { clipsToBounds = true }
    backgroundColor = spec.backgroundColor
  }

  private func setupDesign(forTitleTextView titleTextView: UITextView, messageSpec spec: RMessageSpec) {
    titleTextView.backgroundColor = .clear
    titleTextView.font = spec.titleFont
    titleTextView.textAlignment = spec.titleTextAlignment
    titleTextView.textColor = spec.titleColor
    titleTextView.layer.shadowColor = spec.titleShadowColor.cgColor
    titleTextView.layer.shadowOffset = spec.titleShadowOffset
  }

  private func setupDesign(forBodyTextView bodyTextView: UITextView, messageSpec spec: RMessageSpec) {
    bodyTextView.backgroundColor = .clear
    bodyTextView.font = spec.bodyFont
    bodyTextView.textAlignment = spec.bodyTextAlignment
    bodyTextView.textColor = spec.bodyColor
    bodyTextView.layer.shadowColor = spec.bodyShadowColor.cgColor
    bodyTextView.layer.shadowOffset = spec.bodyShadowOffset
  }
}
