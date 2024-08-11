//
//  WGBFileSelectManager.m

//
//  Created by 王贵彬  on 2023/5/10.
//

#import "WGBFileSelectManager.h"

@interface WGBFileSelectManager ()<UIDocumentPickerDelegate>

@end

@implementation WGBFileSelectManager

static WGBFileSelectManager *_tool = nil;
+ (WGBFileSelectManager *)shareInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _tool = [[WGBFileSelectManager alloc] init];
    });
    return _tool;
}

///弹出选择文件面板
- (void)showFilePanel{
//https://developer.apple.com/library/archive/documentation/Miscellaneous/Reference/UTIRef/Articles/System-DeclaredUniformTypeIdentifiers.html

    NSArray *types = @[
        @"public.content",
        @"public.text",
        @"public.plain-text",
        @"public.mpeg-4",
        @"public.avi",
        @"public.3gpp",
        @"public.source-code",
        @"public.image",
        @"public.png",
        @"public.jpeg",
        @"com.compuserve.gif",
        @"public.audio",
        @"public.movie",
        @"public.audiovisual-content",
        @"com.adobe.pdf",
        @"com.apple.keynote.key",
        @"com.microsoft.word.doc",
        @"com.microsoft.word.docx",
        @"com.microsoft.excel.xls",
        @"com.microsoft.excel.xlsx",
        @"com.microsoft.powerpoint.ppt",
        @"com.microsoft.powerpoint.pptx",
    ];
    //此为导入到沙盒 然后再去操作沙盒里的数据
    UIDocumentPickerViewController *documentPicker = [[UIDocumentPickerViewController alloc] initWithDocumentTypes:types inMode:UIDocumentPickerModeImport];
    documentPicker.delegate = self;
    documentPicker.allowsMultipleSelection = false;
    documentPicker.shouldShowFileExtensions = true;

    [self.wgb_optimizedVisibleViewController presentViewController:documentPicker animated:YES completion:nil];
}

//ios 11+
- (void)documentPicker:(UIDocumentPickerViewController *)controller didPickDocumentsAtURLs:(NSArray <NSURL *>*)urls{
    NSURL *targerURL = urls.firstObject;
    if(!targerURL){
        return;
    }
    //将目标文件拷贝到沙盒
    NSString *documentDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    if(self.workSpaceDirName){
        documentDirectory = [documentDirectory stringByAppendingPathComponent:self.workSpaceDirName];
        if(![[NSFileManager defaultManager] fileExistsAtPath:documentDirectory]){
            [[NSFileManager defaultManager] createDirectoryAtPath:documentDirectory withIntermediateDirectories:YES attributes:nil error:nil];
        }
    }
    NSString *filePath = [documentDirectory stringByAppendingPathComponent:targerURL.lastPathComponent];
    if([[NSFileManager defaultManager] fileExistsAtPath:filePath]){
        [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
    }
    [[NSFileManager defaultManager] copyItemAtURL:targerURL toURL:[NSURL fileURLWithPath:filePath] error:nil];
    !self.selectFileBlock? : self.selectFileBlock(filePath);
}


//找到顶层的控制器
- (UIViewController *)wgb_optimizedVisibleViewController
{
    return [self wgb_visibleViewControllerWithRootViewController:[UIApplication sharedApplication].keyWindow.rootViewController];
}

- (UIViewController *)wgb_visibleViewControllerWithRootViewController:(UIViewController*)rootViewController
{
    if ([rootViewController isKindOfClass:[UITabBarController class]])
    {
        UITabBarController *tbc = (UITabBarController*)rootViewController;
        return [self wgb_visibleViewControllerWithRootViewController:tbc.selectedViewController];
    }
    else if ([rootViewController isKindOfClass:[UINavigationController class]])
    {
        UINavigationController *nvc = (UINavigationController*)rootViewController;
        return [self wgb_visibleViewControllerWithRootViewController:nvc.visibleViewController];
    }
    else if (rootViewController.presentedViewController)
    {
        UIViewController *presentedVC = rootViewController.presentedViewController;
        return [self wgb_visibleViewControllerWithRootViewController:presentedVC];
    }
    else
    {
        return rootViewController;
    }
}

@end
