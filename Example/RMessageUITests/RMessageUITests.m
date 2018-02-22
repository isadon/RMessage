//
//  RMessageUITests.m
//  RMessageUITests
//
//  Created by Adonis Peralta on 12/4/17.
//

#import <XCTest/XCTest.h>

@interface RMessageUITests : XCTestCase

@end

@implementation RMessageUITests {
  XCUIApplication *app;
  XCUIElement *navBarElement;
  XCUIElement *windowElement;
  CGRect navBarFrame;
  CGRect mainWindowFrame;
  NSPredicate *notHittablePredicate;
  NSPredicate *hittablePredicate;
}

- (void)setUp
{
  [super setUp];
  self.continueAfterFailure = NO;
  app = [XCUIApplication new];
  [app launch];
  navBarElement = app.navigationBars.element;
  windowElement = app.windows.element.firstMatch;
  navBarFrame = navBarElement.frame;
  mainWindowFrame = windowElement.frame;

  notHittablePredicate = [NSPredicate predicateWithFormat:@"hittable == FALSE"];
  hittablePredicate = [NSPredicate predicateWithFormat:@"hittable == TRUE"];
}

- (void)showMessageFromTopByPressingButtonWithName:(NSString *)buttonName
                                      hidingNavBar:(BOOL)hideNavBar
                                        timeToShow:(NSTimeInterval)displayTimeout
                                        timeToHide:(NSTimeInterval)dismissTimeout
{
  if (hideNavBar) {
    [app.buttons[@"Toggle NavBar"] tap];
  };

  [app.buttons[buttonName] tap];
  XCUIElement *displayedMessage = app.otherElements[@"RMessage-View"];

  int expectedMessagePosition = hideNavBar ? 0 : navBarFrame.size.height + navBarFrame.origin.y;
  BOOL messageDisplayed = [displayedMessage waitForExistenceWithTimeout:displayTimeout];
  XCTAssert(messageDisplayed, @"%@ message failed to display", buttonName);
  XCTAssert(displayedMessage.frame.origin.y == expectedMessagePosition, "%@ message displayed in the wrong position",
            buttonName);

  XCTestExpectation *expectation = [self expectationForPredicate:notHittablePredicate
                                             evaluatedWithObject:displayedMessage
                                                         handler:nil];
  [self waitForExpectations:@[expectation] timeout:dismissTimeout];
}

- (void)showBottomMessageHidingNavBar:(BOOL)hideNavBar
                           timeToShow:(NSTimeInterval)displayTimeout
                           timeToHide:(NSTimeInterval)dismissTimeout
{
  if (hideNavBar) {
    [app.buttons[@"Toggle NavBar"] tap];
  };

  [app.buttons[@"Bottom"] tap];
  XCUIElement *displayedMessage = app.otherElements[@"RMessage-View"];

  BOOL messageDisplayed = [displayedMessage waitForExistenceWithTimeout:displayTimeout];
  XCTAssert(messageDisplayed, @"Bottom message failed to display");
  XCTAssert(displayedMessage.frame.origin.y == mainWindowFrame.size.height - displayedMessage.frame.size.height,
            "Bottom message displayed in the wrong position");

  XCTestExpectation *expectation = [self expectationForPredicate:notHittablePredicate
                                             evaluatedWithObject:displayedMessage
                                                         handler:nil];
  [self waitForExpectations:@[expectation] timeout:dismissTimeout];
}

- (void)showEndlessMessageHidingNavBar:(BOOL)hideNavBar timeToShow:(NSTimeInterval)displayTimeout
{
  if (hideNavBar) {
    [app.buttons[@"Toggle NavBar"] tap];
  };
  [app.buttons[@"Endless"] tap];
  XCUIElement *displayedMessage = app.otherElements[@"RMessage-View"];

  int expectedMessagePosition = hideNavBar ? 0 : navBarFrame.size.height + navBarFrame.origin.y;
  BOOL messageDisplayed = [displayedMessage waitForExistenceWithTimeout:displayTimeout];
  XCTAssert(messageDisplayed, @"Endless message failed to display");
  XCTAssert(displayedMessage.frame.origin.y == expectedMessagePosition, "Endless message displayed in the wrong position");
  sleep(20);
  XCTAssert(displayedMessage.hittable, "Endless message no longer on screen");
}

