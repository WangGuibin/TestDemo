//
//  WGBMuxerConfig.m

//
//  Created by 王贵彬 on 2023/5/10.
//

#import "WGBMuxerConfig.h"

@implementation WGBMuxerConfig


- (instancetype)init {
    self = [super init];
    if (self) {
        _muxerType = WGBMediaAV;
        _preferredTransform = CGAffineTransformIdentity;
    }
    return self;
}


@end
