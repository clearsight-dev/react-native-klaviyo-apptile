# require 'json'

# package = JSON.parse(File.read(File.join(__dir__, 'package.json')))

# Pod::Spec.new do |s|
#   # s.name         = package['name']
#   s.name         = "react-native-awesome-library"
#   s.version      = package['version']
#   s.summary      = package['description']
#   s.license      = package['license']

#   s.authors      = package['author']
#   s.homepage     = package['homepage']
#   s.platform     = :ios, "12.0"

#   s.source       = { :git => "https://github.com/nikhilyadav06/react-native-awesome-library.git", :tag => "v#{s.version}" }
#   s.source_files  = "ios/**/*.{h,m,swift}"

#   s.dependency 'React'
#   s.dependency "KlaviyoSwift", "2.5.1"
# end

require 'json'

package = JSON.parse(File.read(File.join(__dir__, 'package.json')))

Pod::Spec.new do |s|
  s.name         = "react-native-awesome-library"
  s.version      = package['version']
  s.summary      = package['description']
  s.license      = package['license']
  s.authors      = package['author']
  s.homepage     = package['homepage']
  s.platform     = :ios, "13.0"
  s.requires_arc = true

  s.source       = { :git => "https://github.com/nikhilyadav06/react-native-awesome-library.git", :tag => "v#{s.version}" }
  s.source_files  = "ios/**/*.{h,m,swift}"

  s.dependency "React-Core"
  s.dependency "KlaviyoSwift", "2.5.2"
end
