//
//  RMessage.swift
//  RMessage
//
//  Created by Adonis Peralta on 8/2/18.
//  Copyright © 2018 None. All rights reserved.
//

import UIKit

public class RMessage: UIView, RMessageAnimatorDelegate {
  private(set) var config: RMessage.Config

  private(set) lazy var contentView = UIView(frame: .zero)

  private(set) var leftView: UIView?
  private(set) var rightView: UIView?
  private(set) var backgroundView: UIView?

  private let titleTextView: NonSelectableLinkUITextView = {
    let textView = NonSelectableLinkUITextView(frame: .zero)
    textView.isEditable = false
    textView.backgroundColor = .clear
    textView.isScrollEnabled = false
    textView.textContainerInset = .zero
    textView.setContentHuggingPriority(.required, for: .vertical)
    return textView
  }()

  private let bodyTextView: NonSelectableLinkUITextView = {
    let textView = NonSelectableLinkUITextView(frame: .zero)
    textView.isEditable = false
    textView.backgroundColor = .clear
    textView.isScrollEnabled = false
    textView.textContainerInset = .zero
    textView.setContentHuggingPriority(.required, for: .vertical)
    return textView
  }()

  private var messageSpecIconImageViewSet = false
  private var messageSpecBackgroundImageViewSet = false

  let leftViewLeading: CGFloat = 15
  let leftViewTrailing: CGFloat = 8
  let rightViewLeading: CGFloat = 8
  let rightViewTrailing: CGFloat = 15

  let contentViewLeadingSpace: CGFloat = 12
  let contentViewTrailingSpace: CGFloat = 15

  // MARK: - Constraint Vars

  private lazy var titleLeadingConstraint = titleTextView.leadingAnchor.constraint(
    equalTo: contentView.leadingAnchor
  )

  private lazy var titleTrailingConstraint = titleTextView.trailingAnchor.constraint(
    equalTo: contentView.trailingAnchor
  )

  private lazy var bodyZeroHeightConstraint = bodyTextView.heightAnchor.constraint(equalToConstant: 0)

  private lazy var bodyLeadingConstraint = bodyTextView.leadingAnchor.constraint(
    equalTo: contentView.leadingAnchor
  )

  private lazy var bodyTrailingConstraint = bodyTextView.trailingAnchor.constraint(
    equalTo: contentView.trailingAnchor
  )

