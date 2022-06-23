
#import "RCTAgoraRteChatView.h"
#import "ChatView.h"
#import <WHToast/WHToast.h>
#import "AGResourceManager.h"

@interface RCTAgoraRteChatView()<ChatManagerDelegate, ChatViewDelegate>
@property (nonatomic, strong) ChatView* chatView;
@property (nonatomic, strong) ChatManager* chatManager;
@end

@implementation RCTAgoraRteChatView

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.chatManager logout];
}

- (id)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor yellowColor];
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.chatView.frame = self.bounds;
}

//appKey/nickname/chatRoomId/roomUuid/userName
- (void)setChatInfo:(NSDictionary *)chatInfo {
    NSLog(@"setRoomInfo: %@", chatInfo);
    
    ChatUserConfig* user = [[ChatUserConfig alloc] init];

//    user.avatarurl = nil;
    user.username = [chatInfo valueForKey:@"userName"];
    user.nickname = [chatInfo valueForKey:@"nickName"];
    user.roomUuid = [chatInfo valueForKey:@"roomUuid"];
    user.role = 2;

    NSString *appKey = [chatInfo valueForKey:@"appKey"];
    NSString *password = user.username;
    NSString *chatRoomId = [chatInfo valueForKey:@"chatRoomId"];

    [self.chatManager logout];
    self.chatManager = [[ChatManager alloc] initWithUserConfig:user
                                                        appKey:appKey
                                                      password:password
                                                    chatRoomId:chatRoomId];
    self.chatManager.delegate = self;
    if (self.chatView == nil) {
        self.chatView = [[ChatView alloc] initWithFrame:self.bounds];
        self.chatView.chatManager = self.chatManager;
        self.chatView.delegate = self;
        [self addSubview:self.chatView];
    }
    [self.chatManager launch];
}


- (void)sendMessage:(NSString*)message {
    NSLog(@"sendMessage: %@", message);
}


- (void)recallMsg:(NSString*)msgId
{
}

#pragma mark - ChatManagerDelegate
- (void)chatMessageDidReceive
{
    __weak typeof(self) weakself = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        NSArray<EMMessage*>* array = [weakself.chatManager msgArray];
        [self.chatView updateMsgs:array];
//        if(array.count > 0) {
//            [self sendMessage:@"chatWidgetDidReceiveMessage"];
//            if([self.containView isHidden]) {
//                // 最小化了
//                self.badgeView.hidden = NO;
//            }
//            if(self.chatTopView.currentTab != 0) {
//                // 显示红点
//                self.chatTopView.isShowRedNotice = YES;
//            }
//        }
    });
    
}

- (void)chatMessageDidSend:(EMMessage*)aInfo
{
    [self.chatView updateMsgs:@[aInfo]];
}

- (void)exceptionDidOccur:(NSString*)aErrorDescription
{
    [WHToast showErrorWithMessage:aErrorDescription duration:2 finishHandler:^{
            
    }];
}

- (void)mutedStateDidChanged
{
//    self.chatView.chatBar.isAllMuted = self.chatManager.isAllMuted;
//    self.chatView.chatBar.isMuted = self.chatManager.isMuted;
}

- (void)chatMessageDidRecall:(NSString*)aMessageId
{
    if(aMessageId.length > 0) {
        [self recallMsg:aMessageId];
    }
}

- (void)roomStateDidChanged:(ChatRoomState)aState
{
    dispatch_async(dispatch_get_main_queue(), ^{
        switch (aState) {
            case ChatRoomStateLogin:
                
                break;
            case ChatRoomStateLoginFailed:
                [WHToast showErrorWithMessage:[@"ChatLoginFaild" ag_localized] duration:2 finishHandler:^{
                        
                }];
                break;
            case ChatRoomStateLogined:
                
                break;
            case ChatRoomStateJoining:
                
                break;
            case ChatRoomStateJoined:
                
                break;
            case ChatRoomStateJoinFail:
                [WHToast showErrorWithMessage:[@"ChatJoinFaild" ag_localized] duration:2 finishHandler:^{
                        
                }];
                break;
            default:
                break;
        }
    });
}

- (void)announcementDidChanged:(NSString *)aAnnouncement isFirst:(BOOL)aIsFirst
{
//    self.chatView.announcement = aAnnouncement;
//    self.announcementView.announcement = aAnnouncement;
//    if(!aIsFirst) {
//        if([self.containView isHidden]) {
//            // 最小化了
//            self.badgeView.hidden = NO;
//        }
//        if(self.chatTopView.currentTab != 1) {
//            // 显示红点
//            self.chatTopView.isShowAnnouncementRedNotice = YES;
//        }
//    }
}


#pragma mark - ChatViewDelegate
- (void)chatViewDidClickAnnouncement
{
//    self.chatTopView.currentTab = 1;
}

- (void)msgWillSend:(NSString *)aMsgText
{
    [self.chatManager sendCommonTextMsg:aMsgText];
}
@end
  


