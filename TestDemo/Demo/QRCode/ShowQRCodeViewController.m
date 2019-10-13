//
//  ShowQRCodeViewController.m
//  TestDemo
//
//  Created by mac on 2019/10/12.
//  Copyright © 2019 mac. All rights reserved.
//

#import "ShowQRCodeViewController.h"
#import "JPQRCodeTool.h"
#import <YSQRCodeGenerator.h>

@interface ShowQRCodeViewController ()

@end

@implementation ShowQRCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UIImageView *QRCodeImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self.view addSubview: QRCodeImageView];
    QRCodeImageView.translatesAutoresizingMaskIntoConstraints = NO;
    [QRCodeImageView.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor].active = YES;
    [QRCodeImageView.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor].active = YES;
    [QRCodeImageView.widthAnchor constraintEqualToConstant:300].active = YES;
    [QRCodeImageView.heightAnchor constraintEqualToConstant:300].active = YES;
    
    switch (self.style) {
        case ShowQRCodeStyleNormal:
        {
            YSQRCodeGenerator *generator = [YSQRCodeGenerator new];
            generator.content = @"123123";
            [generator setColorWithBackColor:[UIColor whiteColor] foregroundColor:[UIColor blackColor]];
            UIImage *image = [generator generate];
            QRCodeImageView.image =  image;
        }
            break;
        case ShowQRCodeStyleIconBg:
        {
            YSQRCodeGenerator *generator = [YSQRCodeGenerator new];
            generator.content = @"123123";
            [generator setColorWithBackColor:[UIColor whiteColor] foregroundColor:[UIColor blackColor]];
            generator.watermark = [UIImage imageNamed:@"Miku.jpg"];
            generator.watermarkMode = UIViewContentModeScaleAspectFill;
            generator.icon = [UIImage imageNamed:@"github"];
            generator.iconSize = CGSizeMake(40, 40);
            UIImage *image = [generator generate];
            QRCodeImageView.image =  image;
        }
            break;
        case ShowQRCodeStyleGIFBg:
        {
            YSQRCodeGenerator *generator = [YSQRCodeGenerator new];
            generator.content = @"123123";
            [generator setColorWithBackColor:[UIColor whiteColor] foregroundColor:[UIColor blackColor]];
            UIImage *image = [generator generateWithGIFCodeWithGIFNamed:@"74766_811947_358458"];
            QRCodeImageView.image =  image;
        }
            break;
        case ShowQRCodeStyleJPQRTool:
        {
            QRCodeImageView.image = [JPQRCodeTool generateCodeForString:@"花式二维码示例" withCorrectionLevel:(kQRCodeCorrectionLevelHight) SizeType:(kQRCodeSizeTypeBig) customSizeDelta:5 drawType:(kQRCodeDrawTypeCircle) gradientType:(kQRCodeGradientTypeDiagonal) gradientColors:@[[UIColor redColor],[UIColor orangeColor],[UIColor purpleColor],[UIColor blueColor],[UIColor yellowColor],[UIColor cyanColor]]];
        }
            break;

        default:
            break;
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
