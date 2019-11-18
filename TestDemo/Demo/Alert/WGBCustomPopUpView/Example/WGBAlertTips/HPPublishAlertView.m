//
//  HPPublishAlertView.m
//  DY-ios
//
//  Created by mac on 2019/8/1.
//  Copyright © 2019 YGC. All rights reserved.
//

#import "HPPublishAlertView.h"

@interface HPPublishAlertView()


@end


@implementation HPPublishAlertView

- (void)awakeFromNib{
    [super awakeFromNib];
    
}

//退出弹窗
- (IBAction)cancelAction:(id)sender {
    !self.cancelBlock? : self.cancelBlock();
}

// 0 发布图文 ,1 发布视频 || 0 拍摄 1 从相册中选取
- (IBAction)publishSelectMediaAction:(UIButton *)sender {
    sender.layer.borderColor = [UIColor colorWithHexString:@"#9D3DFA"].CGColor;
    sender.selected = YES; // 一瞬间的事情 选中个毛线
    !self.selectPublishMediaBlock? : self.selectPublishMediaBlock(sender.tag);
    sender.userInteractionEnabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        sender.userInteractionEnabled = YES;
    });
}

@end
