# data - 2019-7-30 16:22

Pod::Spec.new do |s|
  s.name         = "MJCorePod"
  s.version      = "1.0.0"
  s.summary      = "A collection of iOS Module."
  s.author       = { "xxxxx" => "xxxxx.me" }
  s.homepage     = "xxxxx"
  s.source       = { :git => "http://xxxxx.git", :tag => "#{s.version}" }
  s.platform     = :ios, '13.0'

  s.static_framework = true
  s.requires_arc = true

  s.resources = "Resources/*.bundle"
  s.vendored_libraries = 'Resources/**/*.a'
  s.vendored_frameworks = 'Resources/**/*.framework'
  s.libraries = 'stdc++'

  

  
  
 

  s.prefix_header_contents = <<-EOS
    
    #import <Foundation/Foundation.h>
    #import <Availability.h>
    #import <ReactiveObjC/ReactiveObjC.h>
    #import <Masonry/Masonry.h>
    #import <MJRefresh/MJRefresh.h>
    #import <TXLiteAVSDK_Professional/TXLiteAVSDK.h>
    #import <ImSDK_Plus/ImSDK_Plus.h>
    #import <YYKit.h>

    #import "OffUtil.h"
    #import "ChannelRequest.h"
    #import "GiftTool.h"
    #import "ErrorCode.h"
    #import "ManagerTool.h"
    #import "ViewVoice.h"
    #import "LineManager.h"
    #import "CircleBank.h"
    #import "FamilyMenuCache.h"
    #import "ActionGifts.h"
    #import "VoiceVideo.h"
    
    #import "ActionChatMe.h"
    #import "CoreSocial.h"
    #import "TalkHelper.h"
    #import "HistoryList.h"
    #import "ModelSheet.h"
    #import "SignHelper.h"
    #import "SquareList.h"
    #import "EditorIcon.h"


    #import "DisplayColor.h"
    #import "HouseholdImage.h"

    #import "CellHelper.h"
    #import "Cadre.h"
    #import "ModeConfig.h"
    #import "InfoStatistical.h"
    #import "FamilyNucleusBaseModel.h"
    #import "ChiefResponse.h"
    #import "ViewChannel.h"
    #import "MJCoreLogHeader.h"

#pragma mark - 自定义View
    #import "PtolemaicSystemView.h"
    #import "ChannelView.h"
    #import "ViewControl.h"
    #import "TransfusionView.h"
#pragma mark - 宏定义
    #import "ResMacro.h"
    #import "ModelDef.h"
    #import "AngelCoreGift.h"
    #import "ChannelIconDef.h"
    #import "MJCoreDataTaskConst.h"
    #import "BlueprintView.h"
    #import "FallInPackage.h"
    #import "TipDerangement.h"
    #import "ViewDef.h"


#pragma mark - Category
    #import "UIApplication+View.h"
    #import "NSObject+Clank.h"
    #import "UIDevice+View.h"
    #import "UIView+View.h"
    #import "UIImageView+WebCache.h"
    #import "UIButton+WebCache.h"
    #import "UIImage+View.h"
    #import "UIFont+View.h"
    #import "NSString+View.h"
    #import "NSUserDefaults+Account.h"
    #import "LineManager+Info.h"
    #import <NSObject+YYModel.h>
    #import <NSAttributedString+YYText.h>
    #import "LineManager+WindowNavigation.h"
    #import "LineManager+Crash.h"
    #import "NSObject+View.h"

  EOS

end
