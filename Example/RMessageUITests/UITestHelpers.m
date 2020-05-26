//
//  UITestHelpers.m
//  RMessageUITests
//
//  Created by Adonis Peralta on 3/14/18.
//

#import <UIKit/UIKit.h>
#import "UITestHelpers.h"

@implementation UITestHelpers

// Returns true or false if the floats are equal to each other after truncating all numbers
// after the scale decimal places
BOOL validateFloatsToScale(CGFloat f1, CGFloat f2, int scale) {
  int truncFactor = pow(10, scale);
  CGFloat tFloat1 = truncf(f1 * truncFactor) / truncFactor;
  CGFloat tFloat2 = truncf(f2 * truncFactor) / truncFactor;
  return tFloat1 == tFloat2;
}

+(CGFloat)springAnimationPaddingForHeight:(CGFloat)height
{
  return ceilf(height / 120) * -5.f;
}
@end
