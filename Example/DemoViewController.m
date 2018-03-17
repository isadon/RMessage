//
//  DemoViewController.m
//  RMessage
//
//  Created by Adonis Peralta on 12/7/15.
//  Copyright © 2015 Adonis Peralta. All rights reserved.
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
  [self.navigationController.navigationBar setTranslucent:YES];
  self.extendedLayoutIncludesOpaqueBars = YES;
  //[[RMessageView appearance] setTitleSubtitleLabelsSizeToFit:YES];
}

// Uncomment to test hidden status bar functionality
//- (BOOL)prefersStatusBarHidden
//{
//  return YES;
//}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
  [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
  [coordinator animateAlongsideTransition:nil completion:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
     [RMessage interfaceDidRotate];
  }];
}

- (void)viewDidAppear:(BOOL)animated
{
  [super viewDidAppear:animated];
  /* Normally we would set the default view controller and delegate in viewDidLoad
     but since we are using this view controller for our modal view also it is important to properly
     re-set the variables once the modal dismisses. */
  [RMessage setDefaultViewController:self];
  [RMessage setDelegate:self];
}

- (IBAction)didTapError:(id)sender
{
  [RMessage
    showNotificationWithTitle:@"Something failed"
                     subtitle:@"The internet connection seems to be down. Please check it!"
                         type:RMessageTypeError
               customTypeName:nil
                     callback:nil];
}

- (IBAction)didTapWarning:(id)sender
{
  [RMessage showNotificationWithTitle:@"Some random warning"
                             subtitle:@"Look out! Something is happening there!"
                                 type:RMessageTypeWarning
                       customTypeName:nil
                             callback:nil];
}

- (IBAction)didTapMessage:(id)sender
{
  [RMessage showNotificationWithTitle:@"Tell the user something"
                             subtitle:@"This is a neutral notification!"
                                 type:RMessageTypeNormal
                       customTypeName:nil
                             callback:nil];
}

- (IBAction)didTapSuccess:(id)sender
{
  [RMessage showNotificationWithTitle:@"Success"
                             subtitle:@"Some task was successfully completed!"
                                 type:RMessageTypeSuccess
                       customTypeName:nil
                             callback:nil];
}

- (IBAction)didTapButton:(id)sender
{
  [RMessage showNotificationInViewController:self
                                       title:@"New version available"
                                    subtitle:@"Please update our app. We would be very thankful"
                                   iconImage:nil
                                        type:RMessageTypeNormal
                              customTypeName:nil
                                    duration:RMessageDurationAutomatic
                                    callback:nil
                                 buttonTitle:@"Update"
                              buttonCallback:^{
                                [RMessage dismissActiveNotification];
                                [RMessage showNotificationWithTitle:@"Thanks for updating"
                                                               type:RMessageTypeSuccess
                                                     customTypeName:nil
                                                           callback:nil];
                              }
                                  atPosition:RMessagePositionTop
                        canBeDismissedByUser:YES];
}

- (IBAction)didTapCustomImage:(id)sender
{
  [RMessage showNotificationInViewController:self
                                       title:@"Custom image"
                                    subtitle:@"This uses an image you can define"
                                   iconImage:[UIImage imageNamed:@"NotificationButtonBackground.png"]
                                        type:RMessageTypeNormal
                              customTypeName:nil
                                    duration:RMessageDurationAutomatic
                                    callback:nil
                                 buttonTitle:nil
                              buttonCallback:nil
                                  atPosition:RMessagePositionTop
                        canBeDismissedByUser:YES];
}

- (IBAction)didTapEndless:(id)sender
{
  [RMessage showNotificationInViewController:self
                                       title:@"Endless"
                                    subtitle:@"This message can not be dismissed and will not be "
                                             @"hidden automatically. Tap the 'Dismiss' button "
                                             @"to dismiss the currently shown message"
                                   iconImage:nil
                                        type:RMessageTypeSuccess
                              customTypeName:nil
                                    duration:RMessageDurationEndless
                                    callback:^{NSLog(@"tapped");}
                        presentingCompletion:^{NSLog(@"presented");}
                           dismissCompletion:^{NSLog(@"dismissed");}
                                 buttonTitle:nil
                              buttonCallback:nil
                                  atPosition:RMessagePositionTop
                        canBeDismissedByUser:NO];
}

