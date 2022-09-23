//
//  HLJSTheme.m
//  HighlightJS
//
//  Created by Li Guangming on 2019/5/13.
//  Copyright © 2019 Li Guangming. All rights reserved.
//

#import "HLJSTheme.h"

@implementation HLJSTheme

- (instancetype)initWithThemeString:(NSString *)themeString
{
    self = [super init];
    if (self) {
        self.theme = themeString;
        self.codeFont = [HJSFont fontWithName:@"Courier" size:14];
        self.strippedTheme = [self stripTheme:themeString];
        self.lightTheme = [self strippedThemeToString:self.strippedTheme];
        self.themeDict = [self strippedThemeToTheme:self.strippedTheme];
        
        NSString *bkgColorHex = self.strippedTheme[@".hljs"][@"background"];
        if (!bkgColorHex) {
            bkgColorHex = self.strippedTheme[@".hljs"][@"background-color"];
        }
        if (bkgColorHex) {
            self.themeBackgroundColor = [self colorWithHexString:bkgColorHex];
        } else {
            self.themeBackgroundColor = [HJSColor colorWithWhite:1.0 alpha:1.0];
        }
    }
    return self;
}

/**
 Changes the theme font. This will try to automatically populate the codeFont, boldCodeFont and italicCodeFont properties based on the provided font.
 
 - parameter font: UIFont (iOS or tvOS) or NSFont (OSX)
 */
- (void)setCodeFont:(HJSFont *)font
{
    _codeFont = font;
    
#if TARGET_OS_IOS || TARGET_OS_WATCH
    UIFontDescriptor *boldDescriptor = [UIFontDescriptor fontDescriptorWithFontAttributes:@{UIFontDescriptorFamilyAttribute:font.familyName,
                                                                                            UIFontDescriptorFaceAttribute:@"Bold"
                                                                                            }];
    UIFontDescriptor *italicDescriptor = [UIFontDescriptor fontDescriptorWithFontAttributes:@{UIFontDescriptorFamilyAttribute:font.familyName,
                                                                                              UIFontDescriptorFaceAttribute:@"Italic"
                                                                                              }];
    UIFontDescriptor *obliqueDescriptor = [UIFontDescriptor fontDescriptorWithFontAttributes:@{UIFontDescriptorFamilyAttribute:font.familyName,
                                                                                               UIFontDescriptorFaceAttribute:@"Oblique"
                                                                                               }];
#else
    NSFontDescriptor *boldDescriptor = [NSFontDescriptor fontDescriptorWithFontAttributes:@{NSFontDescriptorFamilyAttribute:font.familyName,
                                                                                            NSFontDescriptorFaceAttribute:@"Bold"
                                                                                            }];
    NSFontDescriptor *italicDescriptor = [NSFontDescriptor fontDescriptorWithFontAttributes:@{NSFontDescriptorFamilyAttribute:font.familyName,
                                                                                              NSFontDescriptorFaceAttribute:@"Italic"
                                                                                              }];
    NSFontDescriptor *obliqueDescriptor = [NSFontDescriptor fontDescriptorWithFontAttributes:@{NSFontDescriptorFamilyAttribute:font.familyName,
                                                                                               NSFontDescriptorFaceAttribute:@"Oblique"
                                                                                               }];
#endif
    
    self.boldCodeFont = [HJSFont fontWithDescriptor:boldDescriptor size:font.pointSize];
    self.italicCodeFont = [HJSFont fontWithDescriptor:italicDescriptor size:font.pointSize];

    if (!self.italicCodeFont || self.italicCodeFont.familyName != font.familyName) {
        self.italicCodeFont = [HJSFont fontWithDescriptor:obliqueDescriptor size:font.pointSize];
    } else if(!self.italicCodeFont) {
        self.italicCodeFont = font;
    }
    
    if (!self.boldCodeFont) {
        self.boldCodeFont = font;
    }
    
    if (self.themeDict) {
        self.themeDict = [self strippedThemeToTheme:self.strippedTheme ];
    }
}

