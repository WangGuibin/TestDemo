//
//  CCParallaxView.h
//  ParallaxPrototype
//
//  Created by J. Sinoti Jr on 04/03/13.
//  Copyright (c) 2013 J. Sinoti Jr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CCParallaxView : UIView <UIScrollViewDelegate>{
    NSMutableArray *parallaxElements;
    UIScrollView *scroll;
}

-(void)addPalallaxElement : (UIView *)element;

@end
