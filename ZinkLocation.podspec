Pod::Spec.new do |s|
s.name = 'ZinkLocation'
s.version = '1.0.2'
s.license = 'MIT'
s.summary = '地理位置信息获取'
s.homepage = 'https://github.com/zinkLin'
s.authors = { 'Zink' => '418175138@qq.com' }
s.source = { :git => "https://github.com/zinkLin/ZinkLocation", :tag => "1.0.2"}
s.requires_arc = true
s.ios.deployment_target = '7.0'
s.source_files = "ZinkLocationHelper/*"
s.dependency 'ZinkAlertActionSheet'
s.dependency 'ZinkManager'
end