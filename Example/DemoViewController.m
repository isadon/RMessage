//
//  DemoViewController.m
//  RMessage
//
//  Created by Adonis Peralta on 12/7/15.
//  Copyright © 2015 Rendezvous Inc. All rights reserved.
//

#import "DemoViewController.h"
#import "RMessage.h"
#import "RMessageView.h"

@interface DemoViewController () <RMessageProtocol>

@end

@implementation DemoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [RMessage setDefaultViewController:self];
    [RMessage setDelegate:self];
    [self.navigationController.navigationBar setTranslucent:YES];
    self.extendedLayoutIncludesOpaqueBars = YES;
}

- (IBAction)didTapError:(id)sender
{
    [RMessage showNotificationWithTitle:NSLocalizedString(@"Something failed", nil)
                                subtitle:NSLocalizedString(@"The internet connection seems to be down. Please check it!", nil)
                                    type:RMessageTypeError
                        customTypeString:nil];
}

- (IBAction)didTapWarning:(id)sender
{
    [RMessage showNotificationWithTitle:NSLocalizedString(@"Some random warning", nil)
                                subtitle:NSLocalizedString(@"Look out! Something is happening there!", nil)
                                    type:RMessageTypeWarning
                        customTypeString:nil];
}

- (IBAction)didTapMessage:(id)sender
{
    [RMessage showNotificationWithTitle:NSLocalizedString(@"Tell the user something", nil)
                                subtitle:NSLocalizedString(@"This is some neutral notification!", nil)
                                    type:RMessageTypeNormal
                        customTypeString:nil];
}

- (IBAction)didTapSuccess:(id)sender
{
    [RMessage showNotificationWithTitle:NSLocalizedString(@"Success", nil)
                                subtitle:NSLocalizedString(@"Some task was successfully completed!", nil)
                                    type:RMessageTypeSuccess
                        customTypeString:nil];
}

- (IBAction)didTapButton:(id)sender
{
    [RMessage showNotificationInViewController:self
                                          title:NSLocalizedString(@"New version available", nil)
                                       subtitle:NSLocalizedString(@"Please update our app. We would be very thankful", nil)
                                          iconImage:nil
                                           type:RMessageTypeNormal
                               customTypeString:nil
                                       duration:RMessageDurationAutomatic
                                       callback:nil
                                    buttonTitle:NSLocalizedString(@"Update", nil)
                                 buttonCallback:^{
                                     [RMessage showNotificationWithTitle:NSLocalizedString(@"Thanks for updating", nil)
                                                                     type:RMessageTypeSuccess
                                                         customTypeString:nil];
                                 }
                                     atPosition:RMessagePositionTop
                           canBeDismissedByUser:YES];
}

- (IBAction)didTapToggleNavigationBar:(id)sender
{
    [self.navigationController setNavigationBarHidden:!self.navigationController.navigationBarHidden animated:YES];
}

- (IBAction)didTapToggleNavigationBarAlpha:(id)sender
{
    CGFloat alpha = self.navigationController.navigationBar.alpha;
    self.navigationController.navigationBar.alpha = (alpha == 1.f) ? 0.5 : 1;
}

- (IBAction)didTapToggleWantsFullscreen:(id)sender
{
    self.extendedLayoutIncludesOpaqueBars = !self.extendedLayoutIncludesOpaqueBars;
    [self.navigationController.navigationBar setTranslucent:!self.navigationController.navigationBar.isTranslucent];
}

- (IBAction)didTapCustomImage:(id)sender
{
    [RMessage showNotificationInViewController:self
                                          title:NSLocalizedString(@"Custom image", nil)
                                       subtitle:NSLocalizedString(@"This uses an image you can define", nil)
                                          iconImage:[UIImage imageNamed:@"NotificationButtonBackground.png"]
                                           type:RMessageTypeNormal
                               customTypeString:nil
                                       duration:RMessageDurationAutomatic
                                       callback:nil
                                    buttonTitle:nil
                                 buttonCallback:nil
                                     atPosition:RMessagePositionTop
                           canBeDismissedByUser:YES];
}

