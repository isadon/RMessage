PPTopMostControllerProtocol
=======================

This project aims to simplify the code behind "*which controller/view is on screen*".

Sometimes, you may want to dispatch an event to the current displayed controller. For example:

- A notification view like the download of the resource is complete,
- A view which tells you the status of the app, online or offline,
- etc

For those usages with a notification view, you probably want to display the view without any efforts to the displayed controller. And more important, the view should stay displayed even if you push a new view from navigation controller.

Just to be clear, this protocol only gives you the tools to get the current displayed controller. It's up to you to do something useful with this tool.
There is an example on the sample code provided with a [NotificationView](https://github.com/ipodishima/PPTopMostController/blob/master/PPTopMostController/PPTopMostController/NotificationView.m). Please also take a look at RZNotificationView (coming soon)

Please also note that PPTopMostController does support modal controllers.

# Try it with MacBuildServer

<!-- MacBuildServer Install Button -->
<div class="macbuildserver-block">
    <a class="macbuildserver-button" href="http://macbuildserver.com/project/github/build/?xcode_project=PPTopMostController%2FPPTopMostController.xcodeproj&amp;target=PPTopMostController&amp;repo_url=git%40github.com%3Aipodishima%2FPPTopMostController.git&amp;build_conf=Release" target="_blank"><img src="http://com.macbuildserver.github.s3-website-us-east-1.amazonaws.com/button_up.png"/></a><br/><sup><a href="http://macbuildserver.com/github/opensource/" target="_blank">by MacBuildServer</a></sup>
</div>
<!-- MacBuildServer Install Button -->
#Installation

The easiest way to install PPTopMostController is via the [CocoaPods](http://cocoapods.org/) package manager, since it's really flexible and provides easy installation.

## Via CocoaPods (coming soon)

If you don't have cocoapods yet (shame on you), install it:

``` bash
$ [sudo] gem install cocoapods
$ pod setup
```

Go to the directory of your Xcode project, and Create and/or Edit your Podfile and add PPTopMostController:

``` bash
$ cd /path/to/MyProject
$ touch Podfile
# Edit the podfile using your favorite editor
$ edit Podfile
platform :ios 
pod 'PPTopMostController', '~> the version you want'
```

Run the install:

``` bash
$ pod install
```

Finally, open your project in Xcode from the .xcworkspace file (not the usual project file! This is really important)

``` bash
$ open MyProject.xcworkspace
```

Import *UIViewController+PPTopMostController.h* file to your PCH file or your AppDelegate file.

You are ready to go.

## Old fashionned way

1. Add PPTopMostController as a submodule to your project

``` bash
$ cd /path/to/MyApplication
# If this is a new project, initialize git...
$ git init
$ git submodule add git@github.com:ipodishima/PPTopMostController.git vendor/PPTopMostController
$ git submodule update --init --recursive
```

2. In your XCode Project, take all the files from PPTopMostController-Files folder and drag them into your project. 
3. Import *UIViewController+PPTopMostController.h* file to your PCH file or your AppDelegate file.

You are ready to go.

# ARC Support

PPTopMostController does not care about ARC and non-ARC. Do whatever you want!

# Compatibility

From iOS 4 to iOS 6.

# Usage

## Get the current displayed controller

To get the top most controller displayed, just do

    UIViewController *c = [UIViewController topMostController];

And you are done.

## Add support for custom container

There is an example with [PPRevealSideViewController](https://github.com/ipup/PPRevealSideViewController) on the sample. 

1. Create a category on your container : *YourContainer+PPTopMostController.h* (don't forget to import the header somewhere)
2. Import the PPTopMostController protocol : `#import "PPTopMostControllerProtocol.h"`
3. Adopt the protocol
````
    @interface YourContainer (PPTopMostController) <PPTopMostControllerProtocol>
````    
4. Conforms to it

    - (UIViewController *)visibleViewController {
        return /*The controller you want to set it's top one. Remember that PPTopMostController go through controller hierarchy and find controllers conforming to PPTopMostControllerProtocol*/;
    }

That's it!

# Why PPTopMostController?
Let's take the case where you have for example a manager which downloads data + a view which triggers notification when an error occured.

## Using a delegate

(This would be quite the same idea with completion block)
You would declare a protocol
   
    @protocol DLManagerDelegate
    - (void) dlManager:(DLManager*)manager didFailWithError:(NSError*)error;
    @end

And create a property for the delegate

    @property (nonatomic, weak) id<DLManagerDelegate> delegate;
    
In each controller, you would adopt the protocol

    @interface AController : UIViewController <DLManagerDelegate>
    
And implement the method

    - (void) dlManager:(DLManager*)manager didFailWithError:(NSError*)error
    {
        [NotificationView showFromController:self ...];
    }
    
Tell the delegate when failing

    - (void) weFail:(NSError*)error
    {
        [self.delegate dlManager:self didFailWithError:error];
    }
    
Plus managed the thing that if you change the controller displayed, reassign correctly the delegate

    [[DLManager shared] setDelegate:self];
    
**Boring**

## Using notifications

You would declare the notification

    extern NSString *const DLManagerDidFailNotification;

+

    NSString *const DLManagerDidFailNotification = @"DLManagerDidFailNotification";
    
Post it when failing

    - (void) weFail:(NSError*)error
    {
        NSDictionary *userInfo = @{@"error": error};
        [[NSNotificationCenter defaultCenter] postNotificationName:DLManagerDidFailNotification object:nil userInfo:userInfo];
    }
    
And in each controller, you add observer

        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(dispatchNotificationFail:)
                                                     name:DLManagerDidFailNotification
                                                   object:nil];   
                                                   
Don't forget to remove the observer

And implement the method

    - (void) dispatchNotificationFail:(NSNotification*)notif
    {
        [NotificationView showFromController:self ...];
    }

**Boring**

## Using PPTopMostController

Just implement the method `weFail:` from DLManager

    - (void) weFail:(NSError*)error
    {
        [NotificationView showFromController:[UIViewController topMostController] ...];
    }

**Not boring**

License
-------

This Code is released under the MIT License by [Marian Paul for iPuP SARL](http://www.ipup.pro)

Please tell me when you use this protocol in your project! And if you have great controls build with PPTopMostController, let me a note, I will include the link on this readme 

Regards,  
Marian Paul aka ipodishima
  
http://www.ipup.pro
