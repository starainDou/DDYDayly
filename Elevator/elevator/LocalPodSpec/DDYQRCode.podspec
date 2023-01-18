Pod::Spec.new do |ddyspec|
    ddyspec.name         = 'DDYQRCode'
    ddyspec.version      = '1.0.0'
    ddyspec.summary      = '二维码/条形码生成'
    ddyspec.homepage     = 'https://github.com/RainOpen/DDYQRCode'
    ddyspec.license      = 'MIT'
    ddyspec.authors      = {'Rain' => '634778311@qq.com'}
    ddyspec.platform     = :ios, '13.0'
    ddyspec.source       = {:git => '', :tag => ddyspec.version}
    ddyspec.source_files = 'DDYQRCode/*.{swift,h,m}'
    ddyspec.resource     = 'DDYQRCode/DDYQRCode.bundle'
end