//
//  UITabBarController+PPTopMostController.m
//  PPTopMostController
//
//  Created by Marian Paul on 24/05/13.
//  Copyright (c) 2013 iPuP. All rights reserved.
//

#import "UITabBarController+PPTopMostController.h"

@implementation UITabBarController (PPTopMostController)

- (UIViewController *)visibleViewController {
    return self.selectedViewController;
}

@end
