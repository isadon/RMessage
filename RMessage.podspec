#
# Be sure to run `pod lib lint RMessage.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "RMessage"
  s.version          = "3.0.3"
  s.license          = 'MIT'
  s.summary          = "Easy to use and customizable messages/notifications for iOS"
  s.homepage         = "https://github.com/donileo/RMessage"
  s.description      = <<-DESC
This framework provides an easy to use class to show small customizable notification views on to the screen.
The notification animates on to the screen to your target position, top, bottom, etc and then dismisses according to various options, automatic, on tap, on swipe, never etc.
There are 4 different types already set up for you: Success, Error, Warning, Message, Custom. Give it a try!
DESC
  s.author           = { "Adonis Peralta" => "donileo@gmail.com" }
  s.social_media_url = 'https://twitter.com/donileo'

  s.source           = { :git => "https://github.com/donileo/RMessage.git", :tag => s.version.to_s }
  s.platform     = :ios, '11.0'
  s.swift_version = "4.1"
  s.requires_arc = true
  s.source_files = 'Sources/**/*.{swift}'
  s.resources = ['Sources/Resources/**/*.xib', 'Sources/Assets/**/*.{png,jpg,jpeg,json,pdf}']
  s.dependency 'HexColors', '~> 6.0'
end
