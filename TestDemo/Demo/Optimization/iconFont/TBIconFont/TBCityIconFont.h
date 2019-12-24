//
//  TBCityIconFont.h
//  IconFontTest
//
//  Created by admin on 16/10/21.
//  Copyright © 2016年 admin. All rights reserved.
//
#import "UIImage+TBCityIconFont.h"
#import <Foundation/Foundation.h>
#import "TBCityIconInfo.h"

#define TBCityIconInfoMake(text, imageSize, imageColor) [TBCityIconInfo iconInfoWithText:text size:imageSize color:imageColor]

@interface TBCityIconFont : NSObject

+ (UIFont *)fontWithSize: (CGFloat)size;
+ (void)setFontName:(NSString *)fontName;

@end
