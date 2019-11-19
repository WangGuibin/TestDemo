//
//  SelectImagesDemoViewController.m
//  TestDemo
//
//  Created by mac on 2019/10/14.
//  Copyright © 2019 mac. All rights reserved.
// https://github.com/WangGuibin/WGBSelectPhotoView

#import "WGBSelectImagesDemoViewController.h"
#import <WGBSelectPhotoView.h>
#import <TZImagePickerController/TZImagePickerController.h>
#import "YBImageBrowser.h"
#import <YBIBVideoData.h>

#define kMaxSelectImagesCount 9

@interface WGBSelectImagesDemoViewController ()<UITableViewDelegate, UITableViewDataSource, WGBSelectPhotoViewDelegate>

@property (nonatomic, strong) WGBSelectPhotoView *selectPhotoView;
@property (nonatomic, strong) NSMutableArray *selectImageArray;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation WGBSelectImagesDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"同时照片与视频";
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupUI];
}

- (void)setupUI{
    self.tableView.tableHeaderView  =  self.selectPhotoView;
    __weak typeof(self) weakSelf = self;
    [self.selectPhotoView setUpdateHeightBlock:^(CGRect viewRect) {
        //自适应更新回调 一般来说在这里更新视图高度
        [weakSelf.tableView beginUpdates];
        [weakSelf.tableView setTableHeaderView:weakSelf.selectPhotoView];
        [weakSelf.tableView endUpdates];
    }];
}

- (void)selectPhoto{
    TZImagePickerController *pickerVC = [[TZImagePickerController alloc] init];
    pickerVC.allowPickingVideo = YES;
    pickerVC.allowPickingMultipleVideo = YES;//多选
    pickerVC.maxImagesCount = kMaxSelectImagesCount;
    [self presentViewController:pickerVC animated:YES completion:^{
        
    }];
    
    //选图片或者视频
    [pickerVC setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        if (self.selectImageArray.count + assets.count > kMaxSelectImagesCount) {
            [self outOfLimitAlertTips];
        }
        ///MARK：- 优雅的方式 只获取`kMaxSelectImagesCount`张
        if (self.selectImageArray.count) {
            NSInteger detaCount = kMaxSelectImagesCount - self.selectImageArray.count;
            detaCount = MIN(detaCount, assets.count);
            NSIndexSet *indexes = [NSIndexSet indexSetWithIndexesInRange:
                                   NSMakeRange(0,detaCount)];
            NSArray *tempAssets = [assets objectsAtIndexes:indexes];
            NSArray *tempPhotoes = [photos objectsAtIndexes:indexes];
            NSArray<WGBSelectPhotoDataItem *> *items = [WGBSelectPhotoDataItem createDataItemsWithPHAssets:tempAssets photoes:tempPhotoes];
            [self.selectPhotoView addPhotoesWithDataItems:items];
            [self.selectImageArray addObjectsFromArray:tempAssets];
        }else{
            NSArray<WGBSelectPhotoDataItem *> *items = [WGBSelectPhotoDataItem createDataItemsWithPHAssets:assets photoes:photos];
            [self.selectPhotoView addPhotoesWithDataItems:items];
            [self.selectImageArray addObjectsFromArray:assets];
        }
    }];
}


///MARK:- 超出限制提示信息
- (void)outOfLimitAlertTips{
    NSString *message = [NSString stringWithFormat:@"最多只能选择%ld个媒体资源",(long)kMaxSelectImagesCount];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"知道了" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction: action];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - <WGBSelectPhotoViewDelegate>
- (void)wgb_photoViewDidClickedPhotoAtIndex:(NSInteger)index
                                  photoView:(WGBSelectPhotoView *)photoView{
    if (index == [self.selectPhotoView picturesCount]) {
        [self selectPhoto];
    }else {
        NSMutableArray *localImageDataArr = [NSMutableArray array];
        NSArray *assets = [self.selectImageArray copy];
        for (PHAsset *imageAsset in assets) {
            if (imageAsset.mediaType == PHAssetMediaTypeVideo) {
                YBIBVideoData *videoData = [YBIBVideoData new];
                videoData.videoPHAsset = imageAsset;
                [localImageDataArr addObject:videoData];
            }else {
                YBIBImageData *imageData = [YBIBImageData new];
                imageData.imagePHAsset = imageAsset;
                [localImageDataArr addObject:imageData];
            }
        }
        YBImageBrowser *browser = [YBImageBrowser new];
        browser.defaultToolViewHandler.topView.operationButton.hidden = YES;
        browser.dataSourceArray = localImageDataArr;
        browser.currentPage = index;
        [browser show];
    }
}

//删除图片事件回调
- (void)wgb_photoViewDidDeletedPhotoAtIndex:(NSInteger)index
                                  photoView:(WGBSelectPhotoView *)photoView{
    if (self.selectImageArray.count) {
        [self.selectImageArray removeObjectAtIndex: index];
    }
}

//移动图片事件
- (void)wgb_photoViewDidMovedPhotoWithStartIndex:(NSInteger)startIndex
                                        endIndex:(NSInteger)endIndex
                                       photoView:(WGBSelectPhotoView *)photoView{
    NSLog(@"startIndex: %ld --- endIndex: %ld",startIndex,endIndex);
    if (startIndex != endIndex) {
        //不要直接操作数据源本身， 不然数据会错乱
        NSMutableArray *tempArr = self.selectImageArray.mutableCopy;
        id obj = tempArr[startIndex];
        [tempArr removeObject:obj];
        [tempArr insertObject:obj atIndex:endIndex];
        self.selectImageArray = tempArr ;
    }
}

///MARK:- tableView DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (indexPath.row % 2 == 0) {
        cell.contentView.backgroundColor = [UIColor systemOrangeColor];
    } else {
        cell.contentView.backgroundColor = [UIColor systemPinkColor];
    }
    return cell;
}

///MARK:-  tableView Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

///MARK:- Lazy load
- (WGBSelectPhotoView *)selectPhotoView {
    if (!_selectPhotoView) {
        _selectPhotoView = [[WGBSelectPhotoView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 100)];
        _selectPhotoView.maxCount = kMaxSelectImagesCount;
        _selectPhotoView.rowCount = 3;
        _selectPhotoView.backgroundColor = [UIColor cyanColor];
        _selectPhotoView.delegate = self;
        [_selectPhotoView showAddButtonDisplay];
    }
    return _selectPhotoView;
}


- (NSMutableArray *)selectImageArray {
    if (!_selectImageArray) {
        _selectImageArray = [[NSMutableArray alloc] init];
    }
    return _selectImageArray;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        if (@available(iOS 11.0, *)) {
            _tableView.estimatedRowHeight = 0;
            _tableView.estimatedSectionFooterHeight = 0;
            _tableView.estimatedSectionHeaderHeight = 0;
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
        [self.view addSubview: _tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
            make.left.right.equalTo(self.view);
        }];
    }
    return _tableView;
}

@end
