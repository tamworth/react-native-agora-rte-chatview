//
//  AGResourceManager.h
//  RNAgoraRteChatview
//
//  Created by wushengtao on 2022/6/22.
//  Copyright © 2022 Facebook. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AGResourceManager : NSObject

@end

NS_ASSUME_NONNULL_END

@interface UIImage (Agora)
+ (UIImage*)ag_image: (NSString*)name;
@end

@interface NSString (Agora)
- (NSString*)ag_localized;
@end
