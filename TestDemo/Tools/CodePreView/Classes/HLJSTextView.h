//
//  HLJSTextView.h
//  HighlightJS
//
//  Created by Li Guangming on 2019/5/13.
//  Copyright © 2019 Li Guangming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HLJSHighlighter.h"
#import "HLJSTextStorage.h"
#import "HLJSLayoutManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface HLJSTextView : UITextView

@property (nonatomic, strong) UIFont *font;
@property (nonatomic, strong) NSString *language;
@property (nonatomic, strong) NSString *theme;
@property (nonatomic, strong) UIColor *gutterBackgroundColor;
@property (nonatomic, strong) UIColor *gutterLineColor;
@property (nonatomic, assign) BOOL lineCursorEnabled;

@end

NS_ASSUME_NONNULL_END
