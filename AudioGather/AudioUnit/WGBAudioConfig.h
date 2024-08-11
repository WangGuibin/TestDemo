//
//  WGBAudioConfig.h

//
//  Created by 王贵彬 on 2023/5/10.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WGBAudioConfig : NSObject

+ (instancetype)defaultConfig ;

@property (nonatomic, assign) NSUInteger channels; // 声道数，default: 2。
@property (nonatomic, assign) NSUInteger sampleRate; // 采样率，default: 44100。
@property (nonatomic, assign) NSUInteger bitDepth; // 量化位深，default: 16。


@end

NS_ASSUME_NONNULL_END
