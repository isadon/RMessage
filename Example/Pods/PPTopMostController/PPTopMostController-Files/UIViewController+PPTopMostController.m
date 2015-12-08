//
//  UIViewController+PPTopMostController.m
//  PPTopMostController
//
//  Created by Marian Paul on 24/05/13.
//  Copyright (c) 2013 iPuP. All rights reserved.
//

#import "UIViewController+PPTopMostController.h"
#import "UINavigationController+PPTopMostController.h"
#import "UITabBarController+PPTopMostController.h"

@implementation UIViewController (PPTopMostController)

+ (UIViewController *)getModalViewControllerOfControllerIfExists:(UIViewController *)controller {
    UIViewController *toReturn = nil;
    // modalViewController is deprecated since iOS 6, so use presentedViewController instead
    if ([controller respondsToSelector:@selector(presentedViewController)]) toReturn = [controller performSelector:@selector(presentedViewController)];
    else toReturn = [controller performSelector:@selector(modalViewController)];
    
    // If no modal view controller found, return the controller itself
    if (!toReturn) toReturn = controller;
    return toReturn;
}

+ (UIViewController *)topMostController {
    // Start with the window rootViewController
    UIViewController *topController = ((UIWindow *)[[UIApplication sharedApplication].windows objectAtIndex:0]).rootViewController;
    
    // Is there any modal view on top?
    topController = [self getModalViewControllerOfControllerIfExists:topController];
    
    // Keep reference to the old controller while looping
    UIViewController *oldTopController = nil;
    
    // Loop them all
    while ([topController conformsToProtocol:@protocol(PPTopMostControllerProtocol)] && oldTopController != topController) {
        oldTopController = topController;
        topController = [(UIViewController < PPTopMostControllerProtocol > *) topController visibleViewController];
        // Again, check for any modal controller
        topController = [self getModalViewControllerOfControllerIfExists:topController];
    }
    
    return topController;
}

@end
