//
//  HPSelectSexAlertView.m
//  DY-ios
//
//  Created by mac on 2019/10/10.
//  Copyright © 2019 YGC. All rights reserved.
//

#import "HPSelectSexAlertView.h"

@interface HPSelectSexAlertView()

@property (weak, nonatomic) IBOutlet UIButton *boyButton;
@property (nonatomic,strong) UIButton *tempButton;

@end


@implementation HPSelectSexAlertView

- (void)awakeFromNib{
    [super awakeFromNib];
    
}


//z选择性别
- (IBAction)selectSexAction:(UIButton *)sender {
    sender.selected = YES;
    self.tempButton.selected = NO;
    self.tempButton = sender;
}

// 0 取消 1 确定
- (IBAction)clickOperationButtonAction:(UIButton *)sender {
    if (self.tempButton.selected) {
        NSInteger sexIndex = self.tempButton.tag;
        NSArray *sexArray = @[@"男",@"女"];
        self.selectSexBlock(sexIndex, sexArray[sexIndex - 1]);
    }else{
        !self.cancelBlock? : self.cancelBlock();
    }
}



@end
