//
//  ViewController.m
//  ChartsFont
//
//  Created by 王贵彬 on 2021/1/3.
//

#import "ViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UILabel *textLabel;
@property (nonatomic, strong) NSMutableString *strM;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
// 1D400–1D7FF
//基于微信小程序神奇字体的实现方案 https://github.com/wind-liang/unicode
//参考文档 https://www.unicode.org/charts/PDF/U1D400.pdf
    
    NSMutableString *strM = [NSMutableString stringWithCapacity:1023];
    self.strM = strM;
    
//    for (int i = 0x1D400; i <= 0x1D7FF; i++) {
//        NSString *hexString = [NSString stringWithFormat:@"0x%x",i];
//        NSInteger hex = [self numberWithHexString:hexString];
//        NSString *unicodeString = [[NSString alloc] initWithBytes:&hex length:sizeof(hex) encoding:NSUTF32LittleEndianStringEncoding];
//        [strM appendFormat:@"%@", unicodeString];
//    }
//    self.textLabel.text = strM;
    
    [self getUnicodeWithStartIndex:0x1D400 endInex:0x1D419];
    [self getUnicodeWithStartIndex:0x1D41A endInex:0x1D433];
    
    [self getUnicodeWithStartIndex:0x1D434 endInex:0x1D44D];
    [self getUnicodeWithStartIndex:0x1D44E endInex:0x1D467];
    
    [self getUnicodeWithStartIndex:0x1D468 endInex:0x1D481];
    [self getUnicodeWithStartIndex:0x1D482 endInex:0x1D49B];
    
    [self getUnicodeWithStartIndex:0x1D49C endInex:0x1D4B5];
    [self getUnicodeWithStartIndex:0x1D4B6 endInex:0x1D4CF];
    
    [self getUnicodeWithStartIndex:0x1D4D0 endInex:0x1D4E9];
    [self getUnicodeWithStartIndex:0x1D4EA endInex:0x1D503];
    
    [self getUnicodeWithStartIndex:0x1D504 endInex:0x1D51D];
    [self getUnicodeWithStartIndex:0x1D51E endInex:0x1D537];
    
    [self getUnicodeWithStartIndex:0x1D538 endInex:0x1D551];
    [self getUnicodeWithStartIndex:0x1D552 endInex:0x1D56B];
    
    [self getUnicodeWithStartIndex:0x1D56C endInex:0x1D585];
    [self getUnicodeWithStartIndex:0x1D586 endInex:0x1D59F];
    
    [self getUnicodeWithStartIndex:0x1D5A0 endInex:0x1D5B9];
    [self getUnicodeWithStartIndex:0x1D5BA endInex:0x1D5D3];
    
    [self getUnicodeWithStartIndex:0x1D5D4 endInex:0x1D5ED];
    [self getUnicodeWithStartIndex:0x1D5EE endInex:0x1D607];
    
    [self getUnicodeWithStartIndex:0x1D608 endInex:0x1D621];
    [self getUnicodeWithStartIndex:0x1D622 endInex:0x1D63B];

    [self getUnicodeWithStartIndex:0x1D63C endInex:0x1D655];
    [self getUnicodeWithStartIndex:0x1D656 endInex:0x1D66F];
    
    [self getUnicodeWithStartIndex:0x1D670 endInex:0x1D689];
    [self getUnicodeWithStartIndex:0x1D68A endInex:0x1D6A5];
    
    [self getUnicodeWithStartIndex:0x1D6A8 endInex:0x1D6FB];
    [self getUnicodeWithStartIndex:0x1D6FC endInex:0x1D71B];
    
    [self getUnicodeWithStartIndex:0x1D71C endInex:0x1D7D7];
    
    //数字
    [self getUnicodeWithStartIndex:0x1D7D8 endInex:0x1D7E1];
    [self getUnicodeWithStartIndex:0x1D7E2 endInex:0x1D7EB];
    [self getUnicodeWithStartIndex:0x1D7EC endInex:0x1D7F5];
    [self getUnicodeWithStartIndex:0x1D7F6 endInex:0x1D7FF];

    
    self.textLabel.text = strM;
}

- (void)getUnicodeWithStartIndex:(NSInteger)startIndex endInex:(NSInteger)endIndex{
    for (NSInteger i = startIndex; i <= endIndex; i++) {
        NSString *hexString = [NSString stringWithFormat:@"0x%lx",(long)i];
        NSInteger hex = [self numberWithHexString:hexString];
        NSString *unicodeString = [[NSString alloc] initWithBytes:&hex length:sizeof(hex) encoding:NSUTF32LittleEndianStringEncoding];
        [self.strM appendFormat:@"%@", unicodeString];
    }
    [self.strM appendFormat:@"\n"];
}


- (NSInteger)numberWithHexString:(NSString *)hexString{
    const char *hexChar = [hexString cStringUsingEncoding:NSUTF8StringEncoding];
    int hexNumber;
    sscanf(hexChar, "%x", &hexNumber);
    return (NSInteger)hexNumber;
}

@end
