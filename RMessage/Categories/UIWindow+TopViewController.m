//
//  UIWindow+TopViewController.m
//
//  Created by Adonis Peralta on 3/16/17.
//  Copyright © 2017 Adonis Peralta. All rights reserved.
//

#import "UIWindow+TopViewController.h"

@implementation UIWindow (TopViewController)

+ (UIViewController *)topViewControllerForViewController:(UIViewController *)viewController
{
  if (viewController.presentedViewController) {
    return [self topViewControllerForViewController:viewController.presentedViewController];
  } else if ([viewController isKindOfClass:[UINavigationController class]]) {
    return [self topViewControllerForViewController:((UINavigationController *)viewController).visibleViewController];
  } else if ([viewController isKindOfClass:[UITabBarController class]]) {
    return [self topViewControllerForViewController:((UITabBarController *)viewController).selectedViewController];
  } else {
    return viewController;
  }
}

+ (UIViewController *)topViewController
{
  return [self.class topViewControllerForViewController:[UIApplication sharedApplication].keyWindow.rootViewController];
}

@end
