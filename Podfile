# Uncomment the next line to define a global platform for your project
platform :ios, '14.0'

target 'Yumn' do
  # Comment the next line if you don't want to use dynamic frameworks
 use_frameworks!
	pod 'BetterSegmentedControl', '~> 2.0'
	# pod 'Firebase/Firestore'

  # Pods for Yumn

post_install do |installer|
installer.pods_project.build_configurations.each do |config|
config.build_settings['LD_RUNPATH_SEARCH_PATHS'] = [
'$(FRAMEWORK_SEARCH_PATHS)',
'"/Applications/Xcode.app/Contents/Developer/Toolchains/Swift_2.3.xctoolchain/usr/lib/swift/iphonesimulator"'
]
end
end

end