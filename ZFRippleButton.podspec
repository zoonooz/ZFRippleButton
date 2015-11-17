#
# Be sure to run `pod lib lint NAME.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "ZFRippleButton"
  s.version          = "0.5.1"
  s.summary          = "Custom UIButton effect inspired by Google Material Design"
  s.homepage         = "https://github.com/zoonooz/ZFRippleButton"
  s.license          = 'MIT'
  s.author           = { "Amornchai Kanokpullwad" => "amornchai.zoon@gmail.com" }
  s.source           = { :git => "https://github.com/zoonooz/ZFRippleButton.git", :tag => s.version.to_s }

  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.source_files = 'Classes/*.swift'

  # s.frameworks = 'UIKit'

end
