//
//  CalendarDayCell.m
//  IGListKitDemo
//
//  Created by iOS on 2017/7/5.
//  Copyright © 2017年 lg. All rights reserved.
//

#import "CalendarDayCell.h"
#import "DayViewModel.h"

@interface CalendarDayCell ()

@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UILabel *dotsLabel;

@end

@implementation CalendarDayCell

- (UILabel *)label {
    if (!_label) {
        _label = [[UILabel alloc] init];
        [_label setBackgroundColor:[UIColor clearColor]];
        [_label setTextAlignment:NSTextAlignmentCenter];
        [_label setTextColor:[UIColor blackColor]];
        [_label setFont:[UIFont boldSystemFontOfSize:16]];
        [_label.layer setBorderWidth:2.0];
        [_label setClipsToBounds:YES];
    }
    return _label;
}

- (UILabel *)dotsLabel {
    if (!_dotsLabel) {
        _dotsLabel = [[UILabel alloc] init];
        [_dotsLabel setBackgroundColor:[UIColor clearColor]];
        [_dotsLabel setTextAlignment:NSTextAlignmentCenter];
        [_dotsLabel setTextColor:[UIColor redColor]];
        [_dotsLabel setFont:[UIFont boldSystemFontOfSize:30]];
    }
    return _dotsLabel;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.label];
        [self.contentView addSubview:self.dotsLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGRect bounds = self.contentView.bounds;
    CGFloat half = bounds.size.height/2;
    [self.label setFrame:bounds];
    [self.label.layer setCornerRadius:half];
    [self.dotsLabel setFrame:CGRectMake(0, half-10, bounds.size.width, half)];
    
}

- (void)bindViewModel:(id)viewModel {
    if ([viewModel isKindOfClass:[DayViewModel class]]) {
        DayViewModel *model = viewModel;
        self.label.text = @(model.day).description;
        
        self.label.layer.borderColor = model.today ? [UIColor redColor].CGColor : [UIColor clearColor].CGColor;
        self.label.backgroundColor = model.selected ? [[UIColor redColor] colorWithAlphaComponent:0.3] : [UIColor clearColor];
        
        NSString *dots = @"";
        for (int i=0; i<model.appointments; i++) {
            dots = [dots stringByAppendingString:@"."];
        }
        self.dotsLabel.text = dots;
    }
}
@end
