#
# Run `pod lib lint widgets_easier_privacy_guard.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'widgets_easier_privacy_guard'
  s.version          = '1.0.0'
  s.summary          = 'Background privacy blur, screenshot and screen recording detection for Flutter apps.'
  s.description      = <<-DESC
Background privacy blur, screenshot and screen recording detection, and an
opt-in screenshot block for Flutter apps. Part of Widgets Easier.
                       DESC
  s.homepage         = 'https://github.com/jacklee1995/widgets_easier/tree/master/packages/widgets_easier_privacy_guard'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'jacklee1995' => '291148484@163.com' }
  s.source           = { :path => '.' }
  s.source_files = 'widgets_easier_privacy_guard/Sources/widgets_easier_privacy_guard/**/*.swift'
  s.dependency 'Flutter'
  s.platform = :ios, '15.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'

  # The plugin collects no data and uses no required-reason APIs; the manifest
  # says so explicitly, which App Store review expects from SDKs.
  s.resource_bundles = {'widgets_easier_privacy_guard_privacy' => ['widgets_easier_privacy_guard/Sources/widgets_easier_privacy_guard/PrivacyInfo.xcprivacy']}
end
