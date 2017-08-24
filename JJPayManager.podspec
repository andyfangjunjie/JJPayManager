Pod::Spec.new do |s|
s.name = 'JJPayManager'
s.version = '0.0.1'
s.platform = :ios, '7.0'
s.summary = '一个非常好用的支付管理类（支付宝、微信支付），集成简单！'
s.homepage = 'https://github.com/andyfangjunjie/JJPayManager'
s.license = 'MIT'
s.author = { 'andyfangjunjie' => 'andyfangjunjie@163.com' }
s.source = {:git => 'https://github.com/andyfangjunjie/JJPayManager.git', :tag => s.version}
s.source_files = 'JJPayManager/**/*.{h,m}'
s.requires_arc = true
s.framework  = 'UIKit'
s.dependency 'AlipaySDK-2.0'
s.dependency 'WechatOpenSDK'
end