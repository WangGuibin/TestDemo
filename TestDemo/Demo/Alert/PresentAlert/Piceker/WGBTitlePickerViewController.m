//
// WGBTitlePickerViewController.m
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
    

#import "WGBTitlePickerViewController.h"

static const CGFloat kDataPickerViewH = 160.f;
static const CGFloat kToolBarH = 44.f;

@interface WGBTitlePickerViewController ()<UIPickerViewDelegate,UIPickerViewDataSource>

@property (nonatomic, strong) UIView *dataPickerBgView;
@property (nonatomic, strong) UIPickerView *dataPickerView;
@property (nonatomic, strong) UILabel* titleLb;
@property (nonatomic, strong) UIToolbar *toolbar;


@end

@implementation WGBTitlePickerViewController

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
    [self setupView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self show];
}

#pragma mark - PickerViewDelegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.dataAry.count;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];;
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        pickerLabel.textAlignment = NSTextAlignmentCenter;
        pickerLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightSemibold];
        pickerLabel.textColor = [UIColor colorWithRed:12.f/255.f green:14.f/255.f blue:14.f/255.f alpha:1];
    }
    pickerLabel.text=[self pickerView:pickerView titleForRow:row forComponent:component];
    [self changeSpearatorLineColor];
    return pickerLabel;
}

#pragma mark - 改变分割线的颜色
- (void)changeSpearatorLineColor {
    for(UIView *speartorView in _dataPickerView.subviews) {
        if (speartorView.frame.size.height < 1) {
            speartorView.backgroundColor = [UIColor greenColor];
        }
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return self.dataAry[row];
}

#pragma mark - event response
-(void)setTime:(id)sender {
    if (_finishBlock) {
        NSInteger row = [_dataPickerView selectedRowInComponent:0];
        _finishBlock(self.dataAry[row], row);
    }
    [self dissmiss];
}

#pragma mark - private methods
- (void)setupView {
    _dataPickerBgView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.frame), CGRectGetWidth(self.view.frame), kToolBarH + self.pickerViewHeight>0?self.pickerViewHeight:kDataPickerViewH)];
    _dataPickerBgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_dataPickerBgView];
    
    _toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), kToolBarH)];
    [_dataPickerBgView addSubview:_toolbar];
    
    UIBarButtonItem* doneButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(setTime:)];
    UIBarButtonItem *cancelButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(dissmiss)];
    UIBarButtonItem *spaceButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem: UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    NSArray *array = [NSArray arrayWithObjects:cancelButtonItem,spaceButtonItem,doneButtonItem, nil];
    [_toolbar setItems:array];
    
    self.titleLb.center = _toolbar.center;
    [_toolbar addSubview:self.titleLb];
    [_dataPickerBgView addSubview:self.dataPickerView];
    
    if (self.selectedName && [self.dataAry containsObject:self.selectedName]) {
        [self.dataPickerView selectRow:[self.dataAry indexOfObject:self.selectedName] inComponent:0 animated:NO];
    }
}

- (void)show {
    CGFloat pickerBgViewH = (self.pickerViewHeight>0?self.pickerViewHeight:kDataPickerViewH) + kToolBarH;
    [UIView animateWithDuration:0.25
                     animations:^{
                         CGFloat calendarViewY = (CGRectGetHeight(self.view.frame) - pickerBgViewH);
                         self.dataPickerBgView.frame = CGRectMake(0, calendarViewY, CGRectGetWidth(self.view.frame), pickerBgViewH);
                     }];
}

- (void)dissmiss {
    CGFloat pickerBgViewH = (self.pickerViewHeight>0?self.pickerViewHeight:kDataPickerViewH) + kToolBarH;
    [UIView animateWithDuration:0.25
                     animations:^{
                         self.dataPickerBgView.frame = CGRectMake(0, CGRectGetHeight(self.view.frame), CGRectGetWidth(self.view.frame), pickerBgViewH);
                     }
                     completion:^(BOOL finished) {
                         [self dismissViewControllerAnimated:NO completion:nil];
                     }];
}

#pragma mark - getters and  setters
- (UIPickerView *)dataPickerView {
    if (!_dataPickerView) {
        UIPickerView *dataPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, kToolBarH, CGRectGetWidth(self.view.frame), self.pickerViewHeight>0?self.pickerViewHeight:kDataPickerViewH)];
        dataPickerView.delegate = self;
        _dataPickerView = dataPickerView;
    }
    return _dataPickerView;
}

- (UILabel *)titleLb {
    if (!_titleLb) {
        UILabel* label = [[UILabel alloc] init];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont systemFontOfSize:13];
        label.text = @"请选择标题";
        label.textAlignment = NSTextAlignmentCenter;
        [label sizeToFit];
        _titleLb = label;
    }
    return _titleLb;
}

- (void)setTitleName:(NSString *)titleName {
    _titleName = titleName;
    
    if (titleName) {
        self.titleLb.text = titleName;
        [self.titleLb sizeToFit];
    }
}

- (void)setSelectedName:(NSString *)selectedName {
    _selectedName = selectedName;
    
    if (_selectedName && [_dataAry containsObject:_selectedName]) {
        [_dataPickerView selectRow:[_dataAry indexOfObject:_selectedName] inComponent:0 animated:NO];
    }
}

#pragma mark - life cycle
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touche = [touches anyObject];
    if ([touche.view isEqual:self.view]) {
        [self dissmiss];
    }
}


@end
