//
//  RMessageUITests.m
//  RMessageUITests
//
//  Created by Adonis Peralta on 12/4/17.
//

#import <XCTest/XCTest.h>

@interface RMessageUITests : XCTestCase

@end

@implementation RMessageUITests
{
  XCUIApplication *app;
}

- (void)setUp {
  [super setUp];
  self.continueAfterFailure = NO;
  app = [XCUIApplication new];
  [app launch];
}

- (void)tearDown {
  app = nil;
  [super tearDown];
}

@end
