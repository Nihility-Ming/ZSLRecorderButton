//
//  ZSLRecorderButton.m
//  ZSLRecorderButton
//
//  Created by 找塑料 on 16/3/4.
//  Copyright © 2016年 Nihility-Ming. All rights reserved.
//

#import "ZSLRecorderButton.h"
#import "RecordAudio.h"

static const NSTimeInterval kDefaultMinimumSecond = 2.0f;
static NSString * const kCannotRecordTipsMessage = @"请先设置允许App访问您的麦克风";
static NSString * const kIsSIMULATORTipsMessage = @"模拟器不能使用ZSLRecorderButton，请使用真机调试！";
static NSString * const kTipsTitle = @"温馨提示";
static NSString * const kTipsCancelButtonTitle = @"取消";
static NSString * const kTipsSettingButtonTitle = @"设置";

@interface ZSLRecorderButton() <RecordAudioDelegate, UIAlertViewDelegate>
{
    NSData *_audioFileData;
    NSTimeInterval _startTime;
    NSTimeInterval _endTitme;
}

// block
@property (nonatomic, copy, nullable) void(^playStatusCallback)(ZSLRecorderButton *, ZSLRecorderButtonPlayerStatus, NSData *);
@property (nonatomic, copy, nullable) void(^didCompleteRecordedCallback)(ZSLRecorderButton *, ZSLRecordFileModel *);
@property (nonatomic, copy, nullable) void(^didCancelRecordedCallback)(ZSLRecorderButton *);
@property (nonatomic, copy, nullable) void(^recordTimeIsTooShortCallback)(ZSLRecorderButton *, NSTimeInterval duration);


@property (strong, nonatomic) ZSLRecorderView *recorderView;
@property (strong, nonatomic) RecordAudio *recorder;

@end

@implementation ZSLRecorderButton

- (instancetype)init
{
    return [self initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self p_init];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self p_init];
}

- (void)playNewly
{
    if (_audioFileData) {
        [self.recorder play:_audioFileData];
    }
}

#pragma mark- Property Lazy Load

- (ZSLRecorderView *)recorderView
{
    if (!_recorderView) {
        _recorderView = [ZSLRecorderView view];
        _recorderView.tipsString = ZSLRecorderViewCancelRecordTipsString;
    }
    return _recorderView;
}

- (RecordAudio *)recorder
{
    if (!_recorder) {
        _recorder = [[RecordAudio alloc] init];
        _recorder.delegate = self;
    }
    return _recorder;
}

#pragma mark- Button Methods

- (void)buttonTouchDown:(UIButton *)button
{
            self.recorderView.active = YES;
            [self.recorderView show];
            [self.recorder stopPlay];
            [self.recorder startRecord];
            
            _startTime = [NSDate timeIntervalSinceReferenceDate];
}

- (void)buttonDragEnter:(UIButton *)button
{
    self.recorderView.active = YES;
    self.recorderView.tipsString = ZSLRecorderViewCancelRecordTipsString;
}

- (void)buttonDragExit:(UIButton *)button
{
    self.recorderView.active = NO;
    self.recorderView.tipsString = ZSLRecorderViewWillCancelRecordTipsString;
}

- (void)buttonTouchUpInside:(UIButton *)button
{
    NSURL *URL = [self.recorder stopRecord];

    _endTitme = [NSDate timeIntervalSinceReferenceDate];
    
    self.recorderView.tipsString = ZSLRecorderViewWaitingTipsString;
    if ((_endTitme - _startTime) <= self.minimumSecond) {
        // 提示
        if (self.isCanShowMsgAlertView) {
            NSString *msg = [NSString stringWithFormat:@"录音失败，录音最短时间为%.2f秒", _minimumSecond];
            [[[UIAlertView alloc] initWithTitle:kTipsTitle message:msg delegate:nil cancelButtonTitle:kTipsCancelButtonTitle otherButtonTitles:nil, nil] show];
        }
        // 回调
        if (self.recordTimeIsTooShortCallback) {
            self.recordTimeIsTooShortCallback(self, _endTitme - _startTime);
        }

        [self.recorderView dismiss];
        
        return ;
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        ZSLRecordFileModel *fileModel = [ZSLRecordFileModel modelWithURL:URL];
        _audioFileData = fileModel.amrFileData;
        if (fileModel.duration >= _minimumSecond) {
            if (self.didCompleteRecordedCallback) {
                self.didCompleteRecordedCallback(self, fileModel);
            }
        } else {
            // 提示
            if (self.isCanShowMsgAlertView) {
                NSString *msg = [NSString stringWithFormat:@"录音失败，录音最短时间为%.2f秒", _minimumSecond];
                [[[UIAlertView alloc] initWithTitle:kTipsTitle message:msg delegate:nil cancelButtonTitle:kTipsCancelButtonTitle otherButtonTitles:nil, nil] show];
            }
            // 回调
            if (self.recordTimeIsTooShortCallback) {
                self.recordTimeIsTooShortCallback(self, fileModel.duration);
            }
        }
        
        [self.recorderView dismiss];
        
    });
}

- (void)buttonTouchOutside:(UIButton *)button
{
    [self.recorder stopRecord];
    if (self.didCancelRecordedCallback) {
        self.didCancelRecordedCallback(self);
    }
    
    [self.recorderView dismiss];
}

// 不能录音
- (void)buttonTouchDownButNotRecord:(UIButton *)button
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:kTipsTitle message:kCannotRecordTipsMessage delegate:self cancelButtonTitle:kTipsCancelButtonTitle otherButtonTitles:kTipsSettingButtonTitle, nil];
    alertView.tag = 1001;
    [alertView show];
    self.recorderView.active = NO;
}

// 模拟器不能使用这个库
- (void)buttonTouchDownButIsSIMULATOR:(UIButton *)button
{
    [[[UIAlertView alloc] initWithTitle:kTipsTitle message:kIsSIMULATORTipsMessage delegate:nil cancelButtonTitle:kTipsCancelButtonTitle otherButtonTitles:nil, nil] show];
}

#pragma mark- RecordAudioDelegate
- (void)RecordStatus:(int)status
{
    if (self.playStatusCallback) {
        self.playStatusCallback(self, (NSUInteger)status, _audioFileData);
    }
}

#pragma mark- Private Mothods

- (void)p_init
{
    _canShowMsgAlertView = YES;
    _minimumSecond = kDefaultMinimumSecond;
    
#if TARGET_IPHONE_SIMULATOR
    [self addTarget:self action:@selector(buttonTouchDownButIsSIMULATOR:) forControlEvents:UIControlEventTouchDown];
#else
    [RecordAudio checkCanRecord:^(BOOL can) {
        if (can) {
            [self addTarget:self action:@selector(buttonTouchDown:) forControlEvents:UIControlEventTouchDown];
            [self addTarget:self action:@selector(buttonDragEnter:) forControlEvents:UIControlEventTouchDragEnter];
            [self addTarget:self action:@selector(buttonDragExit:) forControlEvents:UIControlEventTouchDragExit];
            [self addTarget:self action:@selector(buttonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
            [self addTarget:self action:@selector(buttonTouchOutside:) forControlEvents:UIControlEventTouchUpOutside];
        } else {
            [self addTarget:self action:@selector(buttonTouchDownButNotRecord:) forControlEvents:UIControlEventTouchDown];
        }
    }];
#endif
}

#pragma UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if ((alertView.tag == 1001) && (buttonIndex != [alertView cancelButtonIndex])) {
        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if([[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:url];
        }
    }
}

@end
