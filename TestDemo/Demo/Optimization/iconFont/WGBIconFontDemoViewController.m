//
// WGBIconFontDemoViewController.m
// TestDemo
//
// Author:  @CoderWGB
// Github:  https://github.com/WangGuibin/TestDemo
// E-mail:  864562082@qq.com
//
// Created by CoderWGB on 2019/12/24
//
/**
Copyright (c) 2019 Wangguibin  

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
*/
    

#import "WGBIconFontDemoViewController.h"
#import "TBCityIconFont.h"
#import "UIImage+TBCityIconFont.h"
#import "WGBUnicodeTransformTool.h"

/**
   参考 https://juejin.im/post/5ac4899d6fb9a028d3759e7a
    1. 在 https://www.iconfont.cn/ 选择想要的图标到购物车 最后点击购物车里面的下载代码按钮
    2. 把下载下来的`.ttf`文件拖入项目里使用,info.plist填入`Fonts provided by application`字段值`iconfont.ttf`
    3. 使用淘点点科技写的一个关于iconfont封装`TBCityIconFont`,项目启动的时候初始化(application:didFinishLaunchingWithOptions:里实现):
 @code
    [TBCityIconFont setFontName:@"iconfont"];
 @endcode
 4. 打开下载下来的`demo_index.html`里面有一个列表可以看到图标和对应的编码
 编码 `&#xe6eb` 格式的转换为Unicode编码格式 保留后4位，前面用0补齐8位。如  \U0000e6eb
 (始终觉得查表还有手动转 很麻烦)
 
 */

@interface WGBIconFontDemoViewController ()

@property (nonatomic,strong) NSArray *unicodeArray;
@property (nonatomic, strong) NSMutableArray *iconFontCodeArray;
@end

@implementation WGBIconFontDemoViewController

- (NSArray *)unicodeArray{
    if (!_unicodeArray) {
        _unicodeArray = @[
            @"\U0000e624",@"\U0000e71e",@"\U0000e622",@"\U0000e64f",@"\U0000e66b",@"\U0000e857",
            @"\U0000e644",@"\U0000e610",@"\U0000e612",@"\U0000e65b",@"\U0000e729",@"\U0000e616",
            @"\U0000e613",@"\U0000e627",@"\U0000e681",@"\U0000e668",@"\U0000e60f",@"\U0000e61d",
            @"\U0000e859",@"\U0000e615",@"\U0000e652",@"\U0000e618",@"\U0000e63f",@"\U0000e672",
            @"\U0000e607",@"\U0000e614",@"\U0000e684",@"\U0000e628",@"\U0000e63e",@"\U000f0060"
        ];
    }
    return _unicodeArray;
}



// 打印所有的字体名
//static void dumpAllFonts() {
//    for (NSString *familyName in [UIFont familyNames]) {
//        for (NSString *fontName in [UIFont fontNamesForFamilyName:familyName]) {
//            NSLog(@"%@", fontName);
//        }
//    }
//}

/// 本来计划使用json文件读取 以拼接的形式来展示的 但是效果不理想 字符串确实是那个字符串 好像并不是unicode 使用语法糖或者直接写一个完整的 `\U0000e789`就可以
- (void)getIconFonts{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"iconfontData.json" ofType:nil];
    NSString *content = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:[content dataUsingEncoding:NSUTF8StringEncoding] options:(NSJSONReadingMutableContainers) error:nil];
    for (NSDictionary *iconFontDic in dict[@"glyphs"]) {
        NSString *suffix = iconFontDic[@"unicode"];
        NSString *code = [WGBUnicodeTransformTool utf8ToUnicode:suffix];
        [self.iconFontCodeArray addObject: code];
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
//    [self getIconFonts];
//    dumpAllFonts();
    //图标编码是&#xe600，需要转成\U0000e600  &#xf0060 => \U000f0060
    //&#xe64f => \U0000e0064
     //#xe668 => \U000e0668
//    NSString *str = @"#xe600";
//    NSString *outPutStr = [WGBUnicodeTransformTool utf8ToUnicode:str];
//    NSLog(@"%@",outPutStr);

    NSInteger totalColumns = 5; //总共多少列
    NSInteger totalCount = self.unicodeArray.count;
    NSInteger margin  = 40.0f;
    CGFloat itemW = (KWIDTH - margin*6) / 5.0f;
    CGFloat itemH = itemW;
    
    for (NSInteger i = 0; i < totalCount; i++) {
        NSInteger row = i / totalColumns;
        NSInteger column = i % totalColumns;
        CGFloat itemX = margin + column * (itemW + margin);
        CGFloat itemY = row * (itemH + margin) + 100;
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        imageView.frame = CGRectMake(itemX, itemY, itemW , itemH);
        CGFloat hue = ( arc4random() % 256 / 256.0 );
        CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;
        CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;
        UIColor *ranColor = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
        imageView.image = [UIImage iconWithInfo:TBCityIconInfoMake(self.unicodeArray[i], itemW, ranColor)];
         [self.view addSubview:imageView];
    }
}


- (NSMutableArray *)iconFontCodeArray {
    if (!_iconFontCodeArray) {
        _iconFontCodeArray = [[NSMutableArray alloc] init];
    }
    return _iconFontCodeArray;
}

/**
 @code
 UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(100, 100, 30, 30)];
 [self.view addSubview:imageView];
 //图标编码是&#xe600，需要转成\U0000e600
 imageView.image = [UIImage iconWithInfo:TBCityIconInfoMake(@"\U0000e600", 30, [UIColor redColor])];
 
 
 //    button
 UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
 button.frame = CGRectMake(100, 150, 40, 40);
 [self.view addSubview:button];
 [button setImage:[UIImage iconWithInfo:TBCityIconInfoMake(@"\U0000e614", 40, [UIColor redColor])] forState:UIControlStateNormal];
 
 //    label,label可以将文字与图标结合一起，直接用label的text属性将图标显示出来
 UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(50, 200, 280, 40)];
 [self.view addSubview:label];
 label.font = [UIFont fontWithName:@"iconfont" size:15];//设置label的字体
 label.text = @"在lable上显示  \U0000e658";
 
 @endcode
 */
@end
