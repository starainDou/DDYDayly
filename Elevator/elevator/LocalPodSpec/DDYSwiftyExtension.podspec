Pod::Spec.new do |s|
  s.name = "DDYSwiftyExtension"
  s.version = "1.0.0"
  s.summary = "swift 扩展"
  s.homepage = "https://github.com/RainOpen/DDYSwiftyExtension"
  s.license = "MIT"
  s.author = {"Rain" => "634778311@qq.com"}
  s.source = {:git => "", :tag => "#{s.version}"}
  s.platform = :ios, "13.0"
  s.frameworks = "UIKit"
  s.requires_arc = true
  s.source_files = 'DDYSwiftyExtension/*.{swift,h,m}'
end
