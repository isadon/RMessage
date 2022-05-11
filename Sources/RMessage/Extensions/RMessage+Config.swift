//
//  RMessage+Config.swift
//
//
//  Created by Adonis Peralta on 5/11/22.
//

import UIKit

public extension RMessage {
  struct Config {
    public var content: Content
    public var design: Design
    public var presentation: Presentation

    public init(title: String = "", body: String? = nil, design: Design = .default) {
      content = Content(title: title, body: body)
      self.design = design
      presentation = Presentation()
    }

    public init(content: Content, design: Design, presentation: Presentation) {
      self.content = content
      self.design = design
      self.presentation = presentation
    }
  }
}
