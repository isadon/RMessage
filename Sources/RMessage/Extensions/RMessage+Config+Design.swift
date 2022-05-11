//
//  RMessageSpec.swift
//  RMessage
//
//  Created by Adonis Peralta on 8/3/18.
//  Copyright © 2018 None. All rights reserved.
//

import SwiftHEXColors
import UIKit

public extension RMessage.Config {
  struct Design {
    // MARK: Implementation for the builtin message types

    public static var error: Self {
      var errorSpec = Self()
      errorSpec.backgroundColor = UIColor(hexString: "#FF2D55") ?? .black
      errorSpec.titleColor = .white
      errorSpec.bodyColor = .white
      errorSpec.iconImage = UIImage(named: "ErrorMessageIcon", in: .module, compatibleWith: nil)
      return errorSpec
    }

    public static var warning: Self {
      var warningSpec = Self()
      warningSpec.backgroundColor = UIColor(hexString: "#FFCC00") ?? .black
      warningSpec.titleColor = UIColor(hexString: "#484638") ?? .white
      warningSpec.bodyColor = warningSpec.titleColor
      warningSpec.iconImage = UIImage(named: "WarningMessageIcon", in: .module, compatibleWith: nil)
      return warningSpec
    }

    public static var normal: Self {
      var normalSpec = Self()
      normalSpec.backgroundColor = UIColor(hexString: "#E8E8E8") ?? .black
      normalSpec.titleColor = UIColor(hexString: "#727C83") ?? .white
      normalSpec.bodyColor = normalSpec.titleColor
      return normalSpec
    }

    public static var success: Self {
      var successSpec = Self()
      successSpec.backgroundColor = UIColor(hexString: "#00C060") ?? .black
      successSpec.titleColor = .white
      successSpec.bodyColor = successSpec.titleColor
      successSpec.iconImage = UIImage(named: "SuccessMessageIcon", in: .module, compatibleWith: nil)
      return successSpec
    }

    public static var `default` = Self()

    /// Background color for the message.
    public var backgroundColor: UIColor = .white

    /// The target opacity of the message after it finishes the presentation animation.
    public var targetAlpha: CGFloat = 1

    /// The corner radius of the message.
    public var cornerRadius: CGFloat = 0

    /// Vertical offset to apply to the message.
    /// Use this to vertically shift the messages position after it finishes presenting.
    public var verticalOffset: CGFloat = 0

    /// An icon image to display to the left of the message.
    public var iconImage: UIImage?

    /// Icon image tint color to apply to icon images defined to be template images.
    /// Does nothing for icon images that are not template images.
    public var iconImageTintColor: UIColor = .clear

    /// Corner radius percentage relative to icon image to apply to icon image.
    ///
    /// For example 0.5 (use 50% of icon image width as corner radius) would mask the icon image to always be a circle.
    public var iconImageRelativeCornerRadius: CGFloat = 0

    /// Background image to use for the message.
    public var backgroundImage: UIImage?

    /// Font to apply to the title text.
    public var titleFont: UIFont = .boldSystemFont(ofSize: 14)

    /// Color to apply to the title text.
    public var titleColor: UIColor = .black

    /// Color to apply to the title shadow.
    public var titleShadowColor: UIColor = .clear

    /// Offset to apply to the title shadow.
    public var titleShadowOffset: CGSize = .zero

    /// Text alingment of the title text.
    public var titleTextAlignment: NSTextAlignment = .left

    /// Attributes to apply to the title link text to style as an attributed string. Styles applied with this property
    /// override stylings applied by other properties in the RMessageSpec.
    public var titleLinkAttributes: [NSAttributedString.Key: Any]?

    /// Font to apply to the body text.
    public var bodyFont: UIFont = .boldSystemFont(ofSize: 12)

    /// Color to the apply to the body text.
    public var bodyColor: UIColor = .black

    /// Color to apply to the body shadow.
    public var bodyShadowColor: UIColor = .clear

    /// Offset to apply to the body shadow.
    public var bodyShadowOffset: CGSize = .zero

    /// Text alingment of the body text.
    public var bodyTextAlignment: NSTextAlignment = .left

    /// Attributes to apply to the body link text to style as an attributed string. Styles applied with this property
    /// override stylings applied by other properties in the RMessageSpec.
    public var bodyLinkAttributes: [NSAttributedString.Key: Any]?

    /// A boolean value specifying whether to blur the background of the message. If attempting to blur a background color
    // make sure the background color has alpha value less than 1 when enabling this feature.
    public var blurBackground: Bool = false

    /// A boolean value specifying whether to size the title and body labels to fit their content.
    public var titleBodyLabelsSizeToFit: Bool = false

    public init() {}
  }
}
