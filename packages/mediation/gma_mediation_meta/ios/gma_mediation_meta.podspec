#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint gma_mediation_meta.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'gma_mediation_meta'
  s.version          = '1.1.0'
  s.summary          = 'Google Mobile Ads Mediation of Meta Audience Network.'
  s.description      = <<-DESC
Mediation Adapter for Meta Audience Network to use with Google Mobile Ads.
                       DESC
  s.homepage         = 'https://developers.google.com/admob/flutter/mediation/meta'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Google LLC' => 'mediation-support@google.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  s.dependency 'GoogleMobileAdsMediationFacebook', '~> 6.15.2.0'
  s.platform = :ios, '12.0'
  s.static_framework = true

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end
