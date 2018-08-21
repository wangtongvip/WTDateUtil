Pod::Spec.new do |s|
  s.name        = 'WTDateUtil'
  s.version     = '1.0.0'
  s.authors     = { 'wangtong_vip' => 'wangtong_vip@163.com' }
  s.homepage    = 'https://github.com/wangtongvip/WTDateUtil'
  s.summary     = 'NSDate Extensions. Very nice.'
  s.source      = { :git => 'https://github.com/wangtongvip/WTDateUtil.git', :tag => s.version }
  s.license     = { :type => "MIT", :file => "LICENSE" }

  s.platform = :ios, '7.0'
  s.requires_arc = true
  s.source_files = 'DateUtil'
  s.public_header_files = 'DateUtil/*.h'

  s.ios.deployment_target = '7.0'
end
