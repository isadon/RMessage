//
//  RMShowOperation.swift
//
//  Created by Adonis Peralta on 8/9/18.
//  Copyright © 2018 None. All rights reserved.
//

import UIKit

class RMShowOperation: Operation, RMPresenterDelegate {
  override var isAsynchronous: Bool {
    return true
  }

  private var executingState: Bool = false
  override var isExecuting: Bool {
    get { return executingState }
    set {
      willChangeValue(forKey: "isExecuting")
      executingState = newValue
      didChangeValue(forKey: "isExecuting")
    }
  }

  private var finishedState: Bool = false
  override var isFinished: Bool {
    get { return finishedState }
    set {
      willChangeValue(forKey: "isFinished")
      finishedState = newValue
      didChangeValue(forKey: "isFinished")
    }
  }

  private var context = 0

  let message: RMessage
  let presenter: RMPresenter

  init(message: RMessage, presenter: RMPresenter) {
    self.message = message
    self.presenter = presenter
    super.init()
  }

  override func start() {
    if isCancelled {
      finish()
      return
    }

    // Always make sure to set the message delegate to self in main as this is the only time when we can actually
    // be the delegate (when this Operation instance has exclusive access to display the message)
    presenter.delegate = self

    DispatchQueue.main.async {
      self.isExecuting = true
      self.presenter.present()
    }
  }

  // MARK: - RMessageDelegate methods

  func presenterDidDismiss(_: RMPresenter, message _: RMessage) {
    finish()
  }

  private func finish() {
    isExecuting = false
    isFinished = true
  }
}
