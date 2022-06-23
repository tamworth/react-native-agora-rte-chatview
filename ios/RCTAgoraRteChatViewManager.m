//
//  RCTAgoraRteChatViewManager.m
//  RNAgoraRteChatview
//
//  Created by wushengtao on 2022/6/21.
//  Copyright © 2022 Facebook. All rights reserved.
//

#import "RCTAgoraRteChatViewManager.h"
#import "RCTAgoraRteChatView.h"

@implementation RCTAgoraRteChatViewManager
RCT_EXPORT_MODULE(RCTRteChatView)

- (UIView *)view
{
  return [[RCTAgoraRteChatView alloc] init];
}

RCT_EXPORT_VIEW_PROPERTY(chatInfo, NSDictionary)

@end
