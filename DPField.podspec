Pod::Spec.new do |s|
  s.name             = 'DPField'
  s.version          = '1.0.2'
  s.summary          = 'DP field'
  s.description      = 'A set of useful utilities'
  s.homepage         = 'https://github.com/DPLibs/DPField'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Dmitriy Polyakov' => 'dmitriyap11@gmail.com' }
  s.source           = { :git => 'https://github.com/DPLibs/DPField.git', :tag => s.version.to_s }
  s.ios.deployment_target = '11.0'
  s.source_files = 'DPField/**/*'
  s.swift_version = '5.0'
  
  s.dependency 'DPLibrary'
end
