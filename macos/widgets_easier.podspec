#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint widgets_easier.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'widgets_easier'
  s.version          = '0.0.1'
  s.summary          = 'Widgets Easier aims to make development faster, simpler, and more efficient, turning development into a pleasant experience.'
  s.description      = <<-DESC
Widgets Easier aims to make development faster, simpler, and more efficient, turning development into a pleasant experience.
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }

  s.source           = { :path => '.' }
  s.source_files     = 'Classes/**/*'
  s.dependency 'FlutterMacOS'

  s.platform = :osx, '10.11'
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES' }
  s.swift_version = '5.0'
end
