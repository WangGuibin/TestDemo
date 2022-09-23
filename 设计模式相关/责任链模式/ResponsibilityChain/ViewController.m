//
//  ViewController.m
//  ResponsibilityChain
//
//  Created by neotvfbt on 2019/11/11.
//  Copyright © 2019 neotvfbt. All rights reserved.
//

#import "ViewController.h"
#import "DJQTextFiledTitleView.h"
#import "NSObject+ResponsibilityChain.h"
#import "ResponsibilityManager.h"
#import "DefiningTermChain.h"

#import "StaffObject.h"


@interface ViewController ()<UITextFieldDelegate>
@property (nonatomic, strong) ResponsibilityManager *responsibilityManager;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    StaffObject *person = [StaffObject new];
    [person sendLeaveRequest:2];
    [person sendLeaveRequest:3];
    [person sendLeaveRequest:4];
    [person sendLeaveRequest:7];
    [person sendLeaveRequest:8];
    [person sendLeaveRequest:30];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.responsibilityManager = [ResponsibilityManager new];
    [self setupDJQTextFiledWithTitle:@"姓名"
                                   y:220
                                text:@""
                         placeHolder:@"请输入姓名"
                         atIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]
                         modelDicKey:@"name"
                              bgView:self.view
                           isRequied:YES];
    
    [self setupDJQTextFiledWithTitle:@"手机号"
                                   y:290
                                text:@""
                         placeHolder:@"请输入手机号"
                         atIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]
                         modelDicKey:@"mobile"
                              bgView:self.view
                           isRequied:YES];
    
    UIButton *applyButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [applyButton setTitle:@"提交" forState:UIControlStateNormal];
    applyButton.frame = CGRectMake(20, 450, UIScreen.mainScreen.bounds.size.width - 40, 50);
    applyButton.backgroundColor = [UIColor redColor];
    [applyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:applyButton];
    [applyButton addTarget:self action:@selector(clickApply) forControlEvents:UIControlEventTouchUpInside];
    // Do any additional setup after loading the view.
}

- (void)clickApply {
    [self.view endEditing:YES];
    if (self.responsibilityManager.chains.count > 0 && [self.responsibilityManager checkResponsibilityChain].checkSuccess == NO) {
        NSLog(@"%@",[self.responsibilityManager checkResponsibilityChain].errorMessage);
//        [self showToastByMessage:[self.responsibilityManager checkResponsibilityChain].errorMessage];
        return;
    }
}

/** List列表，不是自定义项的*/
- (DJQTextFiledTitleView *)setupDJQTextFiledWithTitle:(NSString *)title
                                                    y:(NSInteger)y
                                                 text:(NSString *)text
                                          placeHolder:(NSString *)plachHolder
                                          atIndexPath:(NSIndexPath *)indexPath
                                          modelDicKey:(NSString *)modelDicKey
                                               bgView:(UIView *)bgView
                                            isRequied:(BOOL)isRequied;
{
    //
    //    if (indexPath.row == 0) {
    //        y = 35;
    //    }else {
    //        y = [(UIView *)bgView.subviews.lastObject bottom];
    //    }
    DJQTextFiledTitleView *fieldView    = [[DJQTextFiledTitleView alloc] initWithFrame:CGRectMake(20, y, UIScreen.mainScreen.bounds.size.width, 50.f)];
    fieldView.field.delegate            = self;
    fieldView.placeHolder               = plachHolder;
    fieldView.title                     = title;
    fieldView.field.text                = text;
    fieldView.indexPath                 = indexPath;
    fieldView.modelDicKey               = modelDicKey;
    
    if ([modelDicKey isEqualToString:@"idcard"]) {
        fieldView.field.keyboardType = UIKeyboardTypeASCIICapable;
    }else if ([modelDicKey isEqualToString:@"mobile"]||[modelDicKey isEqualToString:@"qq"]) {
        fieldView.field.keyboardType = UIKeyboardTypeNumberPad;
    }else {
        fieldView.field.keyboardType = UIKeyboardTypeDefault;
    }
    
    if (isRequied) {
        fieldView.responsibilityChain = [DefiningTermChain DefiningTermChainWithErrorMessage:title];
        [self.responsibilityManager addChain:fieldView];
    }
    [bgView addSubview:fieldView];
    return fieldView;
}


@end
