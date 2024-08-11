//
//  WGBAudioTools.h

//
//  Created by 王贵彬 on 2023/5/10.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WGBAudioTools : NSObject
//aac 的头

+ (NSData *)adtsDataWithChannels:(NSInteger)channels sampleRate:(NSInteger)sampleRate rawDataLength:(NSInteger)rawDataLength ;

@end

NS_ASSUME_NONNULL_END
