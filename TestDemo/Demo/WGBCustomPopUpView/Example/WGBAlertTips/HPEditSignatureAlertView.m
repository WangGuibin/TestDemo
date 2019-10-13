//
//  HPEditSignatureAlertView.m
//  DY-ios
//
//  Created by mac on 2019/10/3.
//  Copyright © 2019 YGC. All rights reserved.
//

#import "HPEditSignatureAlertView.h"
#import <IQTextView.h>

#define kMaxLimitWordsCount 50

@interface HPEditSignatureAlertView()

@property (weak, nonatomic) IBOutlet UILabel *tittleLabel;

@property (weak, nonatomic) IBOutlet IQTextView *textView;

@property (weak, nonatomic) IBOutlet UILabel *limitCountLabel;


@end

@implementation HPEditSignatureAlertView


- (void)awakeFromNib{
    [super awakeFromNib];
    
    ViewRadius(self.textView, 4);
    self.textView.contentInset = UIEdgeInsetsMake(10, 10, 10, 10);
    @weakify(self);
    [self.textView.rac_textSignal subscribeNext:^(NSString * _Nullable x) {
        @strongify(self);
        if (x.length >= kMaxLimitWordsCount
            ) {
            self.textView.text = [x substringToIndex:kMaxLimitWordsCount];
        }
        self.limitCountLabel.text = [NSString stringWithFormat:@"%ld/%@",self.textView.text.length,@(kMaxLimitWordsCount).stringValue];
    }];
    
}


// 0 取消  1 确定
- (IBAction)clickButtonAction:(UIButton *)sender { 
    NSInteger index = sender.tag;
    !self.editCallBackBlock? : self.editCallBackBlock(self.textView.text,index);
}




@end
