//
//  ManuallySelfSizingCell.m
//  IGListKitDemo
//
//  Created by iOS on 2017/7/4.
//  Copyright © 2017年 lg. All rights reserved.
//

#import "ManuallySelfSizingCell.h"

@interface ManuallySelfSizingCell ()

@property (nonatomic, strong) UILabel *label;

@end

@implementation ManuallySelfSizingCell

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

//- (void)layoutSubviews {
//    [super layoutSubviews];
//    [self.label setFrame:CGRectInset(self.contentView.bounds, 15, 15)];
//}

- (UICollectionViewLayoutAttributes *)preferredLayoutAttributesFittingAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes {
    [self setNeedsLayout];
    [self layoutIfNeeded];
    
    CGSize size = [self.contentView systemLayoutSizeFittingSize:layoutAttributes.size];
    CGRect newFrame = layoutAttributes.frame;
    newFrame.size.width = ceil(size.width);
    newFrame.size.height = ceil(size.height);
    layoutAttributes.frame = newFrame;
    return layoutAttributes;
}

- (UILabel *)label {
    if (!_label) {
        _label = [[UILabel alloc] init];
        [_label setBackgroundColor:[[UIColor greenColor] colorWithAlphaComponent:0.1]];
        [_label setNumberOfLines:1];
        [_label setTranslatesAutoresizingMaskIntoConstraints:NO];
    }
    return _label;
}

- (NSString *)text {
    return self.label.text;
}
- (void)setText:(NSString *)text {
    [self.label setText:text];
}
@end
