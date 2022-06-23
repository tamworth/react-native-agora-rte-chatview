
Pod::Spec.new do |s|
  s.name         = "RNAgoraRteChatview"
  s.version      = "1.0.0"
  s.summary      = "RNAgoraRteChatview"
  s.description  = <<-DESC
                  RNAgoraRteChatview
                   DESC
  s.homepage     = "https://github.com/author/RNAgoraRteChatview.git"
  s.license      = "MIT"
  # s.license      = { :type => "MIT", :file => "FILE_LICENSE" }
  s.author             = { "author" => "author@domain.cn" }
  s.platform     = :ios, "7.0"
  s.source       = { :git => "https://github.com/author/RNAgoraRteChatview.git", :tag => "master" }
  s.source_files  = "**/*.{h,m}"
  
  s.resource = "ChatWidget/AgoraRteChat.bundle"

  s.dependency "React"
  s.dependency "AgoraUIBaseViews"
  s.dependency "HyphenateChat", "~>3.8.6"
  s.dependency "Masonry"
  s.dependency "AgoraUIBaseViews"
  s.dependency "SDWebImage", "~>5.12.0"
  s.dependency "WHToast", "~>0.0.7"
  # s.dependency "AgoraWidgets"

end

  