- (IBAction)didTapLong:(id)sender
{
  [RMessage showNotificationInViewController:self
                                       title:@"Long"
                                    subtitle:@"This message is displayed 10 seconds "
                                             @"instead of the calculated value"
                                   iconImage:nil
                                        type:RMessageTypeWarning
                              customTypeName:nil
                                    duration:10.0
                                    callback:^{NSLog(@"tapped");}
                        presentingCompletion:^{NSLog(@"presented");}
                           dismissCompletion:^{NSLog(@"dismissed");}
                                 buttonTitle:nil
                              buttonCallback:nil
                                  atPosition:RMessagePositionTop
                        canBeDismissedByUser:YES];
}

- (IBAction)didTapBottom:(id)sender
{
  [RMessage showNotificationInViewController:self
                                       title:@"Hi!"
                                    subtitle:@"I'm down here :)"
                                   iconImage:nil
                                        type:RMessageTypeSuccess
                              customTypeName:nil
                                    duration:RMessageDurationAutomatic
                                    callback:nil
                                 buttonTitle:nil
                              buttonCallback:nil
                                  atPosition:RMessagePositionBottom
                        canBeDismissedByUser:YES];
}

- (IBAction)didTapText:(id)sender
{
  [RMessage
    showNotificationWithTitle:@"With 'Text' I meant a long text, so here it is"
                     subtitle:@"Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed "
                              @"diam nonumy eirmod tempor invidunt ut labore et dolore magna "
                              @"aliquyam erat, sed diam voluptua. At vero eos et accusam et "
                              @"justo duo dolores et ea rebum. Stet clita kasd gubergren, no "
                              @"sea takimata sanctus.At vero eos et accusam et justo duo "
                              @"dolores et ea rebum. Stet clita kasd gubergren, no sea takimata "
                              @"sanctus.Lorem ipsum dolor sit amet, consetetur sadipscing "
                              @"elitr, sed diam nonumy eirmod tempor invidunt ut labore et "
                              @"dolore magna aliquyam erat, sed diam voluptua. At vero eos et "
                              @"accusam et justo duo dolores et ea rebum. Stet clita kasd "
                              @"gubergren, no sea takimata sanctus.At vero eos et accusam et "
                              @"justo duo dolores et ea rebum. Stet clita kasd gubergren, no "
                              @"sea takimata sanctus."
                         type:RMessageTypeWarning
               customTypeName:nil
                     callback:nil];
}

- (IBAction)didTapCustomDesign:(id)sender
{
  // This is an example on how to apply a custom design
  [RMessage addDesignsFromFileWithName:@"AlternativeDesigns" inBundle:[NSBundle mainBundle]];
  [RMessage showNotificationWithTitle:@"Added custom design file"
                             subtitle:@"This background is blue while the "
                                      @"subtitles are white. Yes this is still "
                                      @"an alternate error design :)"
                                 type:RMessageTypeCustom
                       customTypeName:@"alternate-error"
                             callback:nil];
}

- (IBAction)didTapDismissCurrentMessage:(id)sender
{
  [RMessage dismissActiveNotification];
}

- (IBAction)didTapDismissModal:(id)sender
{
  [self dismissViewControllerAnimated:YES completion:nil];
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

- (IBAction)didTapNavBarOverlay:(id)sender
{
  if (self.navigationController.navigationBarHidden) {
    [self.navigationController setNavigationBarHidden:NO];
  }

  [RMessage showNotificationInViewController:self.navigationController
                                       title:@"Whoa!"
                                    subtitle:@"Over the Navigation Bar!"
                                   iconImage:nil
                                        type:RMessageTypeSuccess
                              customTypeName:nil
                                    duration:RMessageDurationAutomatic
                                    callback:nil
                                 buttonTitle:nil
                              buttonCallback:nil
                                  atPosition:RMessagePositionNavBarOverlay
                        canBeDismissedByUser:YES];
}

- (IBAction)didTapNavbarHidden:(id)sender
{
  self.navigationController.navigationBarHidden = !self.navigationController.navigationBarHidden;
}

/*- (CGFloat)customVerticalOffsetForMessageView:(RMessageView *)messageView
{
  return 88.f; // specify an additional offset here.
}
*/

//- (void)customizeMessageView:(RMessageView *)messageView
//{
//  UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 500)];
//  button.contentEdgeInsets = UIEdgeInsetsMake(250, 25, 250, 25);
//  [button setTitle:@"hey there" forState:UIControlStateNormal];
//  button.titleLabel.font = [UIFont boldSystemFontOfSize:12.f];
//  button.titleLabel.textColor = [UIColor whiteColor];
//  button.backgroundColor = [UIColor blueColor];
//  [button addTarget:self action:@selector(buttonTapped) forControlEvents:UIControlEventTouchUpInside];
//  [messageView setButton:button];
//  messageView.layer.cornerRadius = 20.f;
//}

//- (void)buttonTapped
//{
//  NSLog(@"button was tapped");
//}

@end
