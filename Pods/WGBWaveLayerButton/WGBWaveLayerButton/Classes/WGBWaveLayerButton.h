//
//  WGBWaveLayerButton.h
//
//  Created by mac on 2019/9/18.
//  Copyright © 2019年 CoderWGB. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WGBWaveLayerButton : UIButton

//动画时间，默认为1秒
@property (nonatomic,assign) NSTimeInterval animationDuration;
//动画颜色
@property (nonatomic,strong) UIColor *waveLayerColor;

@end
