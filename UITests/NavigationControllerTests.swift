//
//  RMessageUITests.swift
//  RMessageUITests
//
//  Created by Adonis Peralta on 8/2/18.
//  Copyright © 2018 None. All rights reserved.
//

import Foundation
import XCTest

class NavigationControllerTests: XCTestCase {
  let app = XCUIApplication()
  lazy var navBarElement = app.navigationBars.element
  lazy var navBarFrame = navBarElement.frame
  lazy var windowElement = app.windows.element.firstMatch
  lazy var mainWindowFrame = windowElement.frame
  lazy var notHittablePredicate = NSPredicate(format: "hittable == FALSE")
  lazy var hittablePredicate = NSPredicate(format: "hittable == TRUE")

  // Check for message y position to hundredths place
  let kMsgYPositionScale = 2

  override func setUp() {
    super.setUp()
    continueAfterFailure = false
    XCUIApplication().launch()
  }

  func showMessageFromTopByPressingButton(withName buttonName: String, hidingNavBar: Bool, timeToShow displayTimeout: TimeInterval, timeToHide dismissTimeout: TimeInterval) {
    if hidingNavBar {
      app.buttons["Toggle NavBar"].tap()
    }

    app.buttons[buttonName].tap()

    let displayedMessage = app.otherElements["RMessage"]
    let padding = springAnimationPadding(forHeight: Float(displayedMessage.frame.size.height))
    let expectedMsgYPosition = hidingNavBar ? padding : Float(navBarFrame.size.height + navBarFrame.origin.y) + padding

    let messageDisplayed = displayedMessage.waitForExistence(timeout: displayTimeout)

    XCTAssert(messageDisplayed, "\(buttonName) message failed to display")

    let expectedMessagePositionValid = validateFloatsToScale(
      Float(displayedMessage.frame.origin.y),
      expectedMsgYPosition, scale: kMsgYPositionScale
    )
    XCTAssert(expectedMessagePositionValid, "\(buttonName) message displayed in the wrong position")

    let exp = expectation(for: notHittablePredicate, evaluatedWith: displayedMessage, handler: nil)
    wait(for: [exp], timeout: dismissTimeout)
  }

  func showBottomMessage(hidingNavBar: Bool, withTimeout displayTimeout: TimeInterval, timeToHide dismissTimeout: TimeInterval) {
    if hidingNavBar {
      app.buttons["Toggle NavBar"].tap()
    }

    let buttonName = "Bottom"

    app.buttons[buttonName].tap()

    let displayedMessage = app.otherElements["RMessage"]
    let padding = springAnimationPadding(forHeight: Float(displayedMessage.frame.size.height))
    let expectedMsgYPosition = Float(mainWindowFrame.size.height - displayedMessage.frame.size.height) - padding
    let messageDisplayed = displayedMessage.waitForExistence(timeout: displayTimeout)

    XCTAssert(messageDisplayed, "\(buttonName) message failed to display")

    let expectedMessagePositionValid = validateFloatsToScale(
      Float(displayedMessage.frame.origin.y),
      expectedMsgYPosition, scale: kMsgYPositionScale
    )

    XCTAssert(expectedMessagePositionValid, "\(buttonName) message displayed in the wrong position")
    let exp = expectation(for: notHittablePredicate, evaluatedWith: displayedMessage, handler: nil)
    wait(for: [exp], timeout: dismissTimeout)
  }

  func showEndlessMessage(hidingNavBar: Bool, withTimeout displayTimeout: TimeInterval) {
    if hidingNavBar {
      app.buttons["Toggle NavBar"].tap()
    }

    let buttonName = "Endless"

    app.buttons[buttonName].tap()

    let displayedMessage = app.otherElements["RMessage"]

    // The spring animation padding is calculated on the message size prior to accounting for the safe area layout
    // guides so to properly determine the position of the view we must remove any safe layout are guide sizing from
    // height of the view prior to attempting to calculate the spring animation padding.
    let padding = springAnimationPadding(forHeight: Float(displayedMessage.frame.size.height - 20.0))
    let expectedMsgYPosition = hidingNavBar ? padding : Float(navBarFrame.size.height + navBarFrame.origin.y) + padding
    let messageDisplayed = displayedMessage.waitForExistence(timeout: displayTimeout)

    XCTAssert(messageDisplayed, "\(buttonName) message failed to display")

    let expectedMessagePositionValid = validateFloatsToScale(
      Float(displayedMessage.frame.origin.y),
      expectedMsgYPosition, scale: kMsgYPositionScale
    )
    XCTAssert(expectedMessagePositionValid, "\(buttonName) message displayed in the wrong position")

    sleep(20)
    XCTAssert(displayedMessage.isHittable, "\(buttonName) message no longer on screen")
  }

