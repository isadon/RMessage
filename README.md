RMessage
==========

[![Twitter: @donileo](https://img.shields.io/badge/contact-@donileo-blue.svg?style=flat)](https://twitter.com/donileo)
[![Version](https://img.shields.io/cocoapods/v/RMessage.svg?style=flat)](http://cocoadocs.org/docsets/RMessage)
[![License](https://img.shields.io/cocoapods/l/RMessage.svg?style=flat)](http://cocoadocs.org/docsets/RMessage)
[![Platform](https://img.shields.io/cocoapods/p/RMessage.svg?style=flat)](http://cocoadocs.org/docsets/RMessage)

## Screenshots

![ErrorUnder](Screenshots/ErrorUnder.png)

![SuccessUnder](Screenshots/SuccessUnder.png)

![ErrorOver](Screenshots/ErrorOver.png)

![WarningOver](Screenshots/WarningOver.png)

# Intro
Welcome to RMessage! RMessage is a simple notification library written in Swift to help you display notification on the screen. Many many customization options are available such as what position of the screen to present in, what colors should be applied to the title, body, background, etc, etc. There are many customizable properties and they can be viewed at the RMessageSpec protocol definition in the [RMessageSpec](https://github.com/donileo/RMessage/blob/master/Sources/RMessage/RMessageSpec.swift) file.

Get in contact with the developer on Twitter: [donileo](https://twitter.com/donileo) (Adonis Peralta)

# 3.0.0 Release

RMessage 3.0.0 is finally here with many new features from 2.x.x:

* Rewritten in Swift.
* Message notification designs are now easily specified in code via the RMessageSpec protocol - no more passing in design styles via a json design file.
* Support for generic UIViews for the Left/Right/Background of the message. Want to pass a UIButton for the left view or background view? Go ahead.
* Support for Attributed string stylings.
* Support for new message duration types such as messages that can only be dismissed by tapping, or swiping, or both.
* Support for canceling messages already in the queue waiting to be presented.
* Support for Carthage.
* Groundwork for custom animator objects via the RMessageAnimator Protocol has been set, support for passing in your own animators coming soon.

**Note: RMessage now requires iOS 11.0 and Swift 4.1. So be sure you are ok with not supporting devices below these targets when using RMessage. If you aren't ready to commit to these version of iOS yet feel free to use RMessage 2.x.x until you can.**

# Installation

### CocoaPods
For installation via [CocoaPods](https://cocoapods.org/) add the following line to your Podfile:

```
pod "RMessage" #This will install the latest
#pod "RMessage", '~> 2.3.0' # This will install RMessage versions of 2.3.x based on ObjC
```

### Carthage

For installation via [Carthage](https://github.com/Carthage/Carthage) add the following line to your Cartfile:

```
github "donileo/RMessage" ~> 3.0
```

### Manually
For manual installation copy the all the source files in the Sources folder to your project.

# Usage

To show a simple notification using the predefined "errorSpec" styling, animating from the top do the following:

```swift
// Create an instance of RMController, a controller object which handles the presentation
// of multiples messages on the screen
let rControl = RMController()

// Tell rControl to present the message
rControl.showMessage(
      withSpec: errorSpec,
      title: "Your Title",
      body: "A description"
)
```

To show your own button on the right, an icon (UIImage) on the left and animate from the bottom do this:

```swift
let rControl = RMController()
rControl.showMessage(
      withSpec: normalSpec,
      atPosition: .bottom,
      title: "Update available",
      body: "Please update the app",
      leftView: myIconImage,
      rightView: myUIButtonHere
)
```

To set a default view controller to present in and bypass the "internal presentation view controller detection":

```swift
   let rControl = RMController()
   rControl.presentationViewController = myViewController

   ...

   // All messages now presented by this controller will always be on myViewController
   rControl.showMessage(....)
```

Want to further customize a notification message right before its presented? Do the following:
```swift
   let rControl = RMController()
   rControl.delegate = self

   ...

   // Now lets implement the RMControllerDelegate customize(message:controller:) method which
   // RMController calls right before presenting:
   func customize(message: RMessage) {
   message.alpha = 0.4
   message.addSubview(aView)
  }
```

Feel like declaring your own custom message stylings? Simple!

```swift
let rControl = RMController()

// Customize the message, by using the DefaultRMessageSpec as your base.
// The DefaultRMessageSpec object is a struct with default values for a
// "default" RMessageSpec styling. All we need to do is pick up the the defaults
// from it and then just specify which variables we want customized. For a list
// of all the possible vars take a look at its definition!
var customSpec = DefaultRMessageSpec()
customSpec.backgroundColor = .red
customSpec.titleColor = .white
customSpec.bodyColor = .white
customSpec.iconImage = UIImage(named: "MyIcon.png")

// How about a custom spec based on the predefined warningSpec but with
// attributed string attributes for the title and body text?
var attrWarningSpec = warningSpec
attrWarningSpec.titleAttributes = [.backgroundColor: UIColor.red, .foregroundColor: UIColor.white]
attrWarningSpec.bodyAttributes = [
.backgroundColor: UIColor.blue, .foregroundColor: UIColor.white,
.underlineStyle: NSUnderlineStyle.styleSingle.rawValue,
]

// Now lets present Tell the RMController to present the message with your custom stylings.
rControl.showMessage(
      withSpec: customSpec,
      title: "I'm custom",
      body: "Nice!"
    )
```

Want to present a message that only disappers when tapped?

```swift
let rControl = RMController()

var tapOnlySpec = DefaultRMessageSpec()
tapOnlySpec.durationType = .tap

// Present it
rControl.showMessage(
      withSpec: tapOnlySpec,
      title: "Tap me Tap me!",
      body: "If you don't I wont dismiss!"
)
```

Want more examples? Take a look at the [DemoViewController](https://github.com/donileo/RMessage/blob/master/Demo/DemoViewController.swift) file in the RMessage project to see how to use this library. Its very simple.

# License
RMessage is available under the MIT license. See the LICENSE file for more information.

# Recent Changes
Can be found in the [releases section](https://github.com/donileo/RMessage/releases) of this repo.
