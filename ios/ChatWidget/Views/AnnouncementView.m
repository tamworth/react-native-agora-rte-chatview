//
//  AnnouncementView.m
//  ChatWidget
//
//  Created by lixiaoming on 2021/7/3.
//

#import "AnnouncementView.h"
#import <Masonry/Masonry.h>
@import AgoraUIBaseViews;
#import "AGResourceManager.h"

@interface NilAnnouncementView ()
@property (nonatomic,strong) UIImageView* nilAnnouncementImageView;
@property (nonatomic,strong) UILabel* nilAnnouncementLable;
@end

@implementation NilAnnouncementView

- (instancetype)init
{
    self = [super init];
    if(self) {
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews
{
    self.nilAnnouncementImageView = [[UIImageView alloc] init];
    self.nilAnnouncementImageView.image = [UIImage ag_image:@"icon_announcement_none"];
    [self addSubview:self.nilAnnouncementImageView];
    [self.nilAnnouncementImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self);
        make.width.equalTo(@80);
        make.height.equalTo(@80);
    }];
    
    self.nilAnnouncementLable = [[UILabel alloc] init];
    self.nilAnnouncementLable.font = [UIFont systemFontOfSize:12];
    self.nilAnnouncementLable.textColor = [UIColor colorWithRed:125/255.0 green:135/255.0 blue:152/255.0 alpha:1.0];
    self.nilAnnouncementLable.text = [@"fcr_hyphenate_im_no_announcement" ag_localized];
    self.nilAnnouncementLable.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.nilAnnouncementLable];
    [self.nilAnnouncementLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self);
        make.centerX.equalTo(self);
        make.height.equalTo(@20);
        make.width.equalTo(self);
    }];
}

@end

@interface AnnouncementView ()
@property (nonatomic,strong) NilAnnouncementView* nilAnnouncementView;
@property (nonatomic,strong) UITextView* announcementText;


@end

@implementation AnnouncementView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self) {
        [self setupSubViews];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setupSubViews
{
    self.backgroundColor = [UIColor whiteColor];
    self.nilAnnouncementView = [[NilAnnouncementView alloc] init];
    [self addSubview:self.nilAnnouncementView];
    [self.nilAnnouncementView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@100);
        make.center.equalTo(self);
    }];
    
    self.announcementText = [[UITextView alloc] init];
    [self.announcementText setEditable:NO];
    [self addSubview:self.announcementText];
    self.announcementText.textColor = [UIColor colorWithRed:25/255.0 green:25/255.0 blue:25/255.0 alpha:1.0];
    self.announcementText.font = [UIFont systemFontOfSize:13];
    //self.announcementText.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
    //[self.announcementText sizeToFit];
    //self.announcementText.numberOfLines = 0;
    self.announcementText.textAlignment = NSTextAlignmentLeft;
    [self.announcementText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(self).with.offset(-14);
        make.center.equalTo(self);
    }];
    
    self.announcement = @"";
}

- (void)setAnnouncement:(NSString *)announcement
{
    _announcement = announcement;
    [self.announcementText setText:announcement];
    self.announcementText.hidden = _announcement.length == 0;
    self.nilAnnouncementView.hidden = _announcement.length > 0;
}

@end
