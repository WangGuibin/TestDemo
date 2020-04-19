//
//  WMImageBrowerTransitionView.m
//  Weimai
//
//  Created by 王贵彬 on 2020/4/19.
//  Copyright © 2020 微脉科技. All rights reserved.
//

#import "WMImageBrowerTransitionView.h"
#import "WMImageBrowerUniteView.h"

@interface WMImageBrowerTransitionView ()<UIScrollViewDelegate>

@property (nonatomic, strong) NSArray<WGBImageBrowerModel *> *modelArray;
@property (nonatomic, strong) UIScrollView *scrollView;
//scrollView额外加一层view（原因：UIScrollView的size依赖于subviews。如果subviews的size再依赖于UIScrollView，则布局引擎就混乱了）
@property (nonatomic, strong) UIView *contentView;
//当前View
@property (nonatomic, strong) WMImageBrowerUniteView *currentUniteView;
//用来装载所有的uniteView
@property (nonatomic, strong) NSMutableArray<WMImageBrowerUniteView *> *uniteViewsArray;
//当前下标
@property (nonatomic, assign) NSInteger currentIndex;
//用来显示当前页数
@property (nonatomic, strong) UILabel *indexLabel;

@end

@implementation WMImageBrowerTransitionView


- (instancetype)initWithFrame:(CGRect)frame
                     imgModel:(NSArray *)modelArray {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor orangeColor];
        [self initSubViews];
        if (modelArray) {
            self.modelArray = modelArray;
        }
    }
    return self;
}

- (void)initSubViews {
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.delegate = self;
    self.scrollView.bounces = NO;
    [self addSubview: self.scrollView];
    
    self.contentView = [[UIView alloc] init];
    [self.scrollView addSubview: self.contentView];
}

- (void)setModelArray:(NSArray<WGBImageBrowerModel *> *)modelArray {
    self.uniteViewsArray = [[NSMutableArray alloc] init];
    _modelArray = modelArray;
    WGBImageBrowerModel *firstModel = [modelArray firstObject];
    self.scrollView.frame = CGRectMake(0, 0, self.width, self.width / firstModel.width * firstModel.height);
    self.contentView.frame = CGRectMake(0, 0, self.scrollView.width * modelArray.count, self.scrollView.height);
    
    for (int i = 0; i < modelArray.count; i ++) {
        WMImageBrowerUniteView *uniteView = [[WMImageBrowerUniteView alloc] initWithModel:modelArray[i]];
        [self.contentView addSubview: uniteView];
        [self addLayout: uniteView index:i];
        [self.uniteViewsArray addObject:uniteView];
        self.currentUniteView = uniteView;
    }
    self.scrollView.contentSize = CGSizeMake(self.scrollView.width * self.modelArray.count, 0);
    [self loadIndexLabel];
}

- (void)loadIndexLabel {
    CGFloat indexW = 38;
    CGFloat indexH = 26;
    CGFloat marginTopRight = 10;
    _indexLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.scrollView.width - indexW - marginTopRight, marginTopRight, indexW , indexH)];
    _indexLabel.font = [UIFont systemFontOfSize:14];
    _indexLabel.textColor = [UIColor whiteColor];
    _indexLabel.layer.cornerRadius = indexH/2.0;
    _indexLabel.layer.masksToBounds = YES;
    _indexLabel.textAlignment = NSTextAlignmentCenter;
    _indexLabel.backgroundColor = [UIColor blackColor];
    [self addSubview:_indexLabel];
    self.indexLabel.hidden = self.modelArray.count == 1;
    _indexLabel.text = [NSString stringWithFormat:@"1/%ld",self.modelArray.count];
}


/**
 UniteView约束在contentView上
 */
