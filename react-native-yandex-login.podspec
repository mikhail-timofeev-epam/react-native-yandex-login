require 'json'

package = JSON.parse(File.read(File.join(__dir__, 'package.json')))

Pod::Spec.new do |s|
  s.name         = package['name']
  s.version      = package['version']
  s.summary      = package['title']
  s.description  = package['description']
  s.author       = package['author']
  s.homepage     = package['homepage']

  s.license      = { :type => 'Apache-2.0', :file => 'LICENSE' }
  s.source       = { :git => 'https://github.com/vanyasem/react-native-yandex-login.git', :tag => "#{s.version}" }

  s.platform     = :ios, '9.0'
  s.source_files = "ios/**/*.{h,c,m,swift}"
  s.requires_arc = true

  s.dependency 'React'
end
