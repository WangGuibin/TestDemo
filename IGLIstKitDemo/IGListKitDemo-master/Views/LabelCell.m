//
//  LabelCell.m
//  IGListKitDemo
//
//  Created by iOS on 2017/6/27.
//  Copyright © 2017年 lg. All rights reserved.
//

#import "LabelCell.h"
#import <IGListKit.h>

@interface LabelCell () <IGListBindable>

@property (nonatomic, assign) UIEdgeInsets insets;
@property (nonatomic, copy) UIFont *font;

@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) CALayer *separator;
@end

//UIEdgeInsets insets = UIEdgeInsetsMake(8, 15, 8, 15);

@implementation LabelCell

- (void)initSetup {
    _insets = UIEdgeInsetsMake(8, 15, 8, 15);
    _font = [UIFont systemFontOfSize:17];
}



- (CGFloat)singleLineHeight {
    return _font.lineHeight + _insets.top + _insets.bottom;
}

- (CGFloat)textHeight:(NSString *)text width:(CGFloat)width {
    CGSize constrainedSize = CGSizeMake(width - _insets.left - _insets.right, CGFLOAT_MAX);
    NSDictionary *attributes = @{NSFontAttributeName: _font};
    NSStringDrawingOptions options = NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin;
    CGRect bounds = [text boundingRectWithSize:constrainedSize options:options attributes:attributes context:nil];
    return ceil(bounds.size.height) + _insets.top + _insets.bottom;
}

- (UILabel *)label {
    if (!_label) {
        _label = [[UILabel alloc] init];
        _label.backgroundColor = [UIColor clearColor];
        _label.numberOfLines = 0;
        _label.font = _font;
    }
    return _label;
}

- (CALayer *)separator {
    if (!_separator) {
        _separator = [[CALayer alloc] init];
        _separator.backgroundColor = [UIColor colorWithRed:200/255.0 green:199/255.0 blue:204/255.0 alpha:1].CGColor;
    }
    return _separator;
}

- (NSString *)text {
    return _label.text;
}
- (void)setText:(NSString *)text {
    self.label.text = text;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSetup];
        [self.contentView addSubview:self.label];
        [self.contentView.layer addSublayer:self.separator];
        [self.contentView setBackgroundColor:[UIColor whiteColor]];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        NSAssert(NO, @"%s 未实现", __func__);
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect bounds = self.contentView.bounds;
    self.label.frame = UIEdgeInsetsInsetRect(bounds, self.insets);
    CGFloat height = 1.0/[UIScreen mainScreen].scale;
    CGFloat left = self.insets.left;
    self.separator.frame = CGRectMake(left, bounds.size.height-height, bounds.size.width - left, height);
}

- (void)setHighlighted:(BOOL)highlighted {
    self.contentView.backgroundColor = [UIColor colorWithWhite:highlighted ? 0.9 : 1 alpha:1];
}

#pragma mark - IGListBindable
- (void)bindViewModel:(id)viewModel {
    if ([(NSObject *)viewModel isKindOfClass:[NSString class]]) {
        self.label.text = viewModel;
    }
}

@end
