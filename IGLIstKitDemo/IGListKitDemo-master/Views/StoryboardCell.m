//
//  StoryboardCell.m
//  IGListKitDemo
//
//  Created by iOS on 2017/7/4.
//  Copyright © 2017年 lg. All rights reserved.
//

#import "StoryboardCell.h"

@interface StoryboardCell ()

@property (nonatomic, strong) IBOutlet UILabel *textLabel;

@end

@implementation StoryboardCell

- (NSString *)text {
    return self.textLabel.text;
}

- (void)setText:(NSString *)text {
    self.textLabel.text = text;
}

@end
