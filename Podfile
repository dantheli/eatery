use_frameworks!

def shared_pods
  pod 'DiningStack', :git => 'https://github.com/cuappdev/DiningStack.git', :branch => 'lucas/cocoapods'
end

target 'Eatery' do
  platform :ios, '8.0'
  pod 'Analytics/Segmentio'
  shared_pods
end

target 'Today Extension' do
  platform :ios, '8.0'
  shared_pods
end

target 'Eatery Watch App' do
  platform :watchos, '2.0'
  shared_pods
end

target 'Eatery Watch App Extension' do
  platform :watchos, '2.0'
  shared_pods
end