  func testErrorMessage() {
    showMessageFromTopByPressingButton(withName: "Error", hidingNavBar: false, timeToShow: 3.0, timeToHide: 8.0)
  }

  func testNormalMessage() {
    showMessageFromTopByPressingButton(withName: "Message", hidingNavBar: false, timeToShow: 3.0, timeToHide: 8.0)
  }

  func testWarningMessage() {
    showMessageFromTopByPressingButton(withName: "Warning", hidingNavBar: false, timeToShow: 3.0, timeToHide: 8.0)
  }

  func testSuccessMessage() {
    showMessageFromTopByPressingButton(withName: "Success", hidingNavBar: false, timeToShow: 3.0, timeToHide: 8.0)
  }

  func testLongMessage() {
    showMessageFromTopByPressingButton(withName: "Text", hidingNavBar: false, timeToShow: 3.0, timeToHide: 12.0)
  }

  func testButtonMessage() {
    showMessageFromTopByPressingButton(withName: "Button", hidingNavBar: false, timeToShow: 3.0, timeToHide: 8.0)
  }

  func testBottomMessage() {
    showBottomMessage(hidingNavBar: false, withTimeout: 3.0, timeToHide: 8.0)
  }

  func testCustomMessage() {
    showMessageFromTopByPressingButton(withName: "Custom design", hidingNavBar: false, timeToShow: 3.0, timeToHide: 8.0)
  }

  func testImageMessage() {
    showMessageFromTopByPressingButton(withName: "Custom image", hidingNavBar: false, timeToShow: 3.0, timeToHide: 8.0)
  }

  func testEndlessMessage() {
    showEndlessMessage(hidingNavBar: false, withTimeout: 3.0)
  }

  func testErrorMessageNoNavBar() {
    showMessageFromTopByPressingButton(withName: "Error", hidingNavBar: true, timeToShow: 3.0, timeToHide: 8.0)
  }

  func testNormalMessageNoNavBar() {
    showMessageFromTopByPressingButton(withName: "Message", hidingNavBar: true, timeToShow: 3.0, timeToHide: 8.0)
  }

  func testWarningMessageNoNavBar() {
    showMessageFromTopByPressingButton(withName: "Warning", hidingNavBar: true, timeToShow: 3.0, timeToHide: 8.0)
  }

  func testSuccessMessageNoNavBar() {
    showMessageFromTopByPressingButton(withName: "Success", hidingNavBar: true, timeToShow: 3.0, timeToHide: 8.0)
  }

  func testLongMessageNoNavBar() {
    showMessageFromTopByPressingButton(withName: "Text", hidingNavBar: true, timeToShow: 3.0, timeToHide: 12.0)
  }

  func testButtonMessageNoNavBar() {
    showMessageFromTopByPressingButton(withName: "Button", hidingNavBar: true, timeToShow: 3.0, timeToHide: 8.0)
  }

  func testBottomMessageNoNavBar() {
    showBottomMessage(hidingNavBar: false, withTimeout: 3.0, timeToHide: 8.0)
  }

  func testCustomMessageNoNavBar() {
    showMessageFromTopByPressingButton(withName: "Custom design", hidingNavBar: false, timeToShow: 3.0, timeToHide: 8.0)
  }

  func testImageMessageNoNavBar() {
    showMessageFromTopByPressingButton(withName: "Custom image", hidingNavBar: false, timeToShow: 3.0, timeToHide: 8.0)
  }

  func testWhilstAlert() {
    showMessageFromTopByPressingButton(withName: "Whilst Alert", hidingNavBar: false, timeToShow: 3.0, timeToHide: 8.0)
  }

  func testEndlessMessageNoNavBar() {
    showEndlessMessage(hidingNavBar: false, withTimeout: 3.0)
  }
}
