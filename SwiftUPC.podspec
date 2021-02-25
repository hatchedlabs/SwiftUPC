#
# Be sure to run `pod lib lint SwiftUPC.podspec' to ensure this is a
# valid spec before submitting.
#
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'SwiftUPC'
  s.version          = '0.0.2'
  s.summary          = 'Generate UPC-A barcodes from text.'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.swift_version    = '5.1'
  s.description      = <<-DESC
Small, lightweight library for generating UPC-A barcodes from text data. Currently provides utilities for parsing
structured barcode data from a string representation, as well as a custom UIKit view for displaying barcode data.
                       DESC

  s.homepage         		= 'https://github.com/hatchedlabs/SwiftUPC'
  s.authors          		= { 'Hatched Labs' => 'opensource@hatchedlabs.com' }
  s.source           		= { :git => 'https://github.com/hatchedlabs/SwiftUPC.git', :tag => s.version.to_s }
  s.ios.deployment_target 	= '12.0'
  s.source_files 		= 'SwiftUPC/Classes/**/*'

  # s.resource_bundles = {
  #   'SwiftUPC' => ['SwiftUPC/Assets/*.png']
  # }
  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
end
