Pod::Spec.new do |s|
  s.name             = 'gma_mediation_maio'
  s.version = '1.0.0'
  s.summary = 'Google Mobile Ads Mediation of maio.'
  s.description      = <<-DESC
  Mediation Adapter for maio to use with Google Mobile Ads.
                       DESC
            s.homepage = 'https://developers.google.com/admob/flutter/mediation/maio'
  s.license          = { :file => '../LICENSE' }
  s.author = { 'Google LLC' => 'mediation-support@google.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.dependency 'GoogleMobileAdsMediationMaio', '~>2.1.6.0'
  s.platform = :ios, '12.0'
  s.static_framework = true

  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'

end
