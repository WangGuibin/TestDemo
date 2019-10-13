#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "WGBCocoa.h"
#import "NSArray+WGBExtension.h"
#import "NSDate+WGBExtension.h"
#import "NSDictionary+WGBExtension.h"
#import "NSObject+CreateClass.h"
#import "NSString+WGBExtension.h"
#import "UIButton+WGBExtension.h"
#import "UIColor+WGBExtension.h"
#import "UIImage+WGBExtension.h"
#import "UIImageView+WGBExtension.h"
#import "UILabel+WGBExtension.h"
#import "UIView+WGBExtension.h"
#import "UIView+WGBMaker.h"
#import "WGBUIViewMaker.h"

FOUNDATION_EXPORT double WGBCocoaKitVersionNumber;
FOUNDATION_EXPORT const unsigned char WGBCocoaKitVersionString[];

