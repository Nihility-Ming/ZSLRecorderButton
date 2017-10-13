//
//  ZSLwaveLayer.h
//  ZSLwaveViewDemo
//
//  Created by DingXiao on 15/8/3.
//  Copyright (c) 2015年 Dennis. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

@protocol ZSLwaveLayerDelegate <NSObject>

@optional

- (void)waveLayerDidFinishAnimation;

@end

@interface ZSLwaveLayer : CAShapeLayer

@property (nonatomic, weak) id<ZSLwaveLayerDelegate> waveDelegate;

@property (nonatomic, assign) CFTimeInterval animationDuration;
@property (nonatomic, strong) UIBezierPath *toPath; 
@property (nonatomic, strong) UIBezierPath *fromPath;

- (void)startAnimation;
@end
