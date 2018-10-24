//
//  UITestHelpers.h
//  RMessageUITests
//
//  Created by Adonis Peralta on 3/14/18.
//

#import <Foundation/Foundation.h>

@interface UITestHelpers : NSObject

BOOL validateFloatsToScale(CGFloat f1, CGFloat f2, int scale);
+(CGFloat)springAnimationPaddingForHeight:(CGFloat)height;

@end
