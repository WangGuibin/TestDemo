//
//  HLJSHighlighter.h
//  HighlightJS
//
//  Created by Li Guangming on 2019/5/13.
//  Copyright © 2019 Li Guangming. All rights reserved.
//

#import "HLJSTheme.h"

NS_ASSUME_NONNULL_BEGIN


typedef void(^HLJSThemeChangedBlock)(HLJSTheme *theme);

@interface HLJSHighlighter : NSObject

@property (nonatomic, strong) HLJSTheme *theme;
@property (nonatomic, copy) HLJSThemeChangedBlock themeChangedBlock;

- (void)setThemeWithName:(NSString *)name;
- (NSAttributedString *)highlightWithCode:(NSString *)code languageName:(NSString *)languageName fastRender:(BOOL)fastRender;

- (NSArray *)availableThemes;
- (NSArray *)supportedLanguages;

@end

NS_ASSUME_NONNULL_END