- (NSAttributedString *)applyStyleToString:(NSString *)string styleList:(NSArray *)styleList
{
    if (styleList.count > 0) {
        NSMutableDictionary *attrs = [NSMutableDictionary new];
        attrs[NSFontAttributeName] = self.codeFont;
        for (NSString *style in styleList) {
            NSDictionary *themeStyle = self.themeDict[style];
            if (themeStyle) {
                [attrs addEntriesFromDictionary:themeStyle];
            }
        }
        return [[NSAttributedString alloc] initWithString:string attributes:attrs];
    }
    else {
        return [[NSAttributedString alloc] initWithString:string attributes:@{ NSFontAttributeName : self.codeFont }];
    }
}

- (NSDictionary *)stripTheme:(NSString *)themeString
{
    NSRegularExpression *cssRegex = [NSRegularExpression regularExpressionWithPattern:@"(?:(\\.[a-zA-Z0-9\\-_]*(?:[, ]\\.[a-zA-Z0-9\\-_]*)*)\\{([^\\}]*?)\\})"
                                                                              options:NSRegularExpressionCaseInsensitive
                                                                                error:nil];
    NSArray *results = [cssRegex matchesInString:themeString options:NSMatchingReportCompletion range:NSMakeRange(0, themeString.length)];
    NSMutableDictionary *resultDict = [NSMutableDictionary new];
    
    for (NSTextCheckingResult *result in results) {
        if (result.numberOfRanges == 3) {
            NSMutableDictionary<NSString *, NSString *> *attributes = [NSMutableDictionary new];
            NSArray *cssPairs = [[themeString substringWithRange:[result rangeAtIndex:2]] componentsSeparatedByString:@";"];
            for (NSString *pair in cssPairs) {
                NSArray *cssPropComp = [pair componentsSeparatedByString:@":"];
                if (cssPropComp.count == 2) {
                    attributes[cssPropComp[0]] = cssPropComp[1];
                }
            }
            if (attributes.count > 0) {
                NSString *key = [themeString substringWithRange:[result rangeAtIndex:1]];
                resultDict[key] = attributes;
            }
        }
    }
    
    NSMutableDictionary *returnDict = [NSMutableDictionary new];
    [resultDict enumerateKeysAndObjectsUsingBlock:^(id _Nonnull keys, id _Nonnull result, BOOL *_Nonnull stop) {
        NSArray *keyArray = [keys componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" ,"]];
        for (NSString *key in keyArray) {
            NSMutableDictionary<NSString *, NSString *> *props = returnDict[key];
            if (!props) {
                props = returnDict[key] = [NSMutableDictionary new];
            }
            [props addEntriesFromDictionary:result];
        }
    }];
    return returnDict;
}

- (NSString *)strippedThemeToString:(NSDictionary *)theme
{
    NSMutableString *resultString = [NSMutableString new];
    [theme enumerateKeysAndObjectsUsingBlock:^(id _Nonnull key, id _Nonnull props, BOOL *_Nonnull stop) {
        [resultString appendFormat:@"%@{", key];
        [props enumerateKeysAndObjectsUsingBlock:^(id _Nonnull cssProp, id _Nonnull val, BOOL *_Nonnull stop2) {
            if (![key isEqualToString:@".hljs"] || ![[cssProp lowercaseString] hasPrefix:@"background"]) {
                [resultString appendFormat:@"%@:%@;", cssProp, val];
            }
        }];
        [resultString appendString:@"}"];
    }];
    return resultString;
}

- (NSDictionary *)strippedThemeToTheme:(NSDictionary *)theme
{
    NSMutableDictionary *returnTheme = [NSMutableDictionary new];
    [theme enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull className, id  _Nonnull props, BOOL * _Nonnull stop) {
        NSMutableDictionary *keyProps = [NSMutableDictionary new];
        [props enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull prop, BOOL * _Nonnull stop) {
            if ([key isEqualToString:@"color"]) {
                keyProps[NSForegroundColorAttributeName] = [self colorWithHexString:prop];
            }
            else if ([key isEqualToString:@"font-style"]) {
                keyProps[NSFontAttributeName] = [self fontForCSSStyle:prop];
            }
            else if ([key isEqualToString:@"font-weight"]) {
                keyProps[NSFontAttributeName] = [self fontForCSSStyle:prop];
            }
            else if ([key isEqualToString:@"background-color"]) {
                keyProps[NSBackgroundColorAttributeName] = [self colorWithHexString:prop];
            }
        }];
        if ([keyProps count]) {
            NSString *key = [className stringByReplacingOccurrencesOfString:@"." withString:@""];
            returnTheme[key] = keyProps;
        }
    }];
    
    return returnTheme;
}

