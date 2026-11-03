Pod::Spec.new do |s|
  s.name             = 'gma_mediation_line'
  s.version = '2.2.2'
  s.summary = 'Google Mobile Ads Mediation of Line.'
  s.description      = <<-DESC
  Mediation Adapter for Line to use with Google Mobile Ads.
                       DESC
            s.homepage = 'https://developers.google.com/admob/flutter/mediation/line'
  s.license          = { :file => '../LICENSE' }
  s.author = { 'Google LLC' => 'mediation-support@google.com' }
  s.source           = { :path => '.' }
  s.source_files = 'gma_mediation_line/Sources/gma_mediation_line/**/*'
  s.dependency 'Flutter'
  s.dependency 'GoogleMobileAdsMediationLine', '~>3.1.1.0'
  s.platform = :ios, '15.0'
  s.static_framework = true

  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '6.0'

end
