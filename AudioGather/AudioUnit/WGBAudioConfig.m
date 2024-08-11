//
//  WGBAudioConfig.m

//
//  Created by 王贵彬 on 2023/5/10.
//

#import "WGBAudioConfig.h"

@implementation WGBAudioConfig

+ (instancetype)defaultConfig {
    WGBAudioConfig *config = [[self alloc] init];
    config.channels = 2;
    config.sampleRate = 44100;
    config.bitDepth = 16;
    return config;
}

@end
