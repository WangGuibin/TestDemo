//
//  WGBSaveH264VideoFileTool.h
//  Demo
//
//  Created by 王贵彬  on 2023/5/6.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WGBVideoPacketExtraData : NSObject
@property (nonatomic, strong) NSData *sps;
@property (nonatomic, strong) NSData *pps;
@property (nonatomic, strong) NSData *vps;
@end


@interface WGBSaveH264VideoFileTool : NSObject

- (instancetype)initWithFileName:(NSString *)fileName;

//保存为.h264或者.h265
- (void)saveSampleBuffer:(CMSampleBufferRef)sampleBuffer ;


@end

NS_ASSUME_NONNULL_END
