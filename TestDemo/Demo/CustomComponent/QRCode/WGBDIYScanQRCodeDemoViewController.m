//
// WGBDIYScanQRCodeDemoViewController.m
// TestDemo
//
// Author:  @CoderWGB
// Github:  https://github.com/WangGuibin/TestDemo
// E-mail:  864562082@qq.com
//
// Created by CoderWGB on 2019/11/25
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
    

#import "WGBDIYScanQRCodeDemoViewController.h"
#import "DIYScanViewController.h"
#import "ScanResultViewController.h"
#import <LBXScanViewStyle.h>
#import <ZXingWrapper.h>
#import <AVFoundation/AVFoundation.h>

@interface WGBDIYScanQRCodeDemoViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@end

@implementation WGBDIYScanQRCodeDemoViewController

- (NSArray *)demoTitleArray{
    return @[
        @"模仿微信扫码",
        @"相册选择识别"
    ];
}

- (LBXScanViewStyle*)weixinStyle
{
    //设置扫码区域参数
    LBXScanViewStyle *style = [[LBXScanViewStyle alloc]init];
    
    style.centerUpOffset = 44;
    style.photoframeAngleStyle = LBXScanViewPhotoframeAngleStyle_Inner;
    style.photoframeLineW = 2;
    style.photoframeAngleW = 18;
    style.photoframeAngleH = 18;
    style.isNeedShowRetangle = YES;
    style.anmiationStyle = LBXScanViewAnimationStyle_LineMove;
    style.colorAngle = [UIColor colorWithRed:0./255 green:200./255. blue:20./255. alpha:1.0];
    
    //qq里面的线条图片
    UIImage *imgLine = [UIImage imageNamed:@"qrcode_Scan_weixin_Line"];
    style.animationImage = imgLine;
    style.notRecoginitonArea = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
    return style;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self.tableView reloadData];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *title = self.demoTitleArray[indexPath.row];
    __weak __typeof(self) weakSelf = self;
    if ([title isEqualToString:@"模仿微信扫码"]) {
        [LBXPermission authorizeWithType:LBXPermissionType_Camera completion:^(BOOL granted, BOOL firstTime) {
            if (granted) {
                [weakSelf skipWeixinScan];
            }else if(!firstTime){
                [LBXPermissionSetting showAlertToDislayPrivacySettingWithTitle:@"提示" msg:@"没有相机权限，是否前往设置" cancel:@"取消" setting:@"设置" ];
            }
        }];
        
    }else if ([title isEqualToString:@"相册选择识别"]){
        [self openLocalPhotoAlbum];
    }
}

- (void)skipWeixinScan{
    DIYScanViewController *vc = [DIYScanViewController new];
    vc.navigationItem.title = @"模仿微信扫码";
    vc.style = [self weixinStyle];
    vc.isOpenInterestRect = YES;
    vc.libraryType = SLT_ZXing;
    vc.scanCodeType = SCT_BarCode128;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)openLocalPhotoAlbum{
    __weak __typeof(self) weakSelf = self;
    [LBXPermission authorizeWithType:LBXPermissionType_Photos completion:^(BOOL granted, BOOL firstTime) {
        if (granted) {
            [weakSelf openLocalPhoto];
        }
        else if (!firstTime )
        {
            [LBXPermissionSetting showAlertToDislayPrivacySettingWithTitle:@"提示" msg:@"没有相册权限，是否前往设置" cancel:@"取消" setting:@"设置"];
        }
    }];
}

/*!
 *  打开本地照片，选择图片识别
 */
- (void)openLocalPhoto{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    picker.delegate = self;
    
    //部分机型可能导致崩溃
    picker.allowsEditing = YES;
    
    [self presentViewController:picker animated:YES completion:nil];
}

//当选择一张图片后进入这里

-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    __block UIImage* image = [info objectForKey:UIImagePickerControllerEditedImage];
    
    if (!image){
        image = [info objectForKey:UIImagePickerControllerOriginalImage];
    }
    
    __weak __typeof(self) weakSelf = self;
    [ZXingWrapper recognizeImage:image block:^(ZXBarcodeFormat barcodeFormat, NSString *str) {
        LBXScanResult *result = [[LBXScanResult alloc]init];
        result.strScanned = str;
        result.imgScanned = image;
        result.strBarCodeType = [self convertZXBarcodeFormat:barcodeFormat];
        [weakSelf scanResultWithArray:@[result]];
    }];


}
- (void)scanResultWithArray:(NSArray<LBXScanResult*>*)array
{
    if (array.count < 1)
    {
        [MBProgressHUD showError:@"识别失败了"];
        return;
    }
    
    //经测试，可以同时识别2个二维码，不能同时识别二维码和条形码
    for (LBXScanResult *result in array) {
        
        NSLog(@"scanResult:%@",result.strScanned);
    }
    
    if (!array[0].strScanned || [array[0].strScanned isEqualToString:@""] ) {
        
         [MBProgressHUD showError:@"识别失败了"];
        return;
    }
    LBXScanResult *scanResult = array[0];
    
    [self showNextVCWithScanResult:scanResult];
}

- (void)showNextVCWithScanResult:(LBXScanResult*)strResult
{
    ScanResultViewController *vc = [ScanResultViewController new];
    vc.imgScan = strResult.imgScanned;
    vc.strScan = strResult.strScanned;
    vc.strCodeType = strResult.strBarCodeType;
    [self.navigationController pushViewController:vc animated:YES];
}


- (NSString*)convertZXBarcodeFormat:(ZXBarcodeFormat)barCodeFormat{
    NSString *strAVMetadataObjectType = nil;
    
    switch (barCodeFormat) {
        case kBarcodeFormatQRCode:
            strAVMetadataObjectType = AVMetadataObjectTypeQRCode;
            break;
        case kBarcodeFormatEan13:
            strAVMetadataObjectType = AVMetadataObjectTypeEAN13Code;
            break;
        case kBarcodeFormatEan8:
            strAVMetadataObjectType = AVMetadataObjectTypeEAN8Code;
            break;
        case kBarcodeFormatPDF417:
            strAVMetadataObjectType = AVMetadataObjectTypePDF417Code;
            break;
        case kBarcodeFormatAztec:
            strAVMetadataObjectType = AVMetadataObjectTypeAztecCode;
            break;
        case kBarcodeFormatCode39:
            strAVMetadataObjectType = AVMetadataObjectTypeCode39Code;
            break;
        case kBarcodeFormatCode93:
            strAVMetadataObjectType = AVMetadataObjectTypeCode93Code;
            break;
        case kBarcodeFormatCode128:
            strAVMetadataObjectType = AVMetadataObjectTypeCode128Code;
            break;
        case kBarcodeFormatDataMatrix:
            strAVMetadataObjectType = AVMetadataObjectTypeDataMatrixCode;
            break;
        case kBarcodeFormatITF:
            strAVMetadataObjectType = AVMetadataObjectTypeITF14Code;
            break;
        case kBarcodeFormatRSS14:
            break;
        case kBarcodeFormatRSSExpanded:
            break;
        case kBarcodeFormatUPCA:
            break;
        case kBarcodeFormatUPCE:
            strAVMetadataObjectType = AVMetadataObjectTypeUPCECode;
            break;
        default:
            break;
    }
    return strAVMetadataObjectType;
}

@end
