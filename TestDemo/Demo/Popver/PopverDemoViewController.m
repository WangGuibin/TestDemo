//
//  PopverDemoViewController.m
//  TestDemo
//
//  Created by mac on 2019/10/25.
//  Copyright © 2019 mac. All rights reserved.
//

#import "PopverDemoViewController.h"
#import "TestPopverContentViewController.h"


@interface PopverDemoViewController ()<UIPopoverPresentationControllerDelegate>

@end

@implementation PopverDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(100, 100, 200 , 50);
    button.backgroundColor = [UIColor blackColor];
    [button setTitle:@"Test" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(clickButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview: button];
}

- (void)clickButtonAction:(UIButton *)sender{
    TestPopverContentViewController *contentVC = [[TestPopverContentViewController alloc] init];
    contentVC.modalPresentationStyle = UIModalPresentationPopover;
    
    UIPopoverPresentationController *popVC = contentVC.popoverPresentationController;
    popVC.sourceView = sender;
    popVC.sourceRect = sender.bounds;
    popVC.permittedArrowDirections = UIPopoverArrowDirectionAny;
    popVC.delegate = self;
    popVC.backgroundColor = [UIColor blackColor];
    [self presentViewController:contentVC animated:YES completion:^{
        
    }];
    
}

#pragma mark - UIPopoverPresentationControllerDelegate
- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller {
  return UIModalPresentationNone;
}

@end
