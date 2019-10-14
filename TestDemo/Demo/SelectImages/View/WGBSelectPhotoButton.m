//
//  WGBSelectPhotoButton.m
//  TestDemo
//
//  Created by mac on 2019/10/14.
//  Copyright © 2019 mac. All rights reserved.
//

#import "WGBSelectPhotoButton.h"


@interface WGBSelectPhotoButton()

@property (nonatomic, strong) UIButton *deleteBtn;

@end


@implementation WGBSelectPhotoButton


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        [self addSubview:self.deleteBtn];
        CGRect deleteRect = self.deleteBtn.frame;
        deleteRect.origin.x = frame.size.width - 25;
        self.deleteBtn.frame = deleteRect;
        
        self.isAddButton = YES;
        self.contentVerticalAlignment   = UIControlContentVerticalAlignmentFill;
        self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentFill;
        
        UIImage *addImg = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"wgb_add" ofType:@"png"]];
        [self setBackgroundImage: addImg forState:UIControlStateNormal];
        
        [self addTarget:self
                 action:@selector(didClickedPictureBtn)
       forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

#pragma mark - click event
- (void)didClickedPictureBtn {
    !self.didClickButtonBlock? : self.didClickButtonBlock();
}

- (void)didCLickedDeleteBtn {
    !self.deletePhotoBlock? : self.deletePhotoBlock();
}

#pragma mark - getters & setters
- (void)setIsAddButton:(BOOL)isAddButton{
    _isAddButton = isAddButton;
    self.deleteBtn.hidden = isAddButton;
}

- (UIButton *)deleteBtn {
    if (!_deleteBtn) {
        _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _deleteBtn.frame = CGRectMake(0, 0, 25, 25);
        UIImage *deleteImg = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"wgb_delete" ofType:@"png"]];
        [_deleteBtn setBackgroundImage: deleteImg forState:UIControlStateNormal];
        [_deleteBtn addTarget:self
                       action:@selector(didCLickedDeleteBtn)
             forControlEvents:UIControlEventTouchUpInside];
    }
    return _deleteBtn;
}

@end