  private lazy var contentViewTrailingConstraint: NSLayoutConstraint = {
    let constraint = contentView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -contentViewTrailingSpace)
    constraint.priority = .defaultHigh
    return constraint
  }()

  private lazy var titleBodyVerticalSpacingConstraint = bodyTextView.topAnchor.constraint(
    equalTo: titleTextView.bottomAnchor, constant: 5
  )

  // MARK: Instance Methods

  public init(_ config: RMessage.Config) {
    self.config = config
    leftView = config.content.leftView
    rightView = config.content.rightView
    backgroundView = config.content.backgroundView

    super.init(frame: CGRect.zero)

    accessibilityIdentifier = String(describing: type(of: self))

    setupDesign()

    titleTextView.text = config.content.title

    if let attributedTitle = config.content.attributedTitle {
      titleTextView.attributedText = attributedTitle
    }

    bodyTextView.text = config.content.body
    if let attributedBody = config.content.attributedBody {
      bodyTextView.attributedText = attributedBody
    }

    setupOptionalComponents()
    layoutViews()
  }

  @available(*, unavailable) required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Layout Methods

  private func layoutViews() {
    layoutContentViewSubviews()
    layoutContentView()
    layoutOptionalComponents()
  }

  private func layoutContentViewSubviews() {
    for sub in [titleTextView, bodyTextView] {
      contentView.addSubview(sub)
      sub.translatesAutoresizingMaskIntoConstraints = false
    }

    let dynamicBodyConstraints: [NSLayoutConstraint] = {
      var constraints: [NSLayoutConstraint] = [titleBodyVerticalSpacingConstraint]

      // Check if body is empty and modify our constraints
      if bodyTextView.text == "" || bodyTextView.attributedText.string == "" {
        constraints.append(bodyZeroHeightConstraint)
        // Remove extra spacing added when the body text is set
        titleBodyVerticalSpacingConstraint.constant = 0
      }

      return constraints
    }()

    NSLayoutConstraint.activate([
      titleTextView.topAnchor.constraint(equalTo: contentView.topAnchor),
      titleLeadingConstraint,
      titleTrailingConstraint,
      titleTextView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),

      bodyLeadingConstraint,
      bodyTrailingConstraint,
      bodyTextView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
      bodyTextView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
    ] + dynamicBodyConstraints)
  }

  private func layoutContentView() {
    addSubview(contentView)
    contentView.translatesAutoresizingMaskIntoConstraints = false

    let sag = safeAreaLayoutGuide

    let contentViewOptLeading = contentView.leadingAnchor.constraint(
      equalTo: leadingAnchor, constant: contentViewLeadingSpace
    )

    contentViewOptLeading.priority = .defaultHigh

    let contentViewOptTop = contentView.topAnchor.constraint(equalTo: sag.topAnchor, constant: 10)
    contentViewOptTop.priority = .init(rawValue: 249)

    let contentViewOptBottom = contentView.bottomAnchor.constraint(equalTo: sag.bottomAnchor, constant: -10)
    contentViewOptBottom.priority = .init(rawValue: 249)

    let contentViewCenterXOpt = contentView.centerXAnchor.constraint(equalTo: centerXAnchor)
    contentViewCenterXOpt.priority = .init(rawValue: 748)

    let contentViewCenterYOpt = contentView.centerYAnchor.constraint(equalTo: centerYAnchor)
    contentViewCenterYOpt.priority = .init(rawValue: 248)

    NSLayoutConstraint.activate([
      contentViewCenterXOpt,
      contentView.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor),
      contentViewOptLeading,
      contentView.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor),
      contentViewTrailingConstraint,

      contentViewCenterYOpt,
      contentView.topAnchor.constraint(greaterThanOrEqualTo: safeAreaLayoutGuide.topAnchor, constant: 10),
      contentViewOptTop,
      contentView.bottomAnchor.constraint(lessThanOrEqualTo: safeAreaLayoutGuide.bottomAnchor, constant: -10),
      contentViewOptBottom,
    ])
  }

  private func layoutOptionalComponents() {
    // Let any left view passed in programmatically override any icon image view initiated via a message config
    if let leftView {
      setup(leftView: leftView, inSuperview: self)
    }

    if let rightView {
      setup(rightView: rightView, inSuperview: self)
    }

    // Let any background view passed in programmatically override any background image view initiated
    // via a message config
    if let backgroundView {
      setup(backgroundView: backgroundView, inSuperview: self)
    }

    if config.design.blurBackground {
      setupBlurBackgroundView(inSuperview: self)
    }
  }

  private func setupOptionalComponents() {
    if let image = config.design.iconImage, leftView == nil {
      leftView = iconImageView(withImage: image, imageTintColor: config.design.iconImageTintColor, superview: self)
    }

    if let backgroundImage = config.design.backgroundImage, backgroundView == nil {
      backgroundView = backgroundImageView(withImage: backgroundImage, superview: self)
    }
  }

  // MARK: - Design Setup Methods

  private func setupDesign() {
    if config.design.cornerRadius > 0 { clipsToBounds = true }
    backgroundColor = config.design.backgroundColor

    setupDesignForTitleTextView()
    setupDesignForBodyTextView()

    if config.design.titleBodyLabelsSizeToFit { setupLabelConstraintsToSizeToFit() }
  }

  private func setupDesignForTitleTextView() {
    titleTextView.backgroundColor = .clear
    titleTextView.font = config.design.titleFont
    titleTextView.textAlignment = config.design.titleTextAlignment
    titleTextView.textColor = config.design.titleColor
    titleTextView.layer.shadowColor = config.design.titleShadowColor.cgColor
    titleTextView.layer.shadowOffset = config.design.titleShadowOffset

    if let linkTextAttrs = config.design.titleLinkAttributes {
      titleTextView.linkTextAttributes = linkTextAttrs
    }
  }

  private func setupDesignForBodyTextView() {
    bodyTextView.backgroundColor = .clear
    bodyTextView.font = config.design.bodyFont
    bodyTextView.textAlignment = config.design.bodyTextAlignment
    bodyTextView.textColor = config.design.bodyColor
    bodyTextView.layer.shadowColor = config.design.bodyShadowColor.cgColor
    bodyTextView.layer.shadowOffset = config.design.bodyShadowOffset

    if let linkTextAttrs = config.design.bodyLinkAttributes {
      bodyTextView.linkTextAttributes = linkTextAttrs
    }
  }

  func setupLabelConstraintsToSizeToFit() {
    assert(superview != nil, "RMessage instance must have a superview by this point!")

    guard config.design.titleBodyLabelsSizeToFit else {
      return
    }

    NSLayoutConstraint.deactivate([
      contentViewTrailingConstraint,
      titleLeadingConstraint, titleTrailingConstraint,
      bodyLeadingConstraint, bodyTrailingConstraint,
    ].compactMap { $0 }
    )

    titleLeadingConstraint = titleTextView.leadingAnchor.constraint(greaterThanOrEqualTo: contentView.leadingAnchor)
    titleTrailingConstraint = titleTextView.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor)
    bodyLeadingConstraint = bodyTextView.leadingAnchor.constraint(greaterThanOrEqualTo: contentView.leadingAnchor)
    bodyTrailingConstraint = bodyTextView.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor)

    NSLayoutConstraint.activate(
      [
        titleLeadingConstraint, titleTrailingConstraint,
        bodyLeadingConstraint, bodyTrailingConstraint,
      ]
    )
  }

  // MARK: - Respond to Layout Changes

  override public func layoutSubviews() {
    super.layoutSubviews()

    if titleTextView.text == nil || bodyTextView.text == nil { titleBodyVerticalSpacingConstraint.constant = 0 }

    if let leftView, messageSpecIconImageViewSet, config.design.iconImageRelativeCornerRadius > 0 {
      leftView.layer.cornerRadius = config.design.iconImageRelativeCornerRadius * leftView.bounds.size.width
    }

    if config.design.cornerRadius >= 0 { layer.cornerRadius = config.design.cornerRadius }
  }
}
