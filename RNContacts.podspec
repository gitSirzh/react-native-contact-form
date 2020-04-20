require 'json'

package = JSON.parse(File.read(File.join(__dir__, 'package.json')))

Pod::Spec.new do |s|
  s.name         = "RNContacts"
  s.version      = package['version']
  s.summary      = package['description']
  s.license      = package['license']

  s.authors      = package['author']
  s.homepage     = package['repository']['url']
  s.platform     = :ios, "7.0"
  s.ios.deployment_target = '7.0'
  s.tvos.deployment_target = '7.0'

  s.source       = { :git => "https://github.com/gitSirzh/react-native-contact-form.git", :tag => "v#{s.version}" }
  s.source_files  = "ios/**/*.{h,m}"

  s.dependency "React"

end


