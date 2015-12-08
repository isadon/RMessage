//
//  UINavigationController+PPTopMostController.m
//  PPTopMostController
//
//  Created by Marian Paul on 24/05/13.
//  Copyright (c) 2013 iPuP. All rights reserved.
//

#import "UINavigationController+PPTopMostController.h"

@implementation UINavigationController (PPTopMostController)

- (UIViewController *)visibleViewController {
    return self.topViewController;
}

@end
