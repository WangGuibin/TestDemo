//
//  TestDeleteButtonTableViewCell.m
//  TestDemo
//
//  Created by mac on 2019/11/1.
//  Copyright © 2019 mac. All rights reserved.
//

#import "TestDeleteButtonTableViewCell.h"

@implementation TestDeleteButtonTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    ViewRadius(self.bgView, 5.0);
}

/** 修改选中按钮的样式 */
 - (void)_changeCellSelectedImage{
      // 利用KVC 遍历自定义图标
      for (UIView *view in self.subviews) {
          if ([view isKindOfClass:NSClassFromString(@"UITableViewCellEditControl")]) {
              for (UIView *subview in view.subviews) {
                   if ([subview isKindOfClass:[UIImageView class]]){
                       UIImageView *iconImageView = (UIImageView *)subview;
                       if (self.selected) {
                           iconImageView.image = [UIImage imageNamed:@"icon_tab_select_sel"];
                       }else{
                           iconImageView.image = [UIImage imageNamed:@"icon_tab_select_nor"];
                       }
                    }
                }
            }
        }
}

/** 选中cell的时候调用 */
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // 改变
    [self _changeCellSelectedImage];
}


- (IBAction)changeAction:(UISwitch *)sender {
    if (sender.isOn) {
        [self.activeView startAnimating];
    }else{
        [self.activeView stopAnimating];
    }
}


@end
