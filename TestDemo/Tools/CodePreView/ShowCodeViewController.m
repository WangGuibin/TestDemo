//
//  ShowCodeViewController.m
//
//  Created by 王贵彬 on 2022/9/20.
//

#import "ShowCodeViewController.h"
#import "HLJSTextView.h"
#import "PHPickerView.h"
#import "Masonry.h"

@interface ShowCodeViewController ()

@property (nonatomic, strong) PHPickerView *themePickerView;
@property (nonatomic,strong) HLJSTextView *textView;

@end

@implementation ShowCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"代码详情";
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 44 , 44);
    [button setTitle:@"Theme" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(changeTheme) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    HLJSTextView *textView = [[HLJSTextView alloc] initWithFrame:self.view.bounds];
    //禁用编辑和选中
    textView.editable = NO;
    textView.selectable = NO;
    textView.lineCursorEnabled = NO;
    textView.gutterLineColor = [UIColor redColor];
    textView.gutterBackgroundColor = [UIColor orangeColor];
    textView.language = self.language? : @"json";
    textView.theme = self.theme? : @"monokai-sublime";
    textView.text = self.codeText;
    [self.view addSubview:textView];
    self.textView = textView;
    [textView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
        } else {
            // Fallback on earlier versions
            make.top.equalTo(self.view.mas_top);
        }
        make.left.right.bottom.equalTo(self.view);
    }];
}

- (void)changeTheme{
    if (!self.themePickerView.dataSource.count) {
        HLJSTextStorage *storage = (HLJSTextStorage *)self.textView.textStorage;
        self.themePickerView.dataSource = [storage.highlighter availableThemes];        
    }
    [self.themePickerView show];
}

- (PHPickerView *)themePickerView{
    if (!_themePickerView) {
        _themePickerView = [[PHPickerView alloc] initWithFrame:CGRectZero];
        _themePickerView.title = @"选择代码主题";
        __weak typeof(self) weak_self = self;
        [_themePickerView setSelectItemBlock:^(NSInteger selectedIndex, NSString * _Nonnull selectedStr) {
            weak_self.textView.theme = selectedStr;
        }];
    }
    return _themePickerView;
}

@end
