//
// VegaScrollFlowLayout.m
// TestDemo
//
// Author:  @CoderWGB
// Github:  https://github.com/WangGuibin/TestDemo
// E-mail:  864562082@qq.com
//
// Created by CoderWGB on 2020/9/5
//
/**
Copyright (c) 2019 Wangguibin  

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
*/
    

//参考 https://github.com/ApplikeySolutions/VegaScroll
//写了这个OC版 然鹅失败了.... 具体原因不详...败笔啊 又浪费时间了


#import "VegaScrollFlowLayout.h"

@interface VegaScrollFlowLayout ()

@property (nonatomic, strong) UIDynamicAnimator *dynamicAnimator;
@property (nonatomic, assign) CGFloat latestDelta;
@property (nonatomic, strong) NSMutableArray<NSIndexPath*> *visibleIndexPaths;

@end


//struct CATransform3D
//
//{
//
//CGFloat m11(x轴缩放), m12(y轴切变), m13, m14（x轴拉伸）;
//
//CGFloat m21(x轴切变), m22(y轴缩编), m23, m24(向y轴拉伸);
//
//CGFloat m31, m32, m33, m34;
//
//CGFloat m41（x轴平移）, m42（y轴平移）, m43（z轴平移）, m44(放大);
//
//};

static CATransform3D transformIdentity = (CATransform3D){
    .m11 =  1, .m12 =  0, .m13 =  0, .m14 =  0,
    .m21 =  0, .m22 =  1, .m23 =  0, .m24 =  0,
    .m31 =  0, .m32 =  0, .m33 =  1, .m34 =  0,
    .m41 =  0, .m42 =  0, .m43 =  0, .m44 =  1
};


@implementation VegaScrollFlowLayout

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self initialize];
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)initialize{
    self.springHardness = 15;
    self.isPagingEnabled = YES;
    self.latestDelta = 0;
    self.dynamicAnimator =  [[UIDynamicAnimator alloc] initWithCollectionViewLayout:self];
}

- (void)resetLayout{
    [self.dynamicAnimator removeAllBehaviors];
    [self prepareLayout];
}

- (void)prepareLayout{
    [super prepareLayout];
    if (!self.collectionView) {
        return;
    }
    
    CGFloat expandBy = -100;
    CGRect visibleRect = CGRectInset(self.collectionView.bounds, 0, expandBy);
    
    NSArray<UICollectionViewLayoutAttributes*> *visibleItems = [super layoutAttributesForElementsInRect:visibleRect];
    if (!visibleItems) {
        return;
    }
    NSMutableArray<NSIndexPath*> *indexPathsInVisibleRect = [NSMutableArray array];
    [visibleItems enumerateObjectsUsingBlock:^(UICollectionViewLayoutAttributes * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [indexPathsInVisibleRect addObject:obj.indexPath];
    }];
    self.visibleIndexPaths = indexPathsInVisibleRect;
    
    [self removeNoLongerVisibleBehaviorsWithIndexPathsInVisibleRect:indexPathsInVisibleRect];

    NSMutableArray *newlyVisibleItems = [NSMutableArray array];
    for (UICollectionViewLayoutAttributes *obj in visibleItems) {
        if (![self.visibleIndexPaths containsObject:obj.indexPath]) {
            [newlyVisibleItems addObject:obj];
        }
    }
    [self addBehaviors:newlyVisibleItems];
}

- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity{
    CGPoint latestOffset = [super targetContentOffsetForProposedContentOffset:proposedContentOffset withScrollingVelocity:velocity];
    if (self.isPagingEnabled) {
        CGFloat row = round((proposedContentOffset.y) / (self.itemSize.height + self.minimumLineSpacing));
        CGFloat calculatedOffset = row * self.itemSize.height + row * self.minimumLineSpacing;
        CGPoint targetOffset = CGPointMake(latestOffset.x, calculatedOffset);
        return targetOffset;
    }else{
        return latestOffset;
    }
}

- (NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    if (!self.collectionView) {
        return nil;
    }
    NSMutableArray *dynamicItems = [NSMutableArray array];
    NSArray<UIDynamicItem> *items = (NSArray<UIDynamicItem>*)[self.dynamicAnimator itemsInRect:rect];
    for (UICollectionViewLayoutAttributes *item in items) {
        CGFloat convertedY = item.center.y - self.collectionView.contentOffset.y  - self.sectionInset.top;
        item.zIndex = item.indexPath.row;
        [self transformItemIfNeededWithY:convertedY item:item];
    }
    return dynamicItems;
}

- (void)transformItemIfNeededWithY:(CGFloat)y item:(UICollectionViewLayoutAttributes *)item{
    if (self.itemSize.height > 0 && y < self.itemSize.height*0.5) {
        CGFloat scaleFactor = [self scaleDistributorWithX:y];
        CGFloat yDelta = [self getYDeltaWithY:y];
        item.transform3D = CATransform3DTranslate(transformIdentity, 0, yDelta, 0);
        item.transform3D = CATransform3DScale(item.transform3D, scaleFactor, scaleFactor, scaleFactor);
        item.alpha = [self alphaDistributorWithX:y];
    }
}

