Pod::Spec.new do |s|
  s.name             = 'window_title_bar'
  s.version          = '0.0.1'
  s.summary          = 'Local desktop plugin for custom title bar'
  s.description      = <<-DESC
Local desktop plugin for custom title bar behavior on macOS.
                       DESC
  s.homepage         = 'https://example.com'
  s.license          = { :type => 'MIT' }
  s.author           = { 'MeloTrip' => 'maintainers@melotrip.local' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'FlutterMacOS'
  s.platform = :osx, '10.14'
  s.swift_version = '5.0'
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES' }
end
