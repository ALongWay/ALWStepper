Pod::Spec.new do |s|
  s.name             = 'ALWStepper'
  s.version          = '0.1.0'
  s.summary          = 'Configurable and editable stepper.'
  s.homepage         = 'https://github.com/ALongWay/ALWStepper'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'lisong' => '370381830@qq.com' }
  s.source           = { :git => 'https://github.com/ALongWay/ALWStepper.git', :tag => s.version.to_s }

  s.ios.deployment_target = '7.0'

  s.source_files = 'ALWStepper/Classes/**/*'
  
  s.resource_bundles = {
     'ALWStepperResource' => ['ALWStepper/Assets/*.bundle']
  }

end
