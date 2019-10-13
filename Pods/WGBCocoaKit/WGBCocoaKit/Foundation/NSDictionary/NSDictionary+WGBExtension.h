//
//  NSDictionary+WGBExtension.h
//  WGBCocoaKit
//
//  Created by CoderWGB on 2018/8/10.
//  Copyright © 2018年 CoderWGB. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (WGBExtension)
//https://segmentfault.com/q/1010000000576646  已去除转换json字符串后的转义符
/// MARK:- 字典转json
- (NSString *)jsonString;

///MARK:-  扁平的json 也就是不换行的那种(一般用于传参) 类似于:
/**
 {"code":8000,"msg":"操作成功","body":[{"saLogo":"https:\/\/www.dfs.smart0.cn\/group1\/M00\/00\/3F\/Ch9MHVmlHreEeQhyAAAAAKtQq4w281.jpg","tid":"59a51ef07cf9b62e2ee27595","synopsis":"https:\/\/www.dfs.smart0.cn\/group1\/M00\/01\/00\/Ch9MHVol_J6EJGM1AAAAAN5KPdo44.html","playCount":7620,"position":[113.982618,22.549911999999999],"saName":"深圳华侨城","dist":"2.7km","province":"广东省","star":5,"zoomLevel":14,"address":"深圳市南山区华侨城","city":"深圳市","county":"南山区","areas":[{"lngLats":[[113.973707,22.55592],[114.004177,22.55592],[114.004177,22.533622000000001],[113.973707,22.533622000000001],[113.973707,22.55592]],"saId":"59a51ef07cf9b62e2ee27595","tid":"59a51ef07cf9b62e2ee27594"}],"language":"zh","country":"中国","continents":"亚洲","saCode":440305}
 */
- (NSString *)flatJsonString ;

// 字典转二进制
- (NSData *)toData;

@end
