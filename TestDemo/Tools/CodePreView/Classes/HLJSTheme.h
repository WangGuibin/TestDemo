//
//  HLJSTheme.h
//  HighlightJS
//
//  Created by Li Guangming on 2019/5/13.
//  Copyright © 2019 Li Guangming. All rights reserved.
//

#import <TargetConditionals.h>
#import <Foundation/Foundation.h>

#if TARGET_OS_IOS || TARGET_OS_WATCH
#import <UIKit/UIKit.h>
#define HJSColor UIColor
#define HJSFont UIFont
#else
#import <AppKit/AppKit.h>
#define HJSColor NSColor
#define HJSFont NSFont
#endif

NS_ASSUME_NONNULL_BEGIN

@interface HLJSTheme : NSObject

@property(nonatomic, strong) NSString *theme;
@property(nonatomic, strong) NSString *lightTheme;

// Regular font to be used by this theme
@property(nonatomic, strong) HJSFont *codeFont;

// Bold font to be used by this theme
@property(nonatomic, strong) HJSFont *boldCodeFont;

// Italic font to be used by this theme
@property(nonatomic, strong) HJSFont *italicCodeFont;

@property(nonatomic, strong) NSDictionary *themeDict;
@property(nonatomic, strong) NSDictionary *strippedTheme;

// Italic font to be used by this theme
@property(nonatomic, strong) HJSColor *themeBackgroundColor;

- (instancetype)initWithThemeString:(NSString *)themeString;
- (NSAttributedString *)applyStyleToString:(NSString *)string styleList:(NSArray *)styleList;

@end

NS_ASSUME_NONNULL_END
