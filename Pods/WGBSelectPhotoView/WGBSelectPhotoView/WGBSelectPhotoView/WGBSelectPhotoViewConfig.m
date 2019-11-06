//
//  WGBSelectPhotoViewConfig.m
//  WGBSelectPhotoView
//
//  Created by mac on 2019/11/6.
//  Copyright © 2019 mac. All rights reserved.
//

#import "WGBSelectPhotoViewConfig.h"

// The best order for path scale search.
static NSArray *_NSBundlePreferredScales() {
    static NSArray *scales;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        CGFloat screenScale = [UIScreen mainScreen].scale;
        if (screenScale <= 1) {
            scales = @[@1,@2,@3];
        } else if (screenScale <= 2) {
            scales = @[@2,@3,@1];
        } else {
            scales = @[@3,@2,@1];
        }
    });
    return scales;
}

// Add scale modifier to the file name (without path extension), from @"name" to @"name@2x".
static NSString *_NSStringByAppendingNameScale(NSString *string, CGFloat scale) {
    if (!string) return nil;
    if (fabs(scale - 1) <= __FLT_EPSILON__ || string.length == 0 || [string hasSuffix:@"/"]) return string.copy;
    return [string stringByAppendingFormat:@"@%@x", @(scale)];
}

@implementation UIImage (YBImageBrowser)

+ (UIImage *)wgb_imageNamed:(NSString *)name bundle:(NSBundle *)bundle {
    if (name.length == 0) return nil;
    if ([name hasSuffix:@"/"]) return nil;
    
    NSString *res = name.stringByDeletingPathExtension;
    NSString *ext = name.pathExtension;
    NSString *path = nil;
    CGFloat scale = 1;
    
    // If no extension, guess by system supported (same as UIImage).
    NSArray *exts = ext.length > 0 ? @[ext] : @[@"", @"png", @"jpeg", @"jpg", @"gif", @"webp", @"apng"];
    NSArray *scales = _NSBundlePreferredScales();
    for (int s = 0; s < scales.count; s++) {
        scale = ((NSNumber *)scales[s]).floatValue;
        NSString *scaledName = _NSStringByAppendingNameScale(res, scale);
        for (NSString *e in exts) {
            path = [bundle pathForResource:scaledName ofType:e];
            if (path) break;
        }
        if (path) break;
    }
    if (path.length == 0) {
        // Assets.xcassets supported.
        return [self imageNamed:name];
    }
    
    NSData *data = [NSData dataWithContentsOfFile:path];
    if (data.length == 0) return nil;
    
    return [[self alloc] initWithData:data scale:scale];
}

@end


NSBundle *WGBVideoBundle(void) {
    static NSBundle *bundle = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSBundle *_bundle = [NSBundle bundleForClass:NSClassFromString(@"WGBSelectPhotoView")];
        NSString *path = [_bundle pathForResource:@"WGBSelectPhotoView" ofType:@"bundle"];
        bundle = [NSBundle bundleWithPath:path];
    });
    return bundle;
}

@implementation WGBSelectPhotoViewConfig

+ (instancetype)sharedManager {
    static WGBSelectPhotoViewConfig *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [WGBSelectPhotoViewConfig new];
    });
    return manager;
}

- (instancetype)init {
    self = [super init];
    if (self) {

        _deleteButtonImage = ^UIImage * _Nullable{
            return [UIImage wgb_imageNamed:@"wgb_delete" bundle: WGBVideoBundle()];
        };
        
        _addButtonImage = ^UIImage * _Nullable{
            return [UIImage wgb_imageNamed:@"wgb_add" bundle: WGBVideoBundle()];
        };

        _videoMarkImage = ^UIImage * _Nullable{
            return [UIImage wgb_imageNamed:@"wgb_video_icon" bundle: WGBVideoBundle()];
        };

    }
    return self;
}

@end
