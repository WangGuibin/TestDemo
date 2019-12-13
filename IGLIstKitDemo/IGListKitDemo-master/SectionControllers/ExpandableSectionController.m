//
//  ExpandableSectionController.m
//  IGListKitDemo
//
//  Created by iOS on 2017/6/29.
//  Copyright © 2017年 lg. All rights reserved.
//

#import "ExpandableSectionController.h"
#import "LabelCell.h"

@interface ExpandableSectionController ()

@property (nonatomic, assign) BOOL expanded;
@property (nonatomic, copy) NSString *object;

@property (nonatomic, assign) UIEdgeInsets insets;
@property (nonatomic, copy) UIFont *font;

@end

@implementation ExpandableSectionController

- (instancetype)init
{
    self = [super init];
    if (self) {
        _insets = UIEdgeInsetsMake(8, 15, 8, 15);
        _font = [UIFont systemFontOfSize:17];
    }
    return self;
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

- (CGSize)sizeForItemAtIndex:(NSInteger)index {
    CGFloat width = self.collectionContext.containerSize.width;
    CGFloat height = _expanded ? [self textHeight:_object.length !=0 ? _object : @"" width:width] : [self singleLineHeight];
    
    return CGSizeMake(width, height);
}

- (UICollectionViewCell *)cellForItemAtIndex:(NSInteger)index {
    LabelCell *cell = [self.collectionContext dequeueReusableCellOfClass:[LabelCell class] forSectionController:self atIndex:index];
    cell.text = _object;
    
    return cell;
}

- (void)didUpdateToObject:(id)object {
    if ([object isKindOfClass:[NSString class]]) {
        self.object = object;
    }
}

- (void)didSelectItemAtIndex:(NSInteger)index {
    self.expanded = !_expanded;
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.4 initialSpringVelocity:0.6 options:UIViewAnimationOptionTransitionNone animations:^{
        [self.collectionContext invalidateLayoutForSectionController:self completion:nil];
    } completion:nil];
}
@end
