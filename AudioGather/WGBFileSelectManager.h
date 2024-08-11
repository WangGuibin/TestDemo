//
//  WGBFileSelectManager.h

//
//  Created by 王贵彬  on 2023/5/10.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WGBFileSelectManager : NSObject

+ (WGBFileSelectManager *)shareInstance;

@property (nonatomic,copy) NSString *workSpaceDirName; //默认放到document下 此为目录名 为空则放在根目录下

///弹出选择文件面板
- (void)showFilePanel;

///回调选择的文件路径 然后可以拿到文件路径进行处理
@property (nonatomic,copy) void(^selectFileBlock)(NSString *filePath);

//顶层的控制器
- (UIViewController *)wgb_optimizedVisibleViewController;

@end

NS_ASSUME_NONNULL_END
