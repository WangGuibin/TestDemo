//
//  WGBDemuxerConfig.m

//
//  Created by 王贵彬 on 2023/5/10.
//

#import "WGBDemuxerConfig.h"

@implementation WGBDemuxerConfig

- (instancetype)init {
    self = [super init];
    if (self) {
        _demuxerType = WGBMediaAV;
    }
    
    return self;
}


@end
