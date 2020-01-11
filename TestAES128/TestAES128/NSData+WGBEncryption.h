//
//  NSData+WGBEncryption.h
//  TestAES128
//
//  Created by mac on 2020/1/11.
//  Copyright © 2020 mac. All rights reserved.
//



#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSData (WGBEncryption)

//aes128加密
- (NSData *)AES128ParmEncryptWithKey:(NSString *)key iv:(NSString *)iv;

//解密
- (NSData *)AES128ParmDecryptWithKey:(NSString *)key iv:(NSString *)iv;


@end

NS_ASSUME_NONNULL_END
