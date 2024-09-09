Pod::Spec.new do |s|
  s.name         = 'LibrarySDK'
  s.version      = '1.0.0'
  s.summary      = 'A simple SDK for sending strings to a backend.'
  
  s.description  = <<-DESC
                   LibrarySDK Swift library for sending string data to a backend API.
                   DESC

  s.homepage     = 'https://example.com/LibrarySDK'
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author       = { 'Your Name' => 'your.email@example.com' }

  # Campo source é obrigatório, mesmo para pods locais
  s.source       = { :git => 'https://example.com/repo.git', :tag => s.version.to_s }

  # Indique o local do framework binário
  s.vendored_frameworks = 'LibrarySDK.framework'
  
  s.platform     = :ios, '13.0'
  s.ios.deployment_target = '13.0'
  
  s.dependency 'Alamofire'
end
