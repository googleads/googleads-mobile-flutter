#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name             = 'google_mobile_ads'
  s.version          = '5.1.0'
  s.summary          = 'Google Mobile Ads plugin for Flutter.'
  s.description      = <<-DESC
Google Mobile Ads plugin for Flutter.
                       DESC
  s.homepage         = 'https://github.com/googleads/googleads-mobile-flutter'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Flutter Team' => 'flutter-dev@googlegroups.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*.{h,m}'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  s.dependency 'Google-Mobile-Ads-SDK','~> 11.2.0'
  s.dependency 'webview_flutter_wkwebview'
  s.ios.deployment_target = '12.0'
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'VALID_ARCHS' => 'armv7 arm64 x86_64' }
  s.static_framework = true
  s.resource_bundles = {
   'google_mobile_ads' => ['Classes/**/*.xib']
  }

  s.test_spec 'Tests' do |test_spec|
    test_spec.source_files = 'Tests/**/*.{h,m}'
    test_spec.dependency 'OCMock','3.6'
  end
end
