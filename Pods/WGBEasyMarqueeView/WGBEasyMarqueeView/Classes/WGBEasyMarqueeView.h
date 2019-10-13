//
//  WGBEasyMarqueeView.h
//
//  Created by mac on 2019/9/24.
//  Copyright © 2019 CoderWGB. All rights reserved.

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSUInteger, WGBEasyMarqueeType) {
    WGBEasyMarqueeTypeLeft, //向左滚 默认使用这个
    WGBEasyMarqueeTypeRight,//向右滚
    WGBEasyMarqueeTypeReverse//来回滚
};

NS_ASSUME_NONNULL_BEGIN

@interface WGBEasyMarqueeView : UIView

@property (nonatomic,assign) WGBEasyMarqueeType marqueeType;//default is `WGBMarqueeTypeLeft`

@property (nonatomic,assign) CGFloat contentMargin; //滚动边界 两个视图之间的间距 默认20

//通常来讲：iOS设备的刷新频率事60HZ也就是每秒60次。那么每一次刷新的时间就是1/60秒 大概16.7毫秒。当我们的frameInterval值为1的时候我们需要保证的是 CADisplayLink调用的｀target｀的函数计算时间不应该大于 16.7否则就会出现严重的丢帧现象。
@property (nonatomic,assign) NSInteger frameInterval; //对应`CADisplayLink`的属性`frameInterval` 默认1 一般情况下不用去修改它 1/60 1秒刷新60次最为流畅

@property (nonatomic,assign) CGFloat speed;  // 滚动的速度 默认0.5

@property (nonatomic,strong) UIView *contentView; //需要滚动的View


//当contentView的内容宽度没有超过显示宽度，无需开启跑马灯效果。这个时候contentView的size，默认是调用sizeToFit之后的尺寸。如果想要特殊配置，比如让contentView的size等于WGBMarqueeView，就需要在该闭包自定义配置。
@property (nonatomic,copy) void(^ _Nullable contentViewFrameConfigWhenCantMarquee)(UIView *contentView);
//如果你的contentView的内容在初始化的时候，无法确定。需要通过网络等延迟获取，那么在内容赋值之后，在调用该方法即可。
- (void)reloadData;

@end


@interface UIView (WGBEasyMarqueeViewCopyable)
/// 如果视图里面有圆角、阴影等，仅通过NSKeyedArchiver、NSKeyedUnarchiver相关方法，会丢失对应信息。所以，这种特殊情况需要自定义返回。
/// 重新拷贝一份目标视图。不能返回视图自己，需要重新创建一个实例。
/// 第一种方案，实现`- (instancetype)initWithCoder:(NSCoder *)coder` 初始化构造器，返回一个新实例。
/// 第二种方案，使用`category` 调用`copyMarqueeView`方法，返回一个新实例

- (UIView *)copyMarqueeView;

@end


NS_ASSUME_NONNULL_END
