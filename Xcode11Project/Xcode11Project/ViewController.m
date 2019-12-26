//
//  ViewController.m
//  Xcode11Project
//
//  Created by mac on 2019/12/26.
//  Copyright © 2019 mac. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    CGFloat hue = ( arc4random() % 256 / 256.0 );
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;
    UIColor *ranColor = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
    self.view.backgroundColor = ranColor;
    self.navigationItem.title = @"Next";
}


@end
