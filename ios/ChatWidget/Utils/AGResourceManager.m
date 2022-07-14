//
//  AGResourceManager.m
//  RNAgoraRteChatview
//
//  Created by wushengtao on 2022/6/22.
//  Copyright © 2022 Facebook. All rights reserved.
//

#import "AGResourceManager.h"

@implementation AGResourceManager
+ (NSBundle *) ChatBundle {
    static dispatch_once_t onceToken;
    static NSBundle * bundle = nil;
    dispatch_once(&onceToken, ^{
        bundle = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"AgoraRteChat" ofType:@"bundle"]];
    });
    return bundle;
}
@end

@implementation UIImage (Agora)
+ (UIImage*)ag_image: (NSString*)name {
    NSString* folderPath = [[AGResourceManager ChatBundle] resourcePath];
    NSString* imagePath = [NSString stringWithFormat:@"%@/image/%@.png", folderPath, name];
    UIImage* image = [UIImage imageWithContentsOfFile:imagePath];
    if(image == nil) {
        NSLog(@"ag_image: %@ not found", name);
    }
    return image;
}
@end

@implementation NSString (Agora)

- (NSString*)ag_localized {
    NSString* bundlePath = [[AGResourceManager ChatBundle] pathForResource:@"zh-Hans"ofType:@"lproj"];
    return [[NSBundle bundleWithPath:bundlePath] localizedStringForKey:self value:@""table:nil];
//    return NSLocalizedStringFromTableInBundle(self, nil, [AGResourceManager ChatBundle], @"");
}
@end
