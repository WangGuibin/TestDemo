//
//  HLJSLayoutManager.h
//  HighlightJS
//
//  Created by Li Guangming on 2019/5/14.
//  Copyright © 2019 Li Guangming. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HLJSLayoutManager : NSLayoutManager
@property (nonatomic, strong) UIFont *lineNumberFont;
@property (nonatomic, strong) UIColor *lineNumberColor;
@property (nonatomic, strong) UIColor *selectedLineNumberColor;
@property (nonatomic, readonly) CGFloat gutterWidth;
@property (nonatomic, assign) NSRange selectedRange;
@end

NS_ASSUME_NONNULL_END
