//
//  HPCannonBottomOperationView.m
//  DY-ios
//
//  Created by mac on 2019/10/30.
//  Copyright © 2019 YGC. All rights reserved.
//

#import "HPCannonBottomOperationView.h"

@implementation HPCannonBottomOperationView

- (void)awakeFromNib{
    [super awakeFromNib];
    self.backgroundColor = [UIColor blackColor];
}

- (IBAction)allSelectAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (self.delegate && [self.delegate respondsToSelector:@selector(allSelectAction:)]) {
        [self.delegate allSelectAction:sender.selected];
    }
}

- (IBAction)deleteCannonPostAction:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(deletePostListAction)]) {
        [self.delegate deletePostListAction];
    }
}

@end
