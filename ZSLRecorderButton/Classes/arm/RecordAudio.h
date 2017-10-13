//
//  RecordAudio.h
//  JuuJuu
//
//  Created by xiaoguang huang on 11-12-19.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//
#

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreAudio/CoreAudioTypes.h>
#import "amrFileCodec.h"

@protocol RecordAudioDelegate <NSObject>
//0 播放 1 播放完成 2出错
-(void)RecordStatus:(int)status;
@end

@interface RecordAudio : NSObject <AVAudioRecorderDelegate, AVAudioPlayerDelegate>

@property (nonatomic,assign)id<RecordAudioDelegate> delegate;

- (NSURL *) stopRecord ;
- (void) startRecord;

-(void) play:(NSData*) data;
-(void) stopPlay;
+(NSTimeInterval) getAudioTime:(NSData *) data;

+ (void)checkCanRecord:(void(^)(BOOL can))callback;

@end
