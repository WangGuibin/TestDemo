//
//  ViewController.m
//  WGBLogBackupManager
//
//  Created by 王贵彬 on 2021/1/28.
//

#import "ViewController.h"
#import "WGBLogBackupManager.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    WGBLog(@"⚠️hahah");
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    WGBLog(@"hahh😃哈啊哈哈😃%@",[NSDate date]);
}

@end
