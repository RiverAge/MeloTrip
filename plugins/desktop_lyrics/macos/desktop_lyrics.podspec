Pod::Spec.new do |s|
  s.name             = 'desktop_lyrics'
  s.version          = '0.0.3'
  s.summary          = 'Desktop floating lyrics overlay for Flutter.'
  s.description      = <<-DESC
Desktop floating lyrics overlay for Flutter with karaoke progress and runtime styling.
                       DESC
  s.homepage         = 'https://github.com/587626/desktop_lyrics'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'riverage' => '744816609@qq.com' }

  s.source           = { :path => '.' }
  s.source_files = 'desktop_lyrics/Sources/desktop_lyrics/**/*'

  s.dependency 'FlutterMacOS'

  s.platform = :osx, '10.15'
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES' }
  s.swift_version = '5.0'
end
