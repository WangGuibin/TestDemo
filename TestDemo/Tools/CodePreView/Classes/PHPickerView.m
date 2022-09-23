//
//  PHPickerView.m
//
//  Created by 王贵彬 on 2021/7/19.
//

#import "PHPickerView.h"

#define kScreenSize  [UIScreen mainScreen].bounds.size

@interface PHPickerView ()<UIPickerViewDelegate,UIPickerViewDataSource>

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIView *pickBgView;

@property (nonatomic, strong) UIView *toolBar;
@property (nonatomic, strong) UILabel *titleLabel;
@property (strong, nonatomic) UIVisualEffectView *visualEffectView;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIButton *confirmButton;

@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, copy) NSString *selectedStr;
@property (nonatomic, assign) NSInteger selectIndex;

@end

@implementation PHPickerView

- (UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc] initWithFrame:self.frame];
        _bgView.backgroundColor = [UIColor clearColor];
        _bgView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickCancelAction)];
        [_bgView addGestureRecognizer:tap];
    }
    return _bgView;
}

- (UIView *)pickBgView{
    if (!_pickBgView) {
        _pickBgView = [[UIView alloc] initWithFrame:CGRectMake(0,kScreenSize.height - 300, kScreenSize.width , 300)];
        _pickBgView.backgroundColor = [UIColor clearColor];
    }
    return _pickBgView;
}

- (UIPickerView *)pickerView{
    if (!_pickerView) {
        _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 50, kScreenSize.width , 250)];
        _pickerView.delegate = self;
        _pickerView.dataSource = self;
    }
    return _pickerView;
}

- (UIVisualEffectView *)visualEffectView{
    if (!_visualEffectView) {
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        _visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        _visualEffectView.frame = _pickBgView.bounds;
    }
    return _visualEffectView;
}

- (UIView *)toolBar{
    if (!_toolBar) {
        _toolBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenSize.width , 50)];
        _toolBar.backgroundColor = [UIColor blackColor];
        [_toolBar addSubview:self.titleLabel];
    }
    return _toolBar;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenSize.width , 50)];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont systemFontOfSize:17];
    }
    return _titleLabel;
}

- (UIButton *)cancelButton{
    if (!_cancelButton) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelButton.frame = CGRectMake(15, 10, 60 , 30);
        _cancelButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelButton addTarget:self action:@selector(clickCancelAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}

- (UIButton *)confirmButton{
    if (!_confirmButton) {
        _confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _confirmButton.frame = CGRectMake(kScreenSize.width - 75, 10, 60 , 30);
        _confirmButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_confirmButton setTitle:@"确定" forState:UIControlStateNormal];
        [_confirmButton addTarget:self action:@selector(confirmAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmButton;
}


- (instancetype)initWithFrame:(CGRect)frame
{
    frame = [UIScreen mainScreen].bounds;
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.bgView];
        [self.bgView addSubview:self.pickBgView];
        [self.pickBgView addSubview:self.visualEffectView];
        [self.pickBgView addSubview:self.toolBar];
        [self.pickBgView addSubview:self.pickerView];
        [self.toolBar addSubview:self.cancelButton];
        [self.toolBar addSubview:self.confirmButton];
    }
    return self;
}

- (void)setTitle:(NSString *)title{
    _title = title;
    self.titleLabel.text = title;
}

- (void)setDataSource:(NSArray<NSString *> *)dataSource{
    _dataSource = dataSource;
    self.selectIndex = 0;
    self.selectedStr = dataSource.firstObject;
    [self.pickerView  reloadAllComponents];
}

- (void)show{
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [UIView animateWithDuration:0.25 animations:^{
        self.bgView.frame = CGRectMake(0, 0, kScreenSize.width , kScreenSize.height);
    } completion:^(BOOL finished) {
        [self.pickerView selectRow:self.selectIndex inComponent:0 animated:YES];
        [self.pickerView  reloadComponent:0];
        [self pickerView:self.pickerView didSelectRow:self.selectIndex inComponent:0];

    }];
}

- (void)clickCancelAction {
    [UIView animateWithDuration:0.25 animations:^{
        self.bgView.frame = CGRectMake(0, kScreenSize.height, kScreenSize.width , kScreenSize.height);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)confirmAction {
    [UIView animateWithDuration:0.25 animations:^{
        self.bgView.frame = CGRectMake(0, kScreenSize.height, kScreenSize.width , kScreenSize.height);
    } completion:^(BOOL finished) {
        !self.selectItemBlock? : self.selectItemBlock(self.selectIndex,self.selectedStr);
        [self removeFromSuperview];
    }];
}


#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return self.dataSource.count;
}

#pragma mark -  UIPickerViewDelegate
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return self.bounds.size.width;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 44;
}

//- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
//    return self.dataSource[row];
//}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view {
    UILabel *label = (UILabel *)view;
    if (!label) {
        label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenSize.width , 50)];
        label.backgroundColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:20];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor orangeColor];
        label.text = self.dataSource[row];
        view = label;
    }else{
        label.text = self.dataSource[row];
    }
    return view;
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.selectedStr = self.dataSource[row];
    self.selectIndex = row;
    UILabel *view = (UILabel *)[pickerView viewForRow:row forComponent:0];
    view.textColor = [UIColor redColor];
}


@end