- (void)testErrorMessageNoNavBar
{
  [self showMessageFromTopByPressingButtonWithName:@"Error" hidingNavBar:YES timeToShow:3.f timeToHide:5.f];
}

- (void)testNormalMessageNoNavBar
{
  [self showMessageFromTopByPressingButtonWithName:@"Message" hidingNavBar:YES timeToShow:3.f timeToHide:5.f];
}

- (void)testWarningMessageNoNavBar
{
  [self showMessageFromTopByPressingButtonWithName:@"Warning" hidingNavBar:YES timeToShow:3.f timeToHide:5.f];
}

- (void)testSuccessMessageNoNavBar
{
  [self showMessageFromTopByPressingButtonWithName:@"Success" hidingNavBar:YES timeToShow:3.f timeToHide:5.f];
}

- (void)testLongMessageNoNavBar
{
  [self showMessageFromTopByPressingButtonWithName:@"Text" hidingNavBar:YES timeToShow:3.f timeToHide:15.f];
}

- (void)testButtonMessageNoNavBar
{
  [self showMessageFromTopByPressingButtonWithName:@"Button" hidingNavBar:YES timeToShow:3.f timeToHide:5.f];
}

- (void)testBottomMessageNoNavBar
{
  [self showBottomMessageHidingNavBar:YES timeToShow:3.f timeToHide:5.f];
}

- (void)testCustomMessageNoNavBar
{
  [self showMessageFromTopByPressingButtonWithName:@"Custom design" hidingNavBar:YES timeToShow:3.f timeToHide:5.f];
}

- (void)testImageMessageNoNavBar
{
  [self showMessageFromTopByPressingButtonWithName:@"Custom image" hidingNavBar:YES timeToShow:3.f timeToHide:5.f];
}

- (void)testEndlessMessageNoNavBar
{
  [self showEndlessMessageHidingNavBar:YES timeToShow:3.f];
}

- (void)testErrorMessageWithNavBar
{
  [self showMessageFromTopByPressingButtonWithName:@"Error" hidingNavBar:NO timeToShow:3.f timeToHide:5.f];
}

- (void)testNormalMessageWithNavBar
{
  [self showMessageFromTopByPressingButtonWithName:@"Message" hidingNavBar:NO timeToShow:3.f timeToHide:5.f];
}

- (void)testWarningMessageWithNavBar
{
  [self showMessageFromTopByPressingButtonWithName:@"Warning" hidingNavBar:NO timeToShow:3.f timeToHide:5.f];
}

- (void)testSuccessMessageWithNavBar
{
  [self showMessageFromTopByPressingButtonWithName:@"Success" hidingNavBar:NO timeToShow:3.f timeToHide:5.f];
}

- (void)testLongMessageWithNavBar
{
  [self showMessageFromTopByPressingButtonWithName:@"Text" hidingNavBar:NO timeToShow:3.f timeToHide:17.f];
}

- (void)testButtonMessageWithNavBar
{
  [self showMessageFromTopByPressingButtonWithName:@"Button" hidingNavBar:NO timeToShow:3.f timeToHide:5.f];
}

- (void)testBottomMessageWithNavBar
{
  [self showBottomMessageHidingNavBar:NO timeToShow:3.f timeToHide:5.f];
}

- (void)testCustomMessageWithNavBar
{
  [self showMessageFromTopByPressingButtonWithName:@"Custom design" hidingNavBar:NO timeToShow:3.f timeToHide:5.f];
}

- (void)testImageMessageWithNavBar
{
  [self showMessageFromTopByPressingButtonWithName:@"Custom image" hidingNavBar:NO timeToShow:3.f timeToHide:5.f];
}

- (void)testEndlessMessageWithNavBar
{
  [self showEndlessMessageHidingNavBar:NO timeToShow:3.f];
}

