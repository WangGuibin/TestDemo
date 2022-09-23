//
//  HighlightJSAttributedString.h
//  HighlightJS
//
//  Created by Li Guangming on 2019/5/13.
//  Copyright © 2019 Li Guangming. All rights reserved.
//

#import <TargetConditionals.h>

#if TARGET_OS_IOS || TARGET_OS_WATCH
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#else
#import <AppKit/AppKit.h>
#endif

#import "HLJSHighlighter.h"

NS_ASSUME_NONNULL_BEGIN

/// HLJSTextStorageDelegate
@protocol HLJSTextStorageDelegate <NSObject>
/**
 If this method returns *false*, the highlighting process will be skipped for this range.
 - parameter range: NSRange
 - returns: Bool
 */
- (BOOL)shouldHighlight:(NSRange)range;

/**
 Called after a range of the string was highlighted, if there was an error **success** will be *false*.
 - parameter range:   NSRange
 - parameter success: Bool
 */
- (BOOL)didHighlight:(NSRange)range success:(BOOL)success;

@end

// NSTextStorage subclass. Can be used to dynamically highlight code.
@interface HLJSTextStorage : NSTextStorage
// Internal Storage
@property (nonatomic, strong) NSMutableAttributedString *stringStorage;
// HighlightJS instace used internally for highlighting. Use this for configuring the theme.
@property (nonatomic, strong) HLJSHighlighter *highlighter;
@property (nonatomic, weak) id<HLJSTextStorageDelegate> highlightDelegate;
@property (nonatomic, copy) NSString *language;
@end

NS_ASSUME_NONNULL_END
