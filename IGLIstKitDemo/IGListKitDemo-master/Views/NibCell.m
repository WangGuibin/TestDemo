//
//  NibCell.m
//  IGListKitDemo
//
//  Created by iOS on 2017/6/29.
//  Copyright © 2017年 lg. All rights reserved.
//

#import "NibCell.h"

@interface NibCell ()

@property (nonatomic, weak) IBOutlet UILabel *textLabel;

@end

@implementation NibCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setText:(NSString *)text {
    self.textLabel.text = text;
//    [self.textLabel sizeToFit];
}

- (NSString *)text {
    return _textLabel.text;
}
@end
