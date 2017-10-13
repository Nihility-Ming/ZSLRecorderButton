//
//  ZSLRecorderButton.h
//  ZSLRecorderButton
//
//  Created by 找塑料 on 16/3/4.
//  Copyright © 2016年 Nihility-Ming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZSLRecorderView.h"
#import "ZSLRecordFileModel.h"

NS_ASSUME_NONNULL_BEGIN

// 调试请用真机，谢谢！，已经通过iPhone 4（没有S）、iPhone 6 plus测试

/** ZSL提供的录音按钮，支持XIB */
@interface ZSLRecorderButton : UIButton

/**  播放机播放状态 */
typedef NS_ENUM(NSUInteger, ZSLRecorderButtonPlayerStatus) {
    /** 播放中 */
    ZSLRecorderButtonPlayerStatusPlaying = 0,
    /** 播放完成 */
    ZSLRecorderButtonPlayerStatusPlayComplete= 1,
    /** 错误 */
    ZSLRecorderButtonPlayerStatusError = 2,
};

// 初始化方法（也可以拖SB/XIB）
- (instancetype)initWithFrame:(CGRect)frame;

/** 录音的界面 */
@property (strong, nonatomic, readonly) ZSLRecorderView *recorderView;

/** 最小的录音时间，默认是2秒，短于这个时间，则回调 -recordTimeIsTooShortCallback */
@property (assign, nonatomic) NSTimeInterval minimumSecond;

/** 录音周期内，是否需要显示UIAlertView的提示，模式是YES */
@property (assign, nonatomic, getter=isCanShowMsgAlertView) BOOL canShowMsgAlertView;

/** 播放机状态回调，当调用 - playNewly时触发 */
- (void)setPlayStatusCallback:(void (^ _Nullable)(ZSLRecorderButton * _Nonnull button, ZSLRecorderButtonPlayerStatus playStatus, NSData * _Nonnull playData))playStatusCallback;

/** 已经录音完毕的回调 */
- (void)setDidCompleteRecordedCallback:(void (^)(ZSLRecorderButton * _Nonnull button, ZSLRecordFileModel * _Nonnull recordFileModel))didCompleteRecordedCallback;

/** 已经取消录音的回调 */
- (void)setDidCancelRecordedCallback:(void (^ _Nullable)(ZSLRecorderButton * _Nonnull button))didCancelRecordedCallback;

/** 录音时间过短，录音失败的回调 */
- (void)setRecordTimeIsTooShortCallback:(void (^ _Nullable)(ZSLRecorderButton * _Nonnull button, NSTimeInterval duration))recordTimeIsTooShortCallback;

/** 播放最近录的那段录音 */
- (void)playNewly;

@end

NS_ASSUME_NONNULL_END