-  (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
    return [self.dynamicAnimator layoutAttributesForCellAtIndexPath:indexPath];
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds{
    UIScrollView *scrollView = self.collectionView;
    CGFloat delta = newBounds.origin.y - scrollView.bounds.origin.y;
    self.latestDelta = delta;
    CGPoint touchLocation = [self.collectionView.panGestureRecognizer locationInView:self.collectionView];
    for (UIAttachmentBehavior *behavior in self.dynamicAnimator.behaviors) {
        UICollectionViewLayoutAttributes *attrs = (UICollectionViewLayoutAttributes *)behavior.items.firstObject;
        attrs.center = [self getUpdatedBehaviorItemCenter:behavior touchLocation:touchLocation];
        [self.dynamicAnimator updateItemUsingCurrentState:attrs];
    }
    return NO;
}

// MARK: - Utils
- (void)removeNoLongerVisibleBehaviorsWithIndexPathsInVisibleRect:(NSArray<NSIndexPath*> *)indexPaths{
    NSMutableArray<UIAttachmentBehavior *> *noLongerVisibleBehaviours = [NSMutableArray array];
    for (UIAttachmentBehavior *behavior in self.dynamicAnimator.behaviors) {
        UICollectionViewLayoutAttributes *item = (UICollectionViewLayoutAttributes *)behavior.items.firstObject;
        if (![indexPaths containsObject:item.indexPath]) {
            [noLongerVisibleBehaviours addObject:behavior];
        }
    }
    
    for (UIAttachmentBehavior *behavior in noLongerVisibleBehaviours) {
        UICollectionViewLayoutAttributes *item = (UICollectionViewLayoutAttributes *)behavior.items.firstObject;
        [self.dynamicAnimator removeBehavior:behavior];
        [self.visibleIndexPaths removeObject:item.indexPath];
    }
}

- (void)addBehaviors:(NSArray<UICollectionViewLayoutAttributes *> *)items{
    if (!self.collectionView) {
        return;
    }
    CGPoint touchLocation = [self.collectionView.panGestureRecognizer locationInView:self.collectionView];
    for (UICollectionViewLayoutAttributes *item in items) {
        UIAttachmentBehavior *springBehaviour = [[UIAttachmentBehavior alloc] initWithItem:item attachedToAnchor:item.center];
        springBehaviour.length = 0.0;
        springBehaviour.damping = 0.8;
        springBehaviour.frequency = 1.0;
        if (!CGPointEqualToPoint(CGPointZero, touchLocation)) {
            item.center = [self getUpdatedBehaviorItemCenter:springBehaviour touchLocation:touchLocation];
        }
        [self.dynamicAnimator addBehavior:springBehaviour];
        [self.visibleIndexPaths addObject:item.indexPath];
    }
}


- (CGPoint)getUpdatedBehaviorItemCenter:(UIAttachmentBehavior *)behavior
                          touchLocation:(CGPoint)touchLocation{
    CGFloat yDistanceFromTouch = fabs(touchLocation.y - behavior.anchorPoint.y);
    CGFloat xDistanceFromTouch = fabs(touchLocation.x - behavior.anchorPoint.x);
    CGFloat scrollResistance = (yDistanceFromTouch + xDistanceFromTouch) / (self.springHardness * 100);
    UICollectionViewLayoutAttributes *attrs = (UICollectionViewLayoutAttributes *)behavior.items.firstObject;
    CGPoint center = attrs.center;
    if(self.latestDelta < 0) {
        center.y += MAX(self.latestDelta, self.latestDelta*scrollResistance);
    } else {
        center.y += MIN(self.latestDelta, self.latestDelta*scrollResistance);
    }
    return center;
}


// MARK: - Distribution functions

/**
 Distribution function that start as a square root function and levels off when reaches y = 1.
 - parameter x: X parameter of the function. Current layout implementation uses center.y coordinate of collectionView cells.
 - parameter threshold: The x coordinate where function gets value 1.
 - parameter xOrigin: x coordinate of the function origin.
 */
- (CGFloat)distributorWithX:(CGFloat)x
                  threshold:(CGFloat)threshold
                    xOrigin:(CGFloat)xOrigin{
    if (threshold > xOrigin) {
        CGFloat arg = (x - xOrigin)/(threshold - xOrigin);
        arg = arg <= 0 ? 0 : arg;
        CGFloat y = sqrt(arg);
        return y > 1? 1 : y;
    }else{
        return 1;
    }
}

- (CGFloat)scaleDistributorWithX:(CGFloat)x{
    return [self distributorWithX:x threshold:self.itemSize.height*0.5 xOrigin:-self.itemSize.height*5];
}

- (CGFloat)alphaDistributorWithX:(CGFloat)x {
    return [self distributorWithX:x threshold:self.itemSize.height*0.5 xOrigin:-self.itemSize.height];
}

- (CGFloat)getYDeltaWithY:(CGFloat)y{
    return self.itemSize.height*0.5 - y;
}

@end
