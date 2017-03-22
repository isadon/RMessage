//
//  NSString+NSAttributedString.m
//  Example
//
//  Created by Adonis Peralta on 3/22/17.
//  Copyright © 2017 TouchSix Inc. All rights reserved.
//

#import "NSString+NSAttributedString.h"

@implementation NSString (NSAttributedString)

- (NSAttributedString *)attributedString
{
  return [[NSAttributedString alloc] initWithString:self];
}

@end
