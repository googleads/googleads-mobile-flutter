#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint gma_mediation_unity.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'gma_mediation_unity'
  s.version          = '1.0.0'
  s.summary          = 'Google Mobile Ads Mediation of Unity Ads.'
  s.description      = <<-DESC
Mediation Adapter for Unity Ads to use with Google Mobile Ads.
                       DESC
  s.homepage         = 'https://github.com/googleads/googleads-mobile-flutter/tree/main/packages/google_mobile_ads/mediation'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Google LLC' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  s.dependency 'GoogleMobileAdsMediationUnity'
  s.platform = :ios, '11.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end
