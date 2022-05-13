//
//  RMessage+Config+Content.swift
//
//
//  Created by Adonis Peralta on 5/11/22.
//

import UIKit

public extension RMessage.Config {
  struct Content {
    public var title: String
    public var body: String?

    /// An attributed string to apply to the title. Has precedence in use over the title property.
    /// Styles set here override "title" styles set via the design config.
    public var attributedTitle: NSAttributedString?

    /// An attributed string to apply to the body. Has precedence in use over the body property.
    /// Styles set here override "body" styles set via the design config.
    public var attributedBody: NSAttributedString?

    public var leftView: UIView?
    public var rightView: UIView?
    public var backgroundView: UIView?

    public init(title: String, body: String? = nil) {
      self.title = title
      self.body = body
    }
  }
}
