//
//  UserHeaderView.m
//  IGListKitDemo
//
//  Created by iOS on 2017/7/3.
//  Copyright © 2017年 lg. All rights reserved.
//

#import "UserHeaderView.h"

@interface UserHeaderView ()

@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *handleLabel;

@end
@implementation UserHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (NSString *)name {
    return self.nameLabel.text;
}
- (void)setName:(NSString *)name {
    self.nameLabel.text = name;
}

- (NSString *)handle {
    return self.handleLabel.text;
}

- (void)setHandle:(NSString *)handle {
    self.handleLabel.text = handle;
}
@end
