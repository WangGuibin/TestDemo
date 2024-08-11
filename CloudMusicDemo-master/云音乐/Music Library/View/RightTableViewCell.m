//
//  RightTableViewCell.m
//  云音乐
//
//  Created by 刘超正 on 2017/9/21.
//  Copyright © 2017年 刘超正. All rights reserved.
//

#import "RightTableViewCell.h"

@implementation RightTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //排名
        self.rankLbl = [[UILabel alloc]init];
        [self.contentView addSubview:self.rankLbl];
        [self.rankLbl setTextAlignment:NSTextAlignmentCenter];
        //歌曲
        self.title = [[UILabel alloc]init];
        [self.contentView addSubview:self.title];
        //歌手
//        self.author = [[UILabel alloc]init];
//        [self.contentView addSubview:self.author];
//        [self.author setTextColor:LCZColor(149, 149, 149, 1)];
        //添加约束
        [self.rankLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(10);
            make.width.equalTo(@50);
            make.top.equalTo(self.contentView).offset(5);
            make.bottom.equalTo(self.contentView).offset(-5);
        }];
        [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.rankLbl.mas_right).offset(5);
            make.right.equalTo(self.contentView).offset(-10);
            make.height.equalTo(@40);
            make.centerY.equalTo(self.contentView);
        }];
//        [self.author mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.title.mas_bottom).offset(5);
//            make.bottom.equalTo(self.contentView).offset(-5);
//            make.left.equalTo(self.rankLbl.mas_right).offset(5);
//            make.right.equalTo(self.contentView).offset(-10);
//        }];
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
