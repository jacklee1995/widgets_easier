#
# Run `pod lib lint widgets_easier_privacy_guard.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'widgets_easier_privacy_guard'
  s.version          = '1.0.0'
  s.summary          = 'Keeps a Flutter macOS window out of screenshots and screen sharing.'
  s.description      = <<-DESC
Keeps a Flutter macOS window out of screenshots, recordings and screen sharing.
Part of Widgets Easier.
                       DESC
  s.homepage         = 'https://github.com/jacklee1995/widgets_easier/tree/master/packages/widgets_easier_privacy_guard'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'jacklee1995' => '291148484@163.com' }

  s.source           = { :path => '.' }
  s.source_files = 'widgets_easier_privacy_guard/Sources/widgets_easier_privacy_guard/**/*.swift'
  s.resource_bundles = {'widgets_easier_privacy_guard_privacy' => ['widgets_easier_privacy_guard/Sources/widgets_easier_privacy_guard/PrivacyInfo.xcprivacy']}

  s.dependency 'FlutterMacOS'

  s.platform = :osx, '10.15'
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES' }
  s.swift_version = '5.0'
end
