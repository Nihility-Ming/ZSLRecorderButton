//
//  ZSLRecordFileModel.h
//  ZSLRecorderButton
//
//  Created by 找塑料 on 16/3/4.
//  Copyright © 2016年 Nihility-Ming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZSLRecordFileModel : NSObject

/** 原始录音文件的Data，未转.amr时候的格式(也就是.caf) */
@property (strong, nonatomic, readonly, nullable) NSData *fileData;

/** 已经转了.amr的NSData */
@property (strong, nonatomic, readonly, nullable) NSData *amrFileData;

/** 文件名 */
@property (strong, nonatomic, readonly, nullable) NSString *fileName;

/** 录音文件的文件URL */
@property (strong, nonatomic, readonly, nullable) NSURL *fileURL;

/** 持续时间 */
@property (assign, nonatomic, readonly) NSTimeInterval duration;

/** 创建Model的类方法 */
+ (_Nonnull instancetype)modelWithURL:(NSURL * _Nonnull)URL;

@end
