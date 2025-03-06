Pod::Spec.new do |s|
  s.name             = 'gma_mediation_mytarget'
  s.version = '1.0.0'
  s.summary = 'Google Mobile Ads Mediation of mytarget.'
  s.description      = <<-DESC
  Mediation Adapter for mytarget to use with Google Mobile Ads.
                       DESC
            s.homepage = 'https://developers.google.com/admob/flutter/mediation/mytarget'
  s.license          = { :file => '../LICENSE' }
  s.author = { 'Google LLC' => 'mediation-support@google.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.dependency 'GoogleMobileAdsMediationMyTarget', '~>5.25.1.0'
  s.platform = :ios, '12.0'
  s.static_framework = true

  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'

end
