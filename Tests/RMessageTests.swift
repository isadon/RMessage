//
//  RMessageTests.swift
//  RMessageTests
//
//  Created by Adonis Peralta on 8/2/18.
//  Copyright © 2018 None. All rights reserved.
//

@testable import RMessage
import XCTest

class RMessageTests: XCTestCase {
  let rControl = RMController()

  override func setUp() {
    super.setUp()
  }

  override func tearDown() {
    super.tearDown()
  }

  /// Test that RMessage does not attempt to present if there is no window hierarchy present.
  func testQueuedMessages() {
    for _ in 1 ... 6 {
      rControl.showMessage(withSpec: DefaultRMessageSpec(), title: "Test")
    }
    XCTAssertTrue(rControl.queueCount == 0)
  }
}
