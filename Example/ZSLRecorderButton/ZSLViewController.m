//
//  ZSLViewController.m
//  ZSLRecorderButton
//
//  Created by Nihility-Ming on 07/08/2016.
//  Copyright (c) 2016 Nihility-Ming. All rights reserved.
//

#import "ZSLViewController.h"
#import <ZSLRecorderButton.h>

@interface ZSLViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;

// ZSLRecorderButton是UIButton的子类，直接拖SB。也可以
@property (weak, nonatomic) IBOutlet ZSLRecorderButton *recorderButton;

@end

@implementation ZSLViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.github.com/"]];
    [_webView loadRequest:request];
    
    //    self.recorderButton.canShowMsgAlertView = NO; // 异常情况是否显示提示框（UIAlertView），默认是YES
    //    self.recorderButton.recorderView.fullscreen = YES; // 录音视图是否全屏，默认是NO
    //    self.recorderButton.minimumSecond = 10.0f; // 最短录音时间，默认2.0秒
    
    // 本次录音被放弃
    [self.recorderButton setDidCancelRecordedCallback:^(ZSLRecorderButton * _Nonnull button) {
        
        NSLog(@"本次录音已经被取消了！");
        
    }];
    
    // 已经成功完成录音
    [self.recorderButton setDidCompleteRecordedCallback:^(ZSLRecorderButton * _Nonnull button, ZSLRecordFileModel * _Nonnull recordFileModel){
        
        NSLog(@"本次录音成功，正在播放...");
        NSLog(@"录音持续时间：%.2f", recordFileModel.duration);
        NSLog(@"录音文件存放地址：%@", recordFileModel.fileURL);
        NSLog(@"文件名：%@", recordFileModel.fileName);
        NSLog(@"文件大小%.2f KB", [recordFileModel.amrFileData length] / 1024.0f);
        
        // 播放最近的录音文件
        [button playNewly];
        
    }];
    
    
    
    // 播放器（非录音器）状态回调
    [self.recorderButton setPlayStatusCallback:^(ZSLRecorderButton * _Nonnull button, ZSLRecorderButtonPlayerStatus playStatus, NSData * _Nonnull playData) {
        
        switch (playStatus) {
            case ZSLRecorderButtonPlayerStatusPlaying:
                NSLog(@"正在播放...");
                break;
                
            case ZSLRecorderButtonPlayerStatusPlayComplete:
                NSLog(@"播放完成...");
                break;
                
            case ZSLRecorderButtonPlayerStatusError:
                NSLog(@"播放失败...");
                break;
                
            default:
                break;
        }
        
        
    }];
    
    // 录音时间太短，录音失败回调
    [self.recorderButton setRecordTimeIsTooShortCallback:^(ZSLRecorderButton * _Nonnull button, NSTimeInterval duration) {
        
        NSLog(@"时间太短了，只录了%.2f秒啊！录音失败~", duration);
        
    }];
    
}


@end
