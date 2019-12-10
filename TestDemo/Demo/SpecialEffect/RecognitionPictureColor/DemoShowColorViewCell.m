//
// DemoShowColorViewCell.m
// TestDemo
//
// Author:  @CoderWGB
// Github:  https://github.com/WangGuibin/TestDemo
// E-mail:  864562082@qq.com
//
// Created by CoderWGB on 2019/12/10
//
/**
Copyright (c) 2019 Wangguibin  

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
*/
    

#import "DemoShowColorViewCell.h"

@interface DemoShowColorViewCell ()

/** showColorLabel */
@property (nonatomic,strong) UILabel *showColorLabel;

/** showPercentageLabel */
@property (nonatomic,strong) UILabel *showPercentageLabel;

@end

@implementation DemoShowColorViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self){
        self.backgroundColor = [UIColor darkGrayColor];
        
        _showColorLabel = [[UILabel alloc]init];
        _showColorLabel.textColor = [UIColor whiteColor];
        _showColorLabel.shadowColor = [UIColor darkGrayColor];
        _showColorLabel.shadowOffset = CGSizeMake(1.0f, 1.0f);
        _showColorLabel.font = [UIFont systemFontOfSize:16.0f];
        [self addSubview:_showColorLabel];
        
        _showPercentageLabel = [[UILabel alloc]init];
        _showPercentageLabel.textColor = [UIColor whiteColor];
        _showPercentageLabel.shadowColor = [UIColor darkGrayColor];
        _showPercentageLabel.shadowOffset = CGSizeMake(1.0f, 1.0f);
        _showPercentageLabel.font = [UIFont systemFontOfSize:16.0f];
        [self addSubview:_showPercentageLabel];
    }
    return self;
}

- (void)configureData:(PaletteColorModel*)model andKey:(NSString *)modeKey{
    NSString *showText;
    NSString *percentageText;
    if (![model isKindOfClass:[PaletteColorModel class]]){
        showText = [NSString stringWithFormat:@"%@:识别失败",modeKey];
    }else{
        showText = [NSString stringWithFormat:@"%@:%@",modeKey,model.imageColorString];
        percentageText = [NSString stringWithFormat:@"%.1f%@",model.percentage*100,@"%"];
        self.backgroundColor = [UIColor colorWithHexString:model.imageColorString];
    }
    _showColorLabel.text = showText;
    [_showColorLabel sizeToFit];
    _showColorLabel.origin = CGPointMake((self.width - _showColorLabel.width)/2, (self.height - _showColorLabel.height)/2);
    
    _showPercentageLabel.text = percentageText;
    [_showPercentageLabel sizeToFit];
    _showPercentageLabel.origin = CGPointMake((self.width - _showPercentageLabel.width)/2, _showColorLabel.bottom + 5.0f);
}
@end
