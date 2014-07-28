
Pod::Spec.new do |s|
  s.name         = "ActiveRecord"
  s.version      = "1.2.1"
  s.summary      = "A lightweight Active Record implementation for Core Data."
  s.homepage     = "https://github.com/michalkonturek/ActiveRecord"
  s.license      = 'MIT'

  s.author       = { 
    "Michal Konturek" => "michal.konturek@gmail.com" 
  }

  s.ios.deployment_target = '7.0'

  s.social_media_url = 'https://twitter.com/michalkonturek'
  s.source       = { 
    :git => "https://github.com/michalkonturek/ActiveRecord.git", 
    :tag => s.version.to_s
  }

  s.source_files = 'Source/**/*.{h,m}'
  s.requires_arc = true
  s.framework  = 'CoreData'
  s.dependency 'MKFoundationKit/Block', '>= 1.0.0'
  s.dependency 'MKFoundationKit/NSNumber', '>= 1.0.0'
  s.dependency 'RubySugar', '>= 1.1.0'
end