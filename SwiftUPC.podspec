#
# Be sure to run `pod lib lint SwiftUPC.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'SwiftUPC'
  s.version          = '0.0.1'
  s.summary          = 'Generate UPC-A barcodes from text.'
  s.swift_version    = '5.1'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
Small, lightweight library for generating UPC-A barcodes from text data. Currently provides utilities for parsing
structured barcode data from a string representation, as well as a custom UIKit view for displaying barcode data.
                       DESC

  s.homepage         = 'https://github.com/hatchedlabs/SwiftUPC'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.authors          = { 'Hatched Labs' => 'opensource@hatchedlabs.com',
                         'Cory Juhlin' => 'cory@hatchedlabs.com' }
  s.source           = { :git => 'https://github.com/hatchedlabs/SwiftUPC.git', :tag => s.version.to_s }
  s.ios.deployment_target = '12.0'
  s.source_files = 'SwiftUPC/Classes/**/*'
  # s.resource_bundles = {
  #   'SwiftUPC' => ['SwiftUPC/Assets/*.png']
  # }
  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
end
