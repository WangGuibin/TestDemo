//
//  HLJSTextView.m
//  HighlightJS
//
//  Created by Li Guangming on 2019/5/13.
//  Copyright © 2019 Li Guangming. All rights reserved.
//

#import "HLJSTextView.h"

static const float kCursorVelocity = 1.0f / 8.0f;
static void *HLJSTextViewContext = &HLJSTextViewContext;

@interface HLJSTextView ()
@property (nonatomic, assign) NSRange startRange;
@property (nonatomic, strong) UIPanGestureRecognizer *singleFingerPanRecognizer;
@property (nonatomic, strong) UIPanGestureRecognizer *doubleFingerPanRecognizer;
@end

@implementation HLJSTextView

- (instancetype)initWithFrame:(CGRect)frame
{
    HLJSTextStorage *textStorage = [HLJSTextStorage new];
    HLJSLayoutManager *layoutManager = [HLJSLayoutManager new];
    //隐藏了默认选中的行的颜色 因为我只需要展示 不需要编辑
    layoutManager.selectedLineNumberColor = [UIColor clearColor];
    NSTextContainer *textContainer = [[NSTextContainer alloc] initWithSize:CGSizeZero];
    [textStorage removeLayoutManager:textStorage.layoutManagers.firstObject];
    [textStorage addLayoutManager:layoutManager];
    [layoutManager addTextContainer:textContainer];

    self = [super initWithFrame:frame textContainer:textContainer];
    if (self) {
        self.lineCursorEnabled = YES;
        self.gutterBackgroundColor = [UIColor colorWithWhite:0.8 alpha:1];
        self.gutterLineColor = [UIColor lightGrayColor];

        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.autocorrectionType = UITextAutocorrectionTypeNo;
        self.autocapitalizationType = UITextAutocapitalizationTypeNone;
        self.textColor = [UIColor colorWithWhite:0.8 alpha:1.0];
        self.backgroundColor = textStorage.highlighter.theme.themeBackgroundColor;
        self.textContainerInset = UIEdgeInsetsMake(8, layoutManager.gutterWidth, 8, 0);
        
        // Setup the gesture recognizers
        self.singleFingerPanRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(singleFingerPanHappend:)];
        self.singleFingerPanRecognizer.maximumNumberOfTouches = 1;
        [self addGestureRecognizer:self.singleFingerPanRecognizer];
        
        self.doubleFingerPanRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(doubleFingerPanHappend:)];
        self.doubleFingerPanRecognizer.minimumNumberOfTouches = 2;
        [self addGestureRecognizer:self.doubleFingerPanRecognizer];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(handleTextViewDidChangeNotification:)
                                                     name:UITextViewTextDidChangeNotification
                                                   object:self];
        [self addObserver:self forKeyPath:NSStringFromSelector(@selector(selectedTextRange))
                  options:NSKeyValueObservingOptionNew
                  context:HLJSTextViewContext];
        [self addObserver:self forKeyPath:NSStringFromSelector(@selector(selectedRange))
                  options:NSKeyValueObservingOptionNew
                  context:HLJSTextViewContext];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidChangeNotification object:self];
    [self removeObserver:self forKeyPath:NSStringFromSelector(@selector(selectedTextRange))];
    [self removeObserver:self forKeyPath:NSStringFromSelector(@selector(selectedRange))];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (context == HLJSTextViewContext) {
        [self setNeedsDisplay];
        if (self.lineCursorEnabled) {
            self.hljsLayoutManager.selectedRange = self.selectedRange;
            NSRange glyphRange = [self.hljsLayoutManager.textStorage.string paragraphRangeForRange:self.selectedRange];
            glyphRange = [self.hljsLayoutManager glyphRangeForCharacterRange:glyphRange actualCharacterRange:NULL];
            self.hljsLayoutManager.selectedRange = glyphRange;
            [self.hljsLayoutManager invalidateDisplayForGlyphRange:glyphRange];
        }
    }
    else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (HLJSLayoutManager *)hljsLayoutManager
{
    return (HLJSLayoutManager *)self.layoutManager;
}

- (HLJSTextStorage *)hljsTextStorage
{
    return (HLJSTextStorage *)self.textStorage;
}

- (UIFont *)font
{
    return self.hljsTextStorage.highlighter.theme.codeFont;
}

- (void)setFont:(UIFont *)font
{
    self.hljsTextStorage.highlighter.theme.codeFont = font;
}

-(NSString *)language
{
    return self.hljsTextStorage.language;
}

- (void)setLanguage:(NSString *)language
{
    self.hljsTextStorage.language = language;
}

- (void)setTheme:(NSString *)theme
{
    _theme = theme;
    [self.hljsTextStorage.highlighter setThemeWithName:theme];
    self.backgroundColor = self.hljsTextStorage.highlighter.theme.themeBackgroundColor;
}

#pragma mark - Notifications

- (void)handleTextViewDidChangeNotification:(NSNotification *)notification
{
    if (notification.object == self) {
        CGRect line = [self caretRectForPosition:self.selectedTextRange.start];
        CGFloat overflow = line.origin.y + line.size.height - (self.contentOffset.y + self.bounds.size.height - self.contentInset.bottom - self.contentInset.top);
        if (overflow > 0) {
            // We are at the bottom of the visible text and introduced a line feed, scroll down (iOS 7 does not do it)
            // Scroll caret to visible area
            CGPoint offset = self.contentOffset;
            offset.y += overflow + 7; // leave 7 pixels margin
        }
    }
}

#pragma mark - Gestures

// Sourced from: https://github.com/srijs/NLTextView
- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer
{
    // Only accept horizontal pans for the code navigation to preserve correct scrolling behaviour.
    if (gestureRecognizer == self.singleFingerPanRecognizer || gestureRecognizer == self.doubleFingerPanRecognizer) {
        CGPoint translation = [gestureRecognizer translationInView:self];
        return fabs(translation.x) > fabs(translation.y);
    }
    
    return YES;
}

// Sourced from: https://github.com/srijs/NLTextView
- (void)singleFingerPanHappend:(UIPanGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateBegan) {
        self.startRange = self.selectedRange;
    }

    CGFloat cursorLocation = MAX(self.startRange.location + [sender translationInView:self].x * kCursorVelocity, 0);
    self.selectedRange = NSMakeRange(cursorLocation, 0);
}

// Sourced from: https://github.com/srijs/NLTextView
- (void)doubleFingerPanHappend:(UIPanGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateBegan) {
        self.startRange = self.selectedRange;
    }
    
    CGFloat cursorLocation = MAX(self.startRange.location + [sender translationInView:self].x * kCursorVelocity, 0);
    
    if (cursorLocation > self.startRange.location) {
        self.selectedRange = NSMakeRange(self.startRange.location, fabs(self.startRange.location - cursorLocation));
    }
    else {
        self.selectedRange = NSMakeRange(cursorLocation, fabs(self.startRange.location - cursorLocation));
    }
}

@end