- (IBAction)didTapDismissCurrentMessage:(id)sender
{
    [RMessage dismissActiveNotification];
}

- (IBAction)didTapEndless:(id)sender
{
    [RMessage showNotificationInViewController:self
                                          title:NSLocalizedString(@"Endless", nil)
                                       subtitle:NSLocalizedString(@"This message can not be dismissed and will not be hidden automatically. Tap the 'Dismiss' button to dismiss the currently shown message", nil)
                                          iconImage:nil
                                           type:RMessageTypeSuccess
                               customTypeString:nil
                                       duration:RMessageDurationEndless
                                       callback:nil
                                    buttonTitle:nil
                                 buttonCallback:nil
                                     atPosition:RMessagePositionTop
                           canBeDismissedByUser:NO];
}

- (IBAction)didTapLong:(id)sender
{
    [RMessage showNotificationInViewController:self
                                          title:NSLocalizedString(@"Long", nil)
                                       subtitle:NSLocalizedString(@"This message is displayed 10 seconds instead of the calculated value", nil)
                                          iconImage:nil
                                           type:RMessageTypeWarning
                               customTypeString:nil
                                       duration:10.0
                                       callback:nil
                                    buttonTitle:nil
                                 buttonCallback:nil
                                     atPosition:RMessagePositionTop
                           canBeDismissedByUser:YES];
}

- (IBAction)didTapBottom:(id)sender
{
    [RMessage showNotificationInViewController:self
                                          title:NSLocalizedString(@"Hu!", nil)
                                       subtitle:NSLocalizedString(@"I'm down here :)", nil)
                                          iconImage:nil
                                           type:RMessageTypeSuccess
                               customTypeString:nil
                                       duration:RMessageDurationAutomatic
                                       callback:nil
                                    buttonTitle:nil
                                 buttonCallback:nil
                                     atPosition:RMessagePositionBottom
                           canBeDismissedByUser:YES];
}

- (IBAction)didTapText:(id)sender
{
    [RMessage showNotificationWithTitle:NSLocalizedString(@"With 'Text' I meant a long text, so here it is", nil)
                                subtitle:NSLocalizedString(@"Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus.At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus", nil)
                                    type:RMessageTypeWarning
                        customTypeString:nil];
}

- (IBAction)didTapCustomDesign:(id)sender
{
    // this is an example on how to apply a custom design
    [RMessage addDesignsFromFileWithName:@"AlternativeDesigns" inBundle:[NSBundle mainBundle]];
    [RMessage showNotificationWithTitle:NSLocalizedString(@"Added custom design file", nil)
                                subtitle:NSLocalizedString(@"This background is blue while the subtitles are white. Yes this is still an alternate error design :)", nil)
                                    type:RMessageTypeCustom
                        customTypeString:@"alternate-error"];
}


- (IBAction)didTapNavBarOverlay:(id)sender
{
    if (self.navigationController.navigationBarHidden){
        [self.navigationController setNavigationBarHidden:NO];
    }

    [RMessage showNotificationInViewController:self.navigationController
                                          title:NSLocalizedString(@"Whoa!", nil)
                                       subtitle:NSLocalizedString(@"Over the Navigation Bar!", nil)
                                          iconImage:nil
                                           type:RMessageTypeSuccess
                               customTypeString:nil
                                       duration:RMessageDurationAutomatic
                                       callback:nil
                                    buttonTitle:nil
                                 buttonCallback:nil
                                     atPosition:RMessagePositionNavBarOverlay
                           canBeDismissedByUser:YES];
}



//- (CGFloat)messageLocationOfMessageView:(RMessageView *)messageView
//{
//    return 44.0; // any calculation here
//}

//- (void)customizeMessageView:(RMessageView *)messageView
//{
//    messageView.alpha = 0.5;
//}

- (IBAction)didTapNavbarHidden:(id)sender
{
    self.navigationController.navigationBarHidden = !self.navigationController.navigationBarHidden;
}

@end