- (void)testMessageOverNavBar
{
  [app.buttons[@"Over NavBar"] tap];
  XCUIElement *displayedMessage = app.otherElements[@"RMessage-View"];

  BOOL messageDisplayed = [displayedMessage waitForExistenceWithTimeout:3.f];
  XCTAssert(messageDisplayed, @"Over navBar message failed to display");
  XCTAssert(displayedMessage.frame.origin.y == 0, "Over navBar message displayed in the wrong position");

  XCTestExpectation *expectation = [self expectationForPredicate:notHittablePredicate
                                             evaluatedWithObject:displayedMessage
                                                         handler:nil];
  [self waitForExpectations:@[expectation] timeout:5.f];
}

- (void)testButtonMessageButtonPress
{
  [app.buttons[@"Button"] tap];
  XCUIElement *displayedMessage = app.otherElements[@"RMessage-View"];

  BOOL messageDisplayed = [displayedMessage waitForExistenceWithTimeout:3.f];
  XCTAssert(messageDisplayed, @"Button message failed to display");

  XCTestExpectation *displayedMessageDismissedExpectation = [self expectationForPredicate:notHittablePredicate
                                                                      evaluatedWithObject:displayedMessage
                                                                                  handler:nil];
  [app.buttons[@"Update"] tap];

  XCUIElement *updateMessage = app.otherElements[@"RMessage-View"];
  messageDisplayed = [updateMessage waitForExistenceWithTimeout:3.f];
  XCTAssert(messageDisplayed, @"Update message failed to display");

  XCTestExpectation *updateMessageDismissedExpectation = [self expectationForPredicate:notHittablePredicate
                                                                   evaluatedWithObject:updateMessage
                                                                               handler:nil];
  [self waitForExpectations:@[displayedMessageDismissedExpectation] timeout:5.f];
  [self waitForExpectations:@[updateMessageDismissedExpectation] timeout:5.f];
}

- (void)testEndlessMessageDismiss
{
  [app.buttons[@"Endless"] tap];

  XCUIElement *displayedMessage = app.otherElements[@"RMessage-View"];

  int expectedMessagePosition = navBarFrame.size.height + navBarFrame.origin.y;
  BOOL messageDisplayed = [displayedMessage waitForExistenceWithTimeout:3.f];
  XCTAssert(messageDisplayed, @"Endless message failed to display");
  XCTAssert(displayedMessage.frame.origin.y == expectedMessagePosition, "Endless message displayed in the wrong position");
  sleep(20);
  XCTAssert(displayedMessage.hittable, "Endless message no longer on screen");

  [displayedMessage tap];
  sleep(5);
  XCTAssert(displayedMessage.hittable, "Endless message no longer on screen");

  [app.buttons[@"Dismiss"] tap];

  XCTestExpectation *messageDidDismiss = [self expectationForPredicate:notHittablePredicate
                                                   evaluatedWithObject:displayedMessage
                                                               handler:nil];
  [self waitForExpectations:@[messageDidDismiss] timeout:5.f];
}

- (void)testTapToDismiss
{
  [app.buttons[@"Error"] tap];
  XCUIElement *displayedMessage = app.otherElements[@"RMessage-View"];

  int expectedMessagePosition = navBarFrame.size.height + navBarFrame.origin.y;
  BOOL messageDisplayed = [displayedMessage waitForExistenceWithTimeout:3.f];
  XCTAssert(messageDisplayed, @"Error message failed to display");
  XCTAssert(displayedMessage.frame.origin.y == expectedMessagePosition, "Error message displayed in the wrong position");

  [displayedMessage tap];
  XCTestExpectation *expectation = [self expectationForPredicate:notHittablePredicate
                                             evaluatedWithObject:displayedMessage
                                                         handler:nil];
  [self waitForExpectations:@[expectation] timeout:2.f];
}

- (void)tearDown
{
  app = nil;
  navBarElement = nil;
  windowElement = nil;
  notHittablePredicate = nil;
  hittablePredicate = nil;
  [super tearDown];
}

@end
