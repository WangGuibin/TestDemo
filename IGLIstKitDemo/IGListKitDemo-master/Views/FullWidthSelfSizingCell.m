//
//  FullWidthSelfSizingCell.m
//  IGListKitDemo
//
//  Created by iOS on 2017/7/4.
//  Copyright © 2017年 lg. All rights reserved.
//

#import "FullWidthSelfSizingCell.h"

@interface FullWidthSelfSizingCell ()

@property (nonatomic, strong) UILabel *label;

@end

@implementation FullWidthSelfSizingCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView setBackgroundColor:[UIColor whiteColor]];
        [self.contentView addSubview:self.label];
        
        [NSLayoutConstraint constraintWithItem:self.label attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1 constant:15].active = YES;
        [NSLayoutConstraint constraintWithItem:self.label attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeading multiplier:1 constant:15].active = YES;
        [NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.label attribute:NSLayoutAttributeBottom multiplier:1 constant:15].active = YES;
        [NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.label attribute:NSLayoutAttributeTrailing multiplier:1 constant:15].active = YES;
    }
    return self;
}

- (UICollectionViewLayoutAttributes *)preferredLayoutAttributesFittingAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes {
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
    
    CGSize size = [self.contentView systemLayoutSizeFittingSize:layoutAttributes.size];
    CGRect newFrame = layoutAttributes.frame;
    
    newFrame.size.height = ceil(size.height);
    layoutAttributes.frame = newFrame;
    return layoutAttributes;
}

- (UILabel *)label {
    if (!_label) {
        _label = [[UILabel alloc] init];
        [_label setBackgroundColor:[[UIColor redColor] colorWithAlphaComponent:0.1]];
        [_label setNumberOfLines:0];
        [_label setTranslatesAutoresizingMaskIntoConstraints:NO];
    }
    return _label;
}

- (NSString *)text {
    return self.label.text;
}
- (void)setText:(NSString *)text {
    self.label.text = text;
}


@end
