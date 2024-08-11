//
//  LeftTableViewCell.m
//  云音乐
//
//  Created by 刘超正 on 2017/9/21.
//  Copyright © 2017年 刘超正. All rights reserved.
//

#import "LeftTableViewCell.h"

@implementation LeftTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.TheSongList = [[UILabel alloc]init];
        [self.contentView addSubview:self.TheSongList];
        
        [self.TheSongList mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentView);
            make.centerY.equalTo(self.contentView);
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
