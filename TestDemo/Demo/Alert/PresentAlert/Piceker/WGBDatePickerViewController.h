//
// WGBDatePickerViewController.h
// TestDemo
//
// Author:  @CoderWGB
// Github:  https://github.com/WangGuibin/TestDemo
// E-mail:  864562082@qq.com
//
// Created by CoderWGB on 2019/12/9
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
    

#import <UIKit/UIKit.h>

typedef void (^DateBlock)(NSDate *date);

NS_ASSUME_NONNULL_BEGIN

@interface WGBDatePickerViewController : UIViewController

@property (strong, nonatomic) NSString *titleName; /**< 标题名字*/
@property (copy, nonatomic) DateBlock  dateBlock; /**< block返回最终值*/
@property (strong, nonatomic) NSDate *selectedDate; /**< 选中的日期*/
@property (strong, nonatomic) NSDate *minDate; /**< 最小可选日期  默认最小值为前一天*/
@property (strong, nonatomic) NSDate *maxDate; /**< 最大可选日期*/
@property (assign, nonatomic) UIDatePickerMode datePickerMode; /**< 日期类型 默认：UIDatePickerModeDate*/
@property (nonatomic, assign) CGFloat pickerViewHeight; /**< 选择器高度，默认160*/


@end

NS_ASSUME_NONNULL_END
