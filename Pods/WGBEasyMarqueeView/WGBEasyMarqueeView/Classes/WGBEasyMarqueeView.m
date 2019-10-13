//
//  WGBEasyMarqueeType.m
//
//  Created by mac on 2019/9/24.
//  Copyright © 2019 CoderWGB. All rights reserved.
//

#import "WGBEasyMarqueeView.h"

@interface WGBEasyMarqueeView()

@property (nonatomic,strong) UIView *containerView;
@property (nonatomic,strong) CADisplayLink *marqueeDisplayLink;
@property (nonatomic,assign) BOOL isReversing;

@end


@implementation WGBEasyMarqueeView

- (void)dealloc{
    self.contentViewFrameConfigWhenCantMarquee =  nil;
}

- (void)willMoveToSuperview:(UIView *)newSuperview{
    [super willMoveToSuperview:newSuperview];
    if (!newSuperview) {
        [self stopMarquee];
    }
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initializeViews];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initializeViews];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self initializeViews];
    }
    return self;
}

- (void)initializeViews{
    self.marqueeType = WGBEasyMarqueeTypeLeft;
    self.contentMargin = 20;
    self.frameInterval = 1;
    self.speed = 1.0;
    self.isReversing = NO;

    UIView * containerView = [[UIView alloc] initWithFrame:CGRectZero];
    self.backgroundColor = [UIColor clearColor];
    self.clipsToBounds = YES;
    containerView.backgroundColor = [UIColor clearColor];
    [self addSubview: containerView];
    self.containerView = containerView;
}


- (void)layoutSubviews{
    [super layoutSubviews];
    
    if (!self.contentView) {
        return;
    }
    
    for (UIView *view in self.containerView.subviews) {
        [view removeFromSuperview];
    }
    
    //对于复杂的视图，需要自己重写contentView的sizeThatFits方法，返回正确的size
    [self.contentView sizeToFit];
    [self.containerView addSubview: self.contentView];

    if(self.marqueeType == WGBEasyMarqueeTypeReverse){
        self.containerView.frame = CGRectMake(0, 0, self.contentView.bounds.size.width, self.bounds.size.height);
    }else {
        self.containerView.frame = CGRectMake(0, 0, self.contentView.bounds.size.width*2 + self.contentMargin, self.bounds.size.height);
    }

    if (self.contentView.bounds.size.width > self.bounds.size.width) {
        self.contentView.frame = CGRectMake(0, 0,self.contentView.bounds.size.width, self.bounds.size.height);
        if (self.marqueeType != WGBEasyMarqueeTypeReverse) {
            //骚操作：UIView是没有遵从拷贝协议的。可以通过UIView支持NSCoding协议，间接来复制一个视图
            UIView *otherContentView = [self.contentView copyMarqueeView];
            otherContentView.frame = CGRectMake(self.contentView.bounds.size.width + self.contentMargin, 0, self.contentView.bounds.size.width , self.bounds.size.height);
            [self.containerView addSubview: otherContentView];
        }
        [self startMarquee];
    }else{
        if (self.contentViewFrameConfigWhenCantMarquee != nil) {
            self.contentViewFrameConfigWhenCantMarquee(self.contentView);
        }else{
            self.contentView.frame = CGRectMake(0, 0, self.contentView.bounds.size.width , self.bounds.size.height);
        }
    }
}


//如果你的contentView的内容在初始化的时候，无法确定。需要通过网络等延迟获取，那么在内容赋值之后，在调用该方法即可。
- (void)reloadData{
    [self setNeedsLayout];
}

- (void)startMarquee{
    [self stopMarquee];

    if (self.marqueeType == WGBEasyMarqueeTypeRight) {
        CGRect frame = self.containerView.frame;
        frame.origin.x = self.bounds.size.width - frame.size.width;
        self.containerView.frame = frame;
    }
    
    self.marqueeDisplayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(processMarquee)];
    self.marqueeDisplayLink.frameInterval = self.frameInterval;
    [self.marqueeDisplayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}


- (void)stopMarquee{
    [self.marqueeDisplayLink invalidate];
    self.marqueeDisplayLink = nil;
}


- (void)processMarquee{
    CGRect frame = self.containerView.frame;
    switch (self.marqueeType) {
        case WGBEasyMarqueeTypeLeft:
        {
            CGFloat targetX = -(self.contentView.bounds.size.width + self.contentMargin);
            if (frame.origin.x <= targetX) {
                frame.origin.x = 0;
                self.containerView.frame = frame;
            }else{
                frame.origin.x -= self.speed;
                if (frame.origin.x < targetX) {
                    frame.origin.x = targetX;
                }
                self.containerView.frame = frame;
            }
            
        }
            break;
        case WGBEasyMarqueeTypeRight:
        {
            CGFloat targetX = self.bounds.size.width - self.contentView.bounds.size.width;
            if(frame.origin.x >= targetX) {
                frame.origin.x = self.bounds.size.width - self.containerView.bounds.size.width;
                self.containerView.frame = frame;
            }else {
                frame.origin.x += self.speed;
                if (frame.origin.x > targetX) {
                    frame.origin.x = targetX;
                }
                self.containerView.frame = frame;
            }
            
        }
            break;
        case WGBEasyMarqueeTypeReverse:
        {
            if(self.isReversing){
                CGFloat targetX = 0;
                if (frame.origin.x > targetX) {
                    frame.origin.x = 0;
                    self.containerView.frame = frame;
                    self.isReversing = NO;
                }else {
                    frame.origin.x += self.speed;
                    if(frame.origin.x > 0) {
                        frame.origin.x = 0;
                        self.isReversing = NO;
                    }
                    self.containerView.frame = frame;
                }
            }else {
                CGFloat targetX = self.bounds.size.width - self.containerView.bounds.size.width;
                if(frame.origin.x <= targetX) {
                    self.isReversing = YES;
                }else {
                    frame.origin.x -= self.speed;
                    if(frame.origin.x < targetX){
                        frame.origin.x = targetX;
                        self.isReversing = YES;
                    }
                    self.containerView.frame = frame;
                }
                
            }
            
        }
            break;
            
        default:
            break;
    }
    
}

- (void)setContentView:(UIView *)contentView{ 
    _contentView = contentView;
    [self setNeedsLayout];
}

@end


@implementation UIView (WGBEasyMarqueeViewCopyable)

- (UIView *)copyMarqueeView{
    NSData *archivedData =  [NSKeyedArchiver archivedDataWithRootObject:self];
    UIView *copyView = (UIView *)[NSKeyedUnarchiver unarchiveObjectWithData:archivedData];
    return copyView;
}

@end