- (void)addLayout:(WMImageBrowerUniteView *)uniteView index:(NSInteger)index{
        //uniteView上下左约束
    NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:uniteView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1 constant:0];
    
    NSLayoutConstraint *bottomConstraint = [NSLayoutConstraint constraintWithItem:uniteView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeBottom  multiplier:1 constant:0];
    
    //当加第一个uniteView时约束基准为contentView
    NSLayoutConstraint *leftConstraint;
    if (index == 0) {
        WGBImageBrowerModel *imgModel = self.modelArray[0];
        //第一张图片马上加载
        [uniteView.imageView sd_setImageWithURL:[NSURL URLWithString:imgModel.url]];
        leftConstraint = [NSLayoutConstraint constraintWithItem:uniteView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeft multiplier:1 constant:0];
    } else {
        leftConstraint = [NSLayoutConstraint constraintWithItem:uniteView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.currentUniteView attribute:NSLayoutAttributeRight multiplier:1 constant:0];
    }
    [self.contentView addConstraints:@[topConstraint, bottomConstraint, leftConstraint]];
    
    //uniteView宽度约束
    NSLayoutConstraint *widthConstraint = [NSLayoutConstraint  constraintWithItem:uniteView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1  constant:self.scrollView.width];
    [uniteView addConstraint:widthConstraint];
}

#pragma mark-- UIScrollView delegate methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
        //当前页数
    self.currentIndex = scrollView.contentOffset.x / scrollView.width;
    self.indexLabel.text = [NSString stringWithFormat:@"%ld/%ld",self.currentIndex + 1,(unsigned long)self.modelArray.count];
    
        //滑到边界控制
    if (scrollView.contentOffset.x >= (self.modelArray.count- 1) * scrollView.width) {
        return;
    }
    
    //动态改变约束,不管向左还是向右滑动，当前图约束向右，当前图下一张图的约束向左
    WMImageBrowerUniteView *currentUniteView = self.uniteViewsArray[self.currentIndex];
    WMImageBrowerUniteView *nextUniteView = self.uniteViewsArray[self.currentIndex + 1];
    if (!nextUniteView.imageView.image) {//将开始滑动到下个图才加载下个图以节约内存和流量
        WGBImageBrowerModel *model = self.modelArray[self.currentIndex + 1];
        [nextUniteView.imageView sd_setImageWithURL:[NSURL URLWithString: model.url]];
    }
    [currentUniteView removeConstraint:currentUniteView.leftConstraint];
    [currentUniteView addConstraint:currentUniteView.rightConstraint];
    [nextUniteView removeConstraint:nextUniteView.rightConstraint];
    [nextUniteView addConstraint:nextUniteView.leftConstraint];
    
    CGFloat offsetX;//当前图的偏移
    WGBImageBrowerModel *currentImgModel;
    WGBImageBrowerModel *nextImgModel;
    static CGFloat newx = 0;
    static CGFloat oldx = 0;
    newx = scrollView.contentOffset.x;
        //左右滑动判断
    if (newx > oldx) {
        //左滑动以右边出现的图为基准改变scrollView的高度
        nextImgModel = self.modelArray[self.currentIndex + 1];
        currentImgModel = self.modelArray[self.currentIndex];
        offsetX = scrollView.contentOffset.x - self.currentIndex * scrollView.width;
    }else {
        //右滑动以左边出现的图为基准改变scrollView的高度
        nextImgModel = self.modelArray[self.currentIndex];
        currentImgModel = self.modelArray[self.currentIndex + 1];
        offsetX = (self.currentIndex + 1) * scrollView.width - scrollView.contentOffset.x;
    }
    oldx = newx;
    
        //切换前scrollView的高度
    CGFloat currentHeight = scrollView.width / currentImgModel.width * currentImgModel.height;
        //切换完成时scrollView的高度
    CGFloat nextHeight = scrollView.width / nextImgModel.width * nextImgModel.height;
        //每单位移动高度的变化量
    CGFloat unitIncrease = (nextHeight - currentHeight) / scrollView.width;
    //scrollView变化中的高度
    CGFloat moveHeight = currentHeight + unitIncrease * offsetX;
    
    
    scrollView.frame = CGRectMake(scrollView.origin.x, scrollView.origin.y, scrollView.width, moveHeight);
    self.contentView.frame = CGRectMake(self.contentView.origin.x, self.contentView.origin.y, self.contentView.width, moveHeight);
    self.height = moveHeight;
    
    !self.scrollUpdateHeightBlock? : self.scrollUpdateHeightBlock(moveHeight);
    !self.scrollDidScrollBlock? : self.scrollDidScrollBlock(offsetX);
}



@end
