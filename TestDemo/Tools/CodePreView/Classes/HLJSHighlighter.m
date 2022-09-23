//
//  HLJSHighlighter.m
//  HighlightJS
//
//  Created by Li Guangming on 2019/5/13.
//  Copyright © 2019 Li Guangming. All rights reserved.
//

#import "HLJSHighlighter.h"
#import "NSString+HLJS.h"
#import <JavaScriptCore/JavaScriptCore.h>

static NSString * const kHTMLStart = @"<";
static NSString * const kHTMLSpanStart = @"span class=\"";
static NSString * const kHTMLSpanStartClose = @"\">";
static NSString * const kHTMLSpanEnd = @"/span>";

@interface HLJSHighlighter ()
@property (nonatomic, strong) JSContext *context;
@property (nonatomic, strong) NSBundle *bundle;
@property (nonatomic, strong) NSRegularExpression *htmlEscape;
@end

@implementation HLJSHighlighter
/**
 Default init method.
 
 - returns: HighlightJS instance.
 */

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.context = [JSContext new];

        self.bundle = [NSBundle bundleForClass:[HLJSHighlighter class]];
        NSString *hgPath = [self.bundle pathForResource:@"highlight.min" ofType:@"js"];
        NSString *content = [NSString stringWithContentsOfFile:hgPath encoding:NSUTF8StringEncoding error:nil];
        if (content) {
            NSString *script = [NSString stringWithFormat:@"var window = {};"
                                "function hljs_do_highlight (c, l, d) {"
                                "   return (d=window.hljs,l ? d.highlight(l, c) : d.highlightAuto(c)).value;"
                                "}"];
            [self.context evaluateScript:script];
            [self.context evaluateScript:content];
            [self setThemeWithName:@"xcode"];
        }
        self.htmlEscape = [NSRegularExpression regularExpressionWithPattern:@"&#?[a-zA-Z0-9]+?;"
                                                                    options:NSRegularExpressionCaseInsensitive
                                                                      error:nil];
    }
    return self;
}
/**
 Set the theme to use for highlighting.
 
 - parameter to: Theme name
 
 - returns: true if it was possible to set the given theme, false otherwise
 */

- (void)setThemeWithName:(NSString *)name
{
    NSString *file = [NSString stringWithFormat:@"%@.min", name];
    NSString *cssPath = [self.bundle pathForResource:file ofType:@"css"];
    NSString *themeString = [NSString stringWithContentsOfFile:cssPath encoding:NSUTF8StringEncoding error:nil];
    self.theme = [[HLJSTheme alloc] initWithThemeString:themeString];
}

- (void)setTheme:(HLJSTheme *)theme
{
    _theme = theme;
    if (self.themeChangedBlock) {
        self.themeChangedBlock(theme);
    }
}

/**
 Takes a String and returns a NSAttributedString with the given language highlighted.
 
 - parameter code:           Code to highlight.
 - parameter languageName:   Language name or alias. Set to `nil` to use auto detection.
 - parameter fastRender:     Defaults to true - When *true* will use the custom made html parser rather than Apple's solution.
 
 - returns: NSAttributedString with the detected code highlighted.
 */

- (NSAttributedString *)highlightWithCode:(NSString *)code languageName:(NSString *)languageName fastRender:(BOOL)fastRender
{
    JSValue *func = self.context[@"hljs_do_highlight"];

    if ([func isUndefined]) {
        return nil;
    }

    JSValue *res = [func callWithArguments:@[code, languageName]];
    if (![res isString]) {
        return nil;
    }

    NSString *string = [res toString];
    if (fastRender) {
        return [self processHTMLString:string];
    }
    
    string = [NSString stringWithFormat:@"<style>%@</style><pre><code class=\"hljs\">%@</code></pre>",
              self.theme.lightTheme, string];
    NSDictionary *opt = @{
                          NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
                          NSCharacterEncodingDocumentAttribute: @(NSUTF8StringEncoding)
                          };
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    return [[NSAttributedString alloc] initWithData:data options:opt documentAttributes:nil error:nil];
}

/**
 Returns a list of all the available themes.
 
 - returns: Array of Strings
 */

- (NSArray *)availableThemes
{
    NSArray *paths = [self.bundle pathsForResourcesOfType:@"css" inDirectory:nil];
    NSMutableArray *result = [NSMutableArray new];
    for (NSString *path in paths) {
        NSString *s = [path.lastPathComponent stringByReplacingOccurrencesOfString:@".min.css" withString:@""];
        [result addObject:s];
    }
    return result;
}

/**
 Returns a list of all supported languages.
 
 - returns: Array of Strings
 */
- (NSArray *)supportedLanguages
{
    NSString *command = @"window.hljs.listLanguages();";
    JSValue *res = [self.context evaluateScript:command];
    return [res toArray];
}

- (NSAttributedString *)processHTMLString:(NSString *)string
{
    NSScanner *scanner = [NSScanner scannerWithString:string];
    
    scanner.charactersToBeSkipped = nil;
    NSString *scannedString;
    NSMutableAttributedString *resultString = [[NSMutableAttributedString alloc] initWithString:@""];
    NSMutableArray *propStack = [NSMutableArray arrayWithObjects:@"hljs", nil];
    
    while (!scanner.isAtEnd) {
        BOOL ended = NO;

        if ([scanner scanUpToString:kHTMLStart intoString:&scannedString]) {
            if (scanner.isAtEnd) {
                ended = YES;
            }
        }

        if (scannedString  && scannedString.length > 0) {
            NSAttributedString *attrScannedString = [self.theme applyStyleToString:scannedString styleList:propStack];
            [resultString appendAttributedString:attrScannedString];
            if (ended) {
                continue;
            }
        }

        scanner.scanLocation += 1;
        unichar nextChar = [scanner.string characterAtIndex:scanner.scanLocation];
        if (nextChar == 's') {
            scanner.scanLocation += kHTMLSpanStart.length;
            [scanner scanUpToString:kHTMLSpanStartClose intoString:&scannedString];
            scanner.scanLocation += kHTMLSpanStartClose.length;
            [propStack addObject:scannedString];
        } else if(nextChar == '/') {
            scanner.scanLocation += kHTMLSpanEnd.length;
            [propStack removeLastObject];
        } else {
            NSAttributedString *attrScannedString = [self.theme applyStyleToString:@"<" styleList:propStack];
            [resultString appendAttributedString:attrScannedString];
            scanner.scanLocation += 1;
        }
        scannedString = nil;
    }

    NSArray *results = [self.htmlEscape matchesInString:resultString.string
                                                options:NSMatchingReportCompletion
                                                  range:NSMakeRange(0, resultString.length)];

    NSUInteger offset = 0;
    for (NSTextCheckingResult *result in results) {
        NSRange fixedRange = NSMakeRange(result.range.location-offset, result.range.length);
        NSString *entity = [resultString.string substringWithRange:fixedRange];
        NSString *decodedEntity = [entity htmlEntityDecode];
        if (decodedEntity) {
            [resultString replaceCharactersInRange:fixedRange withString:decodedEntity];
            offset += result.range.length - 1;
        }
    }
    return resultString;
}

@end
