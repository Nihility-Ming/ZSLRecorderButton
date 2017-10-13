//
//  ZSLRecorderView.m
//  RecordAndPlayVoice
//
//  Created by 找塑料 on 16/3/2.
//  Copyright © 2016年 liuchunlao. All rights reserved.
//

#import "ZSLRecorderView.h"
#import "ZSLwaveMaker.h"

NSString * const ZSLRecorderViewCancelRecordTipsString = @"手指上滑，取消录音";
NSString * const ZSLRecorderViewWillCancelRecordTipsString = @"松开手指，取消录音";
NSString * const ZSLRecorderViewWaitingTipsString = @"正在处理...";

@interface ZSLRecorderView()
{
    UIWindow *_rootWindow;
}

@property (weak, nonatomic) IBOutlet UIControl *backgroundView;
@property (weak, nonatomic) IBOutlet UIView *boxView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *tipsLabel;

@property (strong, nonatomic) ZSLwaveMaker *waveMarker;


@end

@implementation ZSLRecorderView

+ (instancetype)view
{
    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"ZSLRecorderButton" ofType:@"bundle"];
    ZSLRecorderView *view = [[[NSBundle bundleWithPath:bundlePath] loadNibNamed:@"ZSLRecorderView" owner:nil options:nil] lastObject];
    return view;
}

- (ZSLwaveMaker *)waveMarker
{
    if (!_waveMarker) {
        _waveMarker = [[ZSLwaveMaker alloc] init];
        _waveMarker.animationView = self.backgroundView;
        _waveMarker.spanScale = 3.0f;
        _waveMarker.originRadius = self.imageView.frame.size.width/2.0f;
        _waveMarker.waveColor = [UIColor colorWithRed:0.284 green:0.447 blue:1.000 alpha:0.2];
        _waveMarker.animationDuration = 6.0f;
        
    }
    return _waveMarker;
}

- (void)awakeFromNib
{
    self.active = YES;
    self.fullscreen = NO;
    self.backgroundView.alpha = 0.0f;
    self.tipsString = ZSLRecorderViewCancelRecordTipsString;
    _rootWindow = [self p_window];
}

- (void)setActive:(BOOL)active
{
    _active = active;
    self.imageView.highlighted = !_active;
}

- (void)setTipsString:(NSString *)tipsString
{
    _tipsString = tipsString;
    self.tipsLabel.text = _tipsString;
}

- (void)show
{
    if (!self.superview) {
        [_rootWindow addSubview:self];
        
        if (self.isFullscreenStyle) {
            self.frame = _rootWindow.bounds;
        } else {
            CGFloat widht = _rootWindow.frame.size.width - 40;
            self.frame = CGRectMake(0, 0, widht, widht);
            self.center = _rootWindow.center;
            self.clipsToBounds = YES;
            self.layer.cornerRadius = 20.0f;
        }
        
        
        [self layoutSubviews];
        [self layoutIfNeeded];
        
        CGPoint center =  [self.boxView convertPoint:self.imageView.center toView:self.backgroundView];
        self.waveMarker.waveCenter = center;

    }
    
    [self p_show];
}

- (void)dismiss
{
    [self p_hide];
}

#pragma mark- Private Methos

- (UIWindow *)p_window
{
    NSEnumerator *frontToBackWindows = [UIApplication.sharedApplication.windows reverseObjectEnumerator];
    UIScreen *mainScreen = UIScreen.mainScreen;
    
    for (UIWindow *window in frontToBackWindows) {
        if (window.screen == mainScreen && window.windowLevel == UIWindowLevelNormal) {
            return window;
            break;
        }
    }
    
    return nil;
}

- (void)p_show
{
    self.tipsString = ZSLRecorderViewCancelRecordTipsString;
    [UIView animateWithDuration:0.4 animations:^{
        self.backgroundView.alpha = 1.0f;
    } completion:^(BOOL finished) {
        if (finished) {
            [self.waveMarker spanWaveContinuallyWithTimeInterval:0.8];
        }
    }];
}

- (void)p_hide
{
    [UIView animateWithDuration:0.4 animations:^{
        self.backgroundView.alpha = 0.0f;
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
        }
    }];
    
    [self.waveMarker stopWave];
}

@end
