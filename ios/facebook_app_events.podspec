Pod::Spec.new do |s|
  s.name             = 'facebook_app_events'
  s.version          = '0.30.3-kids.1'
  s.summary          = 'Flutter plugin for Facebook Analytics and App Events'
  s.description      = <<-DESC
Flutter plugin for Facebook Analytics and App Events
                       DESC
  s.homepage         = 'https://github.com/dkjazz/flutter_facebook_app_events'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Oddbit Team' => 'opensource@oddbit.id' }
  s.source           = { :path => '.' }
  s.source_files = 'facebook_app_events/Sources/facebook_app_events/**/*.{swift}'
  s.static_framework = true
  s.dependency 'Flutter'
  s.swift_version       = '5.9'
  s.ios.deployment_target = '13.0'

  # Kids-app fork: pin the audited native SDK and do not include Audience Network.
  # Excluding the advertising SDK is stronger than loading it only to disable IDFA.
  s.dependency 'FBSDKCoreKit', '18.1.0'
end
