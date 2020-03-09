//
//  ViewController.m
//  TestAES128
//
//  Created by mac on 2020/1/11.
//  Copyright © 2020 mac. All rights reserved.
//

#import "ViewController.h"
#import "NSData+WGBEncryption.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    http://tool.chacuo.net/cryptaes  何不在线工具调试一番?
    // Do any additional setup after loading the view.
    NSString *key = @"ffffffff66666666";
    NSString *iv = @"6666ffffeeeedddd";
    
    NSData *originData = [@"世界，你好！" dataUsingEncoding:NSUTF8StringEncoding];
    //加密
    NSData *encryData = [originData AES128ParmEncryptWithKey:key iv:iv];
    //转16进制
    NSString *hexStr = [self convertDataToHexStr:encryData];
    NSLog(@"%@",hexStr);
    
    //因为AES128加密的密文是先转成16进制的 所以要先转回NSData
    NSData *data = [self convertHexStrToData:hexStr];
    //解密
    NSData *tempData = [data AES128ParmDecryptWithKey:key iv:iv];
    //转字符串
    NSLog(@"%@",[[NSString alloc] initWithData:tempData encoding:NSUTF8StringEncoding]);
}


// NSData转16进制
- (NSString *)convertDataToHexStr:(NSData *)data
{
    if (!data || [data length] == 0) {
        return @"";
    }
    NSMutableString *string = [[NSMutableString alloc] initWithCapacity:[data length]];
    
    [data enumerateByteRangesUsingBlock:^(const void *bytes, NSRange byteRange, BOOL *stop) {
        unsigned char *dataBytes = (unsigned char*)bytes;
        for (NSInteger i = 0; i < byteRange.length; i++) {
            NSString *hexStr = [NSString stringWithFormat:@"%x", (dataBytes[i]) & 0xff];
            if ([hexStr length] == 2) {
                [string appendString:hexStr];
            } else {
                [string appendFormat:@"0%@", hexStr];
            }
        }
    }];
    return string;
}


// 16进制转NSData
- (NSData *)convertHexStrToData:(NSString *)str
{
    if (!str || [str length] == 0) {
        return nil;
    }
    
    NSMutableData *hexData = [[NSMutableData alloc] initWithCapacity:20];
    NSRange range;
    if ([str length] % 2 == 0) {
        range = NSMakeRange(0, 2);
    } else {
        range = NSMakeRange(0, 1);
    }
    for (NSInteger i = range.location; i < [str length]; i += 2) {
        unsigned int anInt;
        NSString *hexCharStr = [str substringWithRange:range];
        NSScanner *scanner = [[NSScanner alloc] initWithString:hexCharStr];
        
        [scanner scanHexInt:&anInt];
        NSData *entity = [[NSData alloc] initWithBytes:&anInt length:1];
        [hexData appendData:entity];
        
        range.location += range.length;
        range.length = 2;
    }
    return hexData;
}


@end
