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
  s.version          = "2.0.0"
  s.summary          = "Easy to use and customizable messages/notifications for iOS"
  s.description  = <<-DESC
                    This framework provides an easy to use class to show little notification views on the top of the screen.
The notification moves from the top of the screen underneath the navigation bar and stays there for a few seconds, depending on the length of the displayed text. To dismiss a notification before the time runs out, the user can swipe it to the top or just tap it.
There are 4 different types already set up for you: Success, Error, Warning, Message, Custom.
                   DESC
  s.homepage     = "https://github.com/donileo/RMessage"

  s.license          = 'MIT'
  s.author           = { "Adonis Peralta" => "donileo@gmail.com" }
  s.source           = { :git => "https://github.com/donileo/RMessage.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/donileo'

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'RMessage/**/*.{h,m}'
  s.resources = ['RMessage/Resources/**/*.xib', 'RMessage/Assets/**/*.{png,jpg,json}']
  s.public_header_files = 'RMessage/*.h'
  s.dependency 'HexColors', '~> 4.0'
  s.dependency 'PPTopMostController'
end
