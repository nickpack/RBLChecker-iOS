platform :ios, "5.0"
pod "AFNetworking"
pod "AFIncrementalStore"
pod "PrettyKit"
pod "SVWebViewController"
pod "TSMessages"
pod "GoogleAnalytics-iOS-SDK"
pod "ODRefreshControl"
pod "FontAwesomeKit"
pod "GHUnitIOS"

post_install do | installer |
  require 'fileutils'
  FileUtils.copy('Pods/Pods-Acknowledgements.plist', 'RBLChecker/Settings.bundle/Acknowledgements.plist')
end
