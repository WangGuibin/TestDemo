//
//  WGBSaveH264VideoFileTool.m
//
//  Created by 王贵彬  on 2023/5/6.
//

#import "WGBSaveH264VideoFileTool.h"

@implementation WGBVideoPacketExtraData
@end


@interface WGBSaveH264VideoFileTool ()

@property (nonatomic, strong) NSFileHandle *fileHandle;

@end

@implementation WGBSaveH264VideoFileTool


- (instancetype)initWithFileName:(NSString *)fileName
{
    self = [super init];
    if (self) {
        NSString *videoPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:fileName];
        [[NSFileManager defaultManager] removeItemAtPath:videoPath error:nil];
        [[NSFileManager defaultManager] createFileAtPath:videoPath contents:nil attributes:nil];
        _fileHandle = [NSFileHandle fileHandleForWritingAtPath:videoPath];
    }
    return self;
}


- (WGBVideoPacketExtraData *)getPacketExtraData:(CMSampleBufferRef)sampleBuffer {
    // 从 CMSampleBuffer 中获取 extra data。
    if (!sampleBuffer) {
        return nil;
    }
    
    // 获取编码类型。
    CMVideoCodecType codecType = CMVideoFormatDescriptionGetCodecType(CMSampleBufferGetFormatDescription(sampleBuffer));
    
    WGBVideoPacketExtraData *extraData = nil;
    if (codecType == kCMVideoCodecType_H264) {
        // 获取 H.264 的 extra data：sps、pps。
        CMFormatDescriptionRef format = CMSampleBufferGetFormatDescription(sampleBuffer);
        size_t sparameterSetSize, sparameterSetCount;
        const uint8_t *sparameterSet;
        OSStatus statusCode = CMVideoFormatDescriptionGetH264ParameterSetAtIndex(format, 0, &sparameterSet, &sparameterSetSize, &sparameterSetCount, 0);
        if (statusCode == noErr) {
            size_t pparameterSetSize, pparameterSetCount;
            const uint8_t *pparameterSet;
            OSStatus statusCode = CMVideoFormatDescriptionGetH264ParameterSetAtIndex(format, 1, &pparameterSet, &pparameterSetSize, &pparameterSetCount, 0);
            if (statusCode == noErr) {
                extraData = [[WGBVideoPacketExtraData alloc] init];
                extraData.sps = [NSData dataWithBytes:sparameterSet length:sparameterSetSize];
                extraData.pps = [NSData dataWithBytes:pparameterSet length:pparameterSetSize];
            }
        }
    } else if (codecType == kCMVideoCodecType_HEVC) {
        // 获取 H.265 的 extra data：vps、sps、pps。
        CMFormatDescriptionRef format = CMSampleBufferGetFormatDescription(sampleBuffer);
        size_t vparameterSetSize, vparameterSetCount;
        const uint8_t *vparameterSet;
        if (@available(iOS 11.0, *)) {
            OSStatus statusCode = CMVideoFormatDescriptionGetHEVCParameterSetAtIndex(format, 0, &vparameterSet, &vparameterSetSize, &vparameterSetCount, 0);
            if (statusCode == noErr) {
                size_t sparameterSetSize, sparameterSetCount;
                const uint8_t *sparameterSet;
                OSStatus statusCode = CMVideoFormatDescriptionGetHEVCParameterSetAtIndex(format, 1, &sparameterSet, &sparameterSetSize, &sparameterSetCount, 0);
                if (statusCode == noErr) {
                    size_t pparameterSetSize, pparameterSetCount;
                    const uint8_t *pparameterSet;
                    OSStatus statusCode = CMVideoFormatDescriptionGetHEVCParameterSetAtIndex(format, 2, &pparameterSet, &pparameterSetSize, &pparameterSetCount, 0);
                    if (statusCode == noErr) {
                        extraData = [[WGBVideoPacketExtraData alloc] init];
                        extraData.vps = [NSData dataWithBytes:vparameterSet length:vparameterSetSize];
                        extraData.sps = [NSData dataWithBytes:sparameterSet length:sparameterSetSize];
                        extraData.pps = [NSData dataWithBytes:pparameterSet length:pparameterSetSize];
                    }
                }
            }
        } else {
            // 其他编码格式。
        }
    }
    
    return extraData;
}

