#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint gma_mediation_ironsource.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'gma_mediation_ironsource'
  s.version          = '1.2.0'
  s.summary          = 'Google Mobile Ads Mediation of ironSource.'
  s.description      = <<-DESC
Mediation Adapter for ironSource to use with Google Mobile Ads.
                       DESC
  s.homepage         = 'https://developers.google.com/admob/flutter/mediation/ironsource'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Google LLC' => 'mediation-support@google.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  s.dependency 'GoogleMobileAdsMediationIronSource', '~>8.6.1.0.0'
  s.platform = :ios, '12.0'
  s.static_framework = true

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end