- (HJSFont *)fontForCSSStyle:(NSString *)fontStyle
{
    static NSArray *bolds;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        bolds = @[@"bold", @"bolder", @"600", @"700", @"800", @"900"];
    });

    if ([bolds containsObject:fontStyle]) {
        return self.boldCodeFont;
    }
    else if ([fontStyle isEqualToString:@"italic"] || [fontStyle isEqualToString:@"oblique"]) {
        return self.italicCodeFont;
    }
    return self.codeFont;
}

- (HJSColor *)colorWithHexString:(NSString *)hex
{
    NSString *str = [hex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

    if (![str hasPrefix:@"#"]) {
        if ([str isEqualToString:@"white"]) {
            return [HJSColor colorWithWhite:1 alpha:1.0];
        }
        else if ([str isEqualToString:@"black"]) {
            return [HJSColor colorWithWhite:0 alpha:1.0];
        }
        else if ([str isEqualToString:@"red"]) {
            return [HJSColor colorWithRed:1 green:0 blue:0 alpha:1];
        }
        else if ([str isEqualToString:@"green"]) {
            return [HJSColor colorWithRed:0 green:1 blue:0 alpha:1];
        }
        else if ([str isEqualToString:@"blue"]) {
            return [HJSColor colorWithRed:0 green:0 blue:1 alpha:1];
        }
        else {
            return [HJSColor grayColor];
        }
    }
    
    str = [str substringFromIndex:1];
    
    CGFloat alpha, red, blue, green;
    switch ([str length]) {
        case 3: // #RGB
            alpha = 1.0f;
            red = [self colorComponentFrom:str start:0 length:1];
            green = [self colorComponentFrom:str start:1 length:1];
            blue = [self colorComponentFrom:str start:2 length:1];
            break;
        case 4: // #ARGB
            alpha = [self colorComponentFrom:str start:0 length:1];
            red = [self colorComponentFrom:str start:1 length:1];
            green = [self colorComponentFrom:str start:2 length:1];
            blue = [self colorComponentFrom:str start:3 length:1];
            break;
        case 6: // #RRGGBB
            alpha = 1.0f;
            red = [self colorComponentFrom:str start:0 length:2];
            green = [self colorComponentFrom:str start:2 length:2];
            blue = [self colorComponentFrom:str start:4 length:2];
            break;
        case 8: // #AARRGGBB
            alpha = [self colorComponentFrom:str start:0 length:2];
            red = [self colorComponentFrom:str start:2 length:2];
            green = [self colorComponentFrom:str start:4 length:2];
            blue = [self colorComponentFrom:str start:6 length:2];
            break;
        default:
            NSLog(@"部分颜色值解析失败 应该使用hex 16进制形式的颜色");
//            [NSException raise:@"Invalid color value" format:@"Color value %@ is invalid.  It should be a hex value of the form #RBG, #ARGB, #RRGGBB, or #AARRGGBB", str];
            break;
    }
    return [HJSColor colorWithRed:red green:green blue:blue alpha:alpha];
}

- (CGFloat)colorComponentFrom:(NSString *)string start:(NSUInteger)start length:(NSUInteger)length
{
    NSString *substring = [string substringWithRange:NSMakeRange(start, length)];
    NSString *fullHex = length == 2 ? substring : [NSString stringWithFormat:@"%@%@", substring, substring];
    unsigned hexComponent;
    [[NSScanner scannerWithString:fullHex] scanHexInt:&hexComponent];
    return hexComponent / 255.0;
}

@end
