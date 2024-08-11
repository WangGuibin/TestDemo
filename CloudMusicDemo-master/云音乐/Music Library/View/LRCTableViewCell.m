//
//  LRCTableViewCell.m
//  云音乐
//
//  Created by 刘超正 on 2017/9/26.
//  Copyright © 2017年 刘超正. All rights reserved.
//

#import "LRCTableViewCell.h"

@implementation LRCTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.lrcLbl = [[LrcLabel alloc]init];
        [self.contentView addSubview:self.lrcLbl];
        //添加约束
        [self.lrcLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentView);
        }];
    }
    
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
