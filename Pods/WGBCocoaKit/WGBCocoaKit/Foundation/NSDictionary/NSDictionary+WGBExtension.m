//
//  NSDictionary+WGBExtension.m
//  WGBCocoaKit
//
//  Created by CoderWGB on 2018/8/10.
//  Copyright © 2018年 CoderWGB. All rights reserved.
//

#import "NSDictionary+WGBExtension.h"

@implementation NSDictionary (WGBExtension)
/// MARK:- 字典转json (普通的展开的json格式)
- (NSString *)jsonString{
    NSString *jsonStr = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject: self options:NSJSONWritingPrettyPrinted error:nil] encoding:NSUTF8StringEncoding];
    //NSJSONSerialization converts a URL string from http://... to http:\/\/... remove the extra escapes 处理转义问题  字典通过NSJSONSerialization转换会多加很多转义符号
    jsonStr = [jsonStr stringByReplacingOccurrencesOfString:@"\\/" withString:@"/"];
    
    return jsonStr;
}

///MARK:-  扁平的json 也就是不换行的那种(一般用于传参) 类似于:
/**
 {"code":8000,"msg":"操作成功","body":[{"saLogo":"https:\/\/www.dfs.smart0.cn\/group1\/M00\/00\/3F\/Ch9MHVmlHreEeQhyAAAAAKtQq4w281.jpg","tid":"59a51ef07cf9b62e2ee27595","synopsis":"https:\/\/www.dfs.smart0.cn\/group1\/M00\/01\/00\/Ch9MHVol_J6EJGM1AAAAAN5KPdo44.html","playCount":7620,"position":[113.982618,22.549911999999999],"saName":"深圳华侨城","dist":"2.7km","province":"广东省","star":5,"zoomLevel":14,"address":"深圳市南山区华侨城","city":"深圳市","county":"南山区","areas":[{"lngLats":[[113.973707,22.55592],[114.004177,22.55592],[114.004177,22.533622000000001],[113.973707,22.533622000000001],[113.973707,22.55592]],"saId":"59a51ef07cf9b62e2ee27595","tid":"59a51ef07cf9b62e2ee27594"}],"language":"zh","country":"中国","continents":"亚洲","saCode":440305}
 */
- (NSString *)flatJsonString{
    NSString *flatJsonStr = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject: self options:kNilOptions error:nil] encoding:NSUTF8StringEncoding];
    flatJsonStr = [flatJsonStr stringByReplacingOccurrencesOfString:@"\\/" withString:@"/"];
    return flatJsonStr;
}

// 字典转二进制
- (NSData *)toData{
    NSData *data = [NSJSONSerialization dataWithJSONObject: self options:kNilOptions error:nil];
    return data;
}

@end
