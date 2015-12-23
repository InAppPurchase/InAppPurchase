Pod::Spec.new do |s|
  s.name = 'InAppPurchase'
  s.version = '1.0'
  s.license = 'MIT'
  s.summary = 'InAppPurchase Framework for easy consumables in Swift'
  s.homepage = 'https://github.com/InAppPurchase'
  s.authors = { 'Chris Davis' => 'contact@inapppurchase.com' }
  s.source = { :git => 'https://github.com/InAppPurchase.git', :tag => s.version.to_s }

  s.watchos.deployment_target = '2.0'
  s.ios.deployment_target = '8.4'
  s.osx.deployment_target = '10.9'
  s.tvos.deployment_target = '9.0'
  
  s.requires_arc = 'true'
  s.source_files = 'InAppPurchase/**/*.swift'
  s.resources = "InAppPurchase/**/*.{strings}"
end