//
//  UIViewController+PPTopMostController.h
//  PPTopMostController
//
//  Created by Marian Paul on 24/05/13.
//  Copyright (c) 2013 iPuP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPTopMostControllerProtocol.h"

@interface UIViewController (PPTopMostController)
/**
 This is your entry point.
 Will return the top most controller, looping through each controllers adopting the PPTopMostControllerProtocol
 */
+ (UIViewController *)topMostController;
@end