- (BOOL)isKeyFrame:(CMSampleBufferRef)sampleBuffer {
    CFArrayRef array = CMSampleBufferGetSampleAttachmentsArray(sampleBuffer, true);
    if (!array) {
        return NO;
    }
    
    CFDictionaryRef dic = (CFDictionaryRef)CFArrayGetValueAtIndex(array, 0);
    if (!dic) {
        return NO;
    }
    
    // 检测 sampleBuffer 是否是关键帧。
    BOOL keyframe = !CFDictionaryContainsKey(dic, kCMSampleAttachmentKey_NotSync);
    
    return keyframe;
}

- (void)saveSampleBuffer:(CMSampleBufferRef)sampleBuffer {
    // 将编码数据存储为文件。
    // iOS 的 VideoToolbox 编码和解码只支持 AVCC/HVCC 的码流格式。但是 Android 的 MediaCodec 只支持 AnnexB 的码流格式。这里我们做一下两种格式的转换示范，将 AVCC/HVCC 格式的码流转换为 AnnexB 再存储。
    // 1、AVCC/HVCC 码流格式：[extradata]|[length][NALU]|[length][NALU]|...
    // VPS、SPS、PPS 不用 NALU 来存储，而是存储在 extradata 中；每个 NALU 前有个 length 字段表示这个 NALU 的长度（不包含 length 字段），length 字段通常是 4 字节。
    // 2、AnnexB 码流格式：[startcode][NALU]|[startcode][NALU]|...
    // 每个 NAL 前要添加起始码：0x00000001；VPS、SPS、PPS 也都用这样的 NALU 来存储，一般在码流最前面。
    if (sampleBuffer) {
        NSMutableData *resultData = [NSMutableData new];
        uint8_t nalPartition[] = {0x00, 0x00, 0x00, 0x01};
        
        // 关键帧前添加 vps（H.265)、sps、pps。这里要注意顺序别乱了。
        if ([self isKeyFrame:sampleBuffer]) {
            WGBVideoPacketExtraData *extraData = [self getPacketExtraData:sampleBuffer];
            if (extraData.vps) {
                [resultData appendBytes:nalPartition length:4];
                [resultData appendData:extraData.vps];
            }
            [resultData appendBytes:nalPartition length:4];
            [resultData appendData:extraData.sps];
            [resultData appendBytes:nalPartition length:4];
            [resultData appendData:extraData.pps];
        }
        
        // 获取编码数据。这里的数据是 AVCC/HVCC 格式的。
        CMBlockBufferRef dataBuffer = CMSampleBufferGetDataBuffer(sampleBuffer);
        size_t length, totalLength;
        char *dataPointer;
        OSStatus statusCodeRet = CMBlockBufferGetDataPointer(dataBuffer, 0, &length, &totalLength, &dataPointer);
        if (statusCodeRet == noErr) {
            size_t bufferOffset = 0;
            static const int NALULengthHeaderLength = 4;
            // 拷贝编码数据。
            while (bufferOffset < totalLength - NALULengthHeaderLength) {
                // 通过 length 字段获取当前这个 NALU 的长度。
                uint32_t NALUnitLength = 0;
                memcpy(&NALUnitLength, dataPointer + bufferOffset, NALULengthHeaderLength);
                NALUnitLength = CFSwapInt32BigToHost(NALUnitLength);
                
                // 拷贝 AnnexB 起始码字节。
                [resultData appendData:[NSData dataWithBytes:nalPartition length:4]];
                // 拷贝这个 NALU 的字节。
                [resultData appendData:[NSData dataWithBytes:(dataPointer + bufferOffset + NALULengthHeaderLength) length:NALUnitLength]];
                
                // 步进。
                bufferOffset += NALULengthHeaderLength + NALUnitLength;
            }
        }
        
        [self.fileHandle writeData:resultData];
    }
}

@end
