//
//  ZSLRecordFileModel.m
//  ZSLRecorderButton
//
//  Created by 找塑料 on 16/3/4.
//  Copyright © 2016年 Nihility-Ming. All rights reserved.
//

#import "ZSLRecordFileModel.h"
#import "RecordAudio.h"

@interface ZSLRecordFileModel()

@property (strong, nonatomic) NSData *fileData;
@property (strong, nonatomic) NSString *fileName;
@property (strong, nonatomic) NSURL *fileURL;
@property (assign, nonatomic) NSTimeInterval duration;
@property (strong, nonatomic) NSData *amrFileData;

@end

@implementation ZSLRecordFileModel

+ (instancetype)modelWithURL:(NSURL *)URL
{
    ZSLRecordFileModel *model = [[ZSLRecordFileModel alloc] init];
    model.fileURL = URL;
    model.fileData = [NSData dataWithContentsOfURL:URL];
    model.amrFileData = EncodeWAVEToAMR(model.fileData, 1, 16);
    model.fileName = [[URL absoluteString] lastPathComponent];
    model.duration = [RecordAudio getAudioTime:model.fileData];
    return model;
}

@end
