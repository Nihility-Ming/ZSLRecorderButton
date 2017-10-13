#
# Be sure to run `pod lib lint ZSLRecorderButton.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'ZSLRecorderButton'
  s.version          = '0.1.0'
  s.summary          = 'A short description of ZSLRecorderButton.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/<GITHUB_USERNAME>/ZSLRecorderButton'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Nihility-Ming' => 'biweiming@zhaosuliao.com' }
  s.source           = { :git => 'https://github.com/<GITHUB_USERNAME>/ZSLRecorderButton.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'


  s.ios.deployment_target = '7.0'
  s.xcconfig = {'ENABLE_BITCODE' => 'No'}
  s.requires_arc = false
  s.source_files = 'ZSLRecorderButton/Classes/**/*.{h,m}'
  s.resource_bundles = {
      'ZSLRecorderButton' => ['ZSLRecorderButton/Classes/*.xib', 'ZSLRecorderButton/Assets/*.png']
  }
  s.vendored_libraries = "ZSLRecorderButton/Classes/arm/**/*.a"
  s.requires_arc = 'ZSLRecorderButton/Classes/*.{h,m}'

end
