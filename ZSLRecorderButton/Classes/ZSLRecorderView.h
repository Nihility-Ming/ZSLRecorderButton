//
//  ZSLRecorderView.h
//  RecordAndPlayVoice
//
//  Created by 找塑料 on 16/3/2.
//  Copyright © 2016年 liuchunlao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXPORT NSString * const ZSLRecorderViewCancelRecordTipsString;
FOUNDATION_EXPORT NSString * const ZSLRecorderViewWillCancelRecordTipsString;
FOUNDATION_EXPORT NSString * const ZSLRecorderViewWaitingTipsString;

/** 录音视图 */
@interface ZSLRecorderView : UIView

/** 提示的标题 */
@property (strong, nonatomic) NSString *tipsString;

/** 是否激活状态(图片的highlight状态) ，默认是YES */
@property (assign, nonatomic, getter=isActive) BOOL active;

/** 是否全屏显示，模式为NO */
@property (assign, nonatomic, getter=isFullscreenStyle) BOOL fullscreen;

/** 创建视图 */
+ (instancetype)view;

/** 显示 */
- (void)show;

/** 隐藏 */
- (void)dismiss;

@end

NS_ASSUME_NONNULL_END