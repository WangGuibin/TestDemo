//
//  DJQTextFiledTitleView.m
//  DJQ_iOS_Service
//
//  Created by neotv-- on 2018/6/23.
//  Copyright © 2018年 NEOTV. All rights reserved.
//

#import "DJQTextFiledTitleView.h"

@interface DJQTextFiledTitleView ()

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation DJQTextFiledTitleView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        self.titleLabel           = [[UILabel alloc] initWithFrame:CGRectMake(20, 15, 100, 20)];
        self.titleLabel.font      = [UIFont systemFontOfSize:15];
        self.titleLabel.textColor = [UIColor blackColor];
        [self addSubview:self.titleLabel];
        
        self.field               = [[UITextField alloc] initWithFrame:CGRectMake(140, 15, UIScreen.mainScreen.bounds.size.width - 280, 20)];
        self.field.textAlignment = NSTextAlignmentRight;
        self.field.borderStyle = UITextBorderStyleRoundedRect;
        self.field.font          = [UIFont systemFontOfSize:15];
        self.field.textColor     = [UIColor blackColor];
        [self addSubview:self.field];
        
        UIView * line = [[UIView alloc] initWithFrame:CGRectMake(0, 50 - 0.5, UIScreen.mainScreen.bounds.size.width, 0.5)];
        line.backgroundColor = [UIColor grayColor];
        [self addSubview:line];
    }
    
    return self;
}

#pragma mark - Setter & Getter

- (void)setTitle:(NSString *)title {
    
    self.titleLabel.text = title;
    [self.titleLabel sizeToFit];
 
}

- (NSString *)title {
    
    return self.titleLabel.text;
}

- (void)setPlaceHolder:(NSString *)placeHolder {
    
    self.field.placeholder = placeHolder;
    self.field.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeHolder attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
}

- (NSString *)placeHolder {
    return self.field.placeholder;
}


- (void)setTeamMemberSeq:(NSString *)teamMemberSeq {
    _teamMemberSeq = teamMemberSeq;
}


@end

