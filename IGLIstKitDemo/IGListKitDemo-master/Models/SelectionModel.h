//
//  SelectionModel.h
//  IGListKitDemo
//
//  Created by iOS on 2017/7/4.
//  Copyright © 2017年 lg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <IGListKit.h>

typedef NS_ENUM(NSUInteger, SelectionModelType) {
    SelectionModelTypeNone,
    SelectionModelTypeFullWidth,
    SelectionModelTypeNib
};

@interface SelectionModel : NSObject <IGListDiffable>

@property (nonatomic, strong, readonly) NSArray<NSString *> *options;
@property (nonatomic, assign, readonly) SelectionModelType type;

- (instancetype)initWithOptions:(NSArray<NSString *> *)options type:(SelectionModelType)type NS_DESIGNATED_INITIALIZER;
+ (instancetype)selectionModelWithOptions:(NSArray<NSString *> *)options type:(SelectionModelType)type;
+ (instancetype)selectionModelWithOptions:(NSArray<NSString *> *)options;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;
@end
