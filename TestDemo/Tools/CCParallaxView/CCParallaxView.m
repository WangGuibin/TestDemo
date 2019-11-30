//
//  CCParallaxView.m
//  ParallaxPrototype
//
//  Created by J. Sinoti Jr on 04/03/13.
//  Copyright (c) 2013 J. Sinoti Jr. All rights reserved.
//

#import "CCParallaxView.h"

@implementation CCParallaxView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self start];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self start];
    }
    return self;
}


-(void)start {
    parallaxElements = [NSMutableArray new];
    scroll = [[UIScrollView alloc] init];
    scroll.delegate = self;
    
    [self setClipsToBounds:YES];
    [scroll setShowsHorizontalScrollIndicator:NO];
    [scroll setShowsVerticalScrollIndicator:NO];
    
    [self setBackgroundColor:[UIColor clearColor]];
    [scroll setBackgroundColor:[UIColor clearColor]];
    
    UIView *viewToScroll = [UIView new];
    [viewToScroll setBackgroundColor:[UIColor clearColor]];
    [scroll addSubview:viewToScroll];
    [self addSubview:scroll];
}

-(void)addPalallaxElement : (UIView *)element {
    [element setUserInteractionEnabled:NO];
    [parallaxElements addObject:element];
    [self addSubview:element];
    
    CGSize contentSizeTemp;
    for (UIView *temp in parallaxElements) {
        if(temp.frame.size.width > contentSizeTemp.width) {
            contentSizeTemp.width = temp.frame.size.width;
        }
        if(temp.frame.size.height   > contentSizeTemp.height) {
            contentSizeTemp.height = temp.frame.size.height;
        }
    }
    [scroll setContentSize:contentSizeTemp];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGPoint maxOffSet = CGPointMake(scrollView.contentSize.width  - scrollView.frame.size.width,
                                   scrollView.contentSize.height - scrollView.frame.size.height);

    CGPoint moveRate = CGPointMake(scrollView.contentOffset.x/maxOffSet.x,
                                   scrollView.contentOffset.y/maxOffSet.y);
    
    for (UIView *temp in parallaxElements) {
        [temp setFrame:CGRectMake((scroll.frame.size.width - temp.frame.size.width) * moveRate.x,
                                  (scroll.frame.size.height - temp.frame.size.height) * moveRate.y,
                                  temp.frame.size.width,
                                  temp.frame.size.height)];
        
    }
}

- (void)drawRect:(CGRect)rect
{
    scroll.frame = rect;
}

-(void)removeFromSuperview {
    scroll.delegate = nil;
    [super removeFromSuperview];
}

@end
