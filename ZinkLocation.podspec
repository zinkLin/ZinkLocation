Pod::Spec.new do |s|
s.name = 'ZinkAlertActionSheet'
s.version = '1.0.0'
s.license = 'MIT'
s.summary = 'UINavigation Helper'
s.homepage = 'https://github.com/zinkLin'
s.authors = { 'Zink' => '418175138@qq.com' }
s.source = { :git => "https://github.com/zinkLin/ZinkAlertActionSheet", :tag => "1.0.0"}
s.requires_arc = true
s.ios.deployment_target = '7.0'
s.source_files = "ZinkAlertActionSheet/*"
s.dependency = "ZinkAlertActionSheet"
end