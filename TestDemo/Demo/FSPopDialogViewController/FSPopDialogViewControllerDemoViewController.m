//
//  FSPopDialogViewControllerDemoViewController.m
//  TestDemo
//
//  Created by mac on 2019/10/17.
//  Copyright © 2019 mac. All rights reserved.
//

#import "FSPopDialogViewControllerDemoViewController.h"
#import "FSPopDialogViewController.h"

@interface FSPopDialogViewControllerDemoViewController ()<FSPopDialogProtocol>

@property (nonatomic, strong) FSPopDialogViewController *popDialog;

@end

@implementation FSPopDialogViewControllerDemoViewController

- (FSPopDialogViewController*)popDialog
{
    if (!_popDialog)
    {
        _popDialog = [[FSPopDialogViewController alloc] init];
        _popDialog.delegate = self;
    }
    return _popDialog;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    NSMutableArray *buttons = [NSMutableArray array];
    NSArray *titles = @[@"FSPopDialogStylePop",@"FSPopDialogStyleFromBottom",@"FSPopDialogStyleFromTop",@"FSPopDialogStyleFromLeft",@"FSPopDialogStyleFromRight"];
    for (NSInteger i = 0; i < 5; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.backgroundColor = [UIColor colorWithRed:arc4random()%256/255.0f green:arc4random()%256/255.0f  blue:arc4random()%256/255.0f alpha:1.0f];
        button.tag = i;
        [button setTitle: titles[i] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(clickButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview: button];
        [buttons addObject: button];
    }
    
    //Masonry九宫格布局
    [buttons mas_distributeSudokuViewsWithFixedLineSpacing:10 fixedInteritemSpacing:0 warpCount:1 topSpacing:100 bottomSpacing:30 leadSpacing:10 tailSpacing:10];
    
}


- (void)showPopDialog
{
    self.popDialog.size = CGSizeMake(300, 400);
    self.popDialog.dialogViewTitle = @"Is it OK?";
    self.popDialog.question = @"厉害厉害 牛逼 666。厉害厉害 牛逼 666厉害厉害 牛逼 666厉害厉害 牛逼 666厉害厉害 牛逼 666厉害厉害 牛逼 666厉害厉害 牛逼 666厉害厉害 牛逼 666厉害厉害 牛逼 666厉害厉害 牛逼 666厉害厉害 牛逼 666厉害厉害 牛逼 666厉害厉害 牛逼 666厉害厉害 牛逼 666厉害厉害 牛逼 666厉害厉害 牛逼 666厉害厉害 牛逼 666厉害厉害 牛逼 666厉害厉害 牛逼 666厉害厉害 牛逼 666厉害厉害 牛逼 666厉害厉害 牛逼 666厉害厉害 牛逼 666";
    self.popDialog.okButtonTitle = @"好的好的";
    self.popDialog.cancelButtonTitle = @"不了不了";
    @weakify(self);
    self.popDialog.okBlock = ^{
        @strongify(self);
        [self.popDialog disappear];
        
    };
    self.popDialog.cancelBlock = ^{
        @strongify(self);
        [self.popDialog disappear];
        
    };
    [self.popDialog appear];
}


- (void)clickButtonAction:(UIButton *)sender{
    switch (sender.tag) {
        case 0:
            {
                self.popDialog.popDialogStyle = FSPopDialogStylePop;
                self.popDialog.disappearDialogStyle = FSPopDialogStylePop;
                [self showPopDialog];

            }
            break;
        case 1:
        {
            self.popDialog.popDialogStyle = FSPopDialogStyleFromBottom;
            self.popDialog.disappearDialogStyle = FSPopDialogStyleFromBottom;
            [self showPopDialog];

        }
            break;
        case 2:
        {
            self.popDialog.popDialogStyle = FSPopDialogStyleFromTop;
            self.popDialog.disappearDialogStyle = FSPopDialogStyleFromTop;
            [self showPopDialog];

        }
            break;
        case 3:
        {
            self.popDialog.popDialogStyle = FSPopDialogStyleFromLeft;
            self.popDialog.disappearDialogStyle = FSPopDialogStyleFromLeft;
            [self showPopDialog];

        }
            break;
        case 4:
        {
            self.popDialog.popDialogStyle = FSPopDialogStyleFromRight;
            self.popDialog.disappearDialogStyle = FSPopDialogStyleFromRight;
            [self showPopDialog];
            
        }
            break;

        default:
            break;
    }
    
    
    
}


@end
