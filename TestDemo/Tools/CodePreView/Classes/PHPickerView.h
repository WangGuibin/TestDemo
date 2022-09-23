//
//  PHPickerView.h
//
//  Created by 王贵彬 on 2021/7/19.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PHPickerView : UIView

@property (nonatomic, strong) NSArray<NSString *> *dataSource;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) void(^selectItemBlock) (NSInteger selectedIndex,NSString *selectedStr);

- (void)show;

@end

NS_ASSUME_NONNULL_END
