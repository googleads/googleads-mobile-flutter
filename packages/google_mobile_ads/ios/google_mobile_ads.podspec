#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name             = 'google_mobile_ads'
  s.version          = '7.0.0'
  s.summary          = 'Google Mobile Ads plugin for Flutter.'
  s.description      = <<-DESC
Google Mobile Ads plugin for Flutter.
                       DESC
  s.homepage         = 'https://github.com/googleads/googleads-mobile-flutter'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Flutter Team' => 'flutter-dev@googlegroups.com' }
  s.source           = { :path => '.' }
  s.source_files = 'google_mobile_ads/Sources/google_mobile_ads/**/*.{h,m}'
  s.public_header_files = 'google_mobile_ads/Sources/google_mobile_ads/**/*.h'
  s.dependency 'Flutter'
  s.dependency 'Google-Mobile-Ads-SDK','~> 12.14.0'
  s.dependency 'webview_flutter_wkwebview'
  s.ios.deployment_target = '13.0'
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'VALID_ARCHS' => 'armv7 arm64 x86_64' }
  s.static_framework = true
  s.resource_bundles = {
   'google_mobile_ads' => ['google_mobile_ads/Sources/google_mobile_ads/**/*.xib']
  }

  s.test_spec 'Tests' do |test_spec|
    test_spec.source_files = 'Tests/**/*.{h,m}'
    test_spec.dependency 'OCMock','3.6'
  end
end
