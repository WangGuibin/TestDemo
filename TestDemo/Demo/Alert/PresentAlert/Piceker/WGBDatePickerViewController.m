//
// WGBDatePickerViewController.m
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
    

#import "WGBDatePickerViewController.h"

static const CGFloat kDatePickerViewH = 160.f;
static const CGFloat kToolBarH = 44.f;

@interface WGBDatePickerViewController ()

@property (nonatomic, strong) UIView *datePickerBgView;
@property (nonatomic, strong) UIDatePicker *datePickerView;
@property (nonatomic, strong) UILabel* titleLb;
@property (nonatomic, strong) UIToolbar *toolbar;

@end

@implementation WGBDatePickerViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        self.modalPresentationStyle = UIModalPresentationCustom;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [[UIColor colorWithRed:73.f / 255.f green:73.f / 255.f blue:73.f / 255.f alpha:1] colorWithAlphaComponent:.5];
    _minDate = [NSDate date];
    _selectedDate = [NSDate date];
    _datePickerMode = UIDatePickerModeDate;
     [self setupView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self show];
}

#pragma mark - event response
-(void)setTime:(id)sender {
    if (_dateBlock) {
        _dateBlock(_datePickerView.date);
    }
    [self dissmiss];
}

#pragma mark - private methods
- (void)setupView {
    _datePickerBgView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.frame), CGRectGetWidth(self.view.frame), [self pickerBgViewHeight])];
    _datePickerBgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_datePickerBgView];
    
    _toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), kToolBarH)];
    [_datePickerBgView addSubview:_toolbar];
    
    UIBarButtonItem* doneButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(setTime:)];
    
    UIBarButtonItem *cancelButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(dissmiss)];
    
    UIBarButtonItem *spaceButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem: UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    NSArray *array = [NSArray arrayWithObjects:cancelButtonItem,spaceButtonItem,doneButtonItem, nil];
    [_toolbar setItems:array];
    
    self.titleLb.center = _toolbar.center;
    [_toolbar addSubview:self.titleLb];
    [_datePickerBgView addSubview:self.datePickerView];
}

- (void)show {
    [UIView animateWithDuration:0.25
                     animations:^{
                         CGFloat calendarViewY = (CGRectGetHeight(self.view.frame) - [self pickerBgViewHeight]);
                         self.datePickerBgView.frame = CGRectMake(0, calendarViewY, CGRectGetWidth(self.view.frame), [self pickerBgViewHeight]);
                     }];
}

- (void)dissmiss {
    [UIView animateWithDuration:0.25
                     animations:^{
                         self.datePickerBgView.frame = CGRectMake(0, CGRectGetHeight(self.view.frame), CGRectGetWidth(self.view.frame), [self pickerBgViewHeight]);
                     }
                     completion:^(BOOL finished) {
                         [self dismissViewControllerAnimated:NO completion:nil];
                     }];
}

#pragma mark - getters and  setters
- (UIDatePicker *)datePickerView {
    if (!_datePickerView) {
        UIDatePicker *datePickerView = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, kToolBarH, CGRectGetWidth(self.view.frame), [self pickerViewH])];
        [datePickerView setLocale:[NSLocale currentLocale]];
        [datePickerView setMinimumDate:self.minDate];
        [datePickerView setMaximumDate:self.maxDate];
        [datePickerView setDatePickerMode:self.datePickerMode];
        [datePickerView setDate:self.selectedDate animated:YES];
        _datePickerView = datePickerView;
    }
    return _datePickerView;
}

- (UILabel *)titleLb {
    if (!_titleLb) {
        UILabel* label = [[UILabel alloc] init];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont systemFontOfSize:13];
        label.text = @"请选择时间";
        label.textAlignment = NSTextAlignmentCenter;
        [label sizeToFit];
        _titleLb = label;
    }
    return _titleLb;
}

- (void)setSelectedDate:(NSDate *)selectedDate {
    _selectedDate = selectedDate;
    
    if (selectedDate) {
        [self.datePickerView setDate:selectedDate];
    }
}

- (void)setDatePickerMode:(UIDatePickerMode)datePickerMode {
    _datePickerMode = datePickerMode;
    
    [_datePickerView setDatePickerMode:datePickerMode];
}

- (void)setTitleName:(NSString *)titleName {
    _titleName = titleName;
    
    if (titleName) {
        self.titleLb.text = titleName;
        [self.titleLb sizeToFit];
    }
}

- (void)setPickerViewHeight:(CGFloat)pickerViewHeight {
    _pickerViewHeight = pickerViewHeight;
    CGRect frame = self.datePickerView.frame;
    frame.size.height = pickerViewHeight;
    self.datePickerView.frame = frame;
}

#pragma mark - life cycle
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touche = [touches anyObject];
    if ([touche.view isEqual:self.view]) {
        [self dissmiss];
    }
}

- (CGFloat)pickerBgViewHeight {
    return kToolBarH + [self pickerViewH];
}

- (CGFloat)pickerViewH {
    return self.pickerViewHeight > 0 ? self.pickerViewHeight: kDatePickerViewH;
}
@end
