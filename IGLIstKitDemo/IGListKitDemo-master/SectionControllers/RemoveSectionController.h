//
//  RemoveSectionController.h
//  IGListKitDemo
//
//  Created by iOS on 2017/6/28.
//  Copyright © 2017年 lg. All rights reserved.
//

#import <IGListKit/IGListKit.h>

@class RemoveSectionController;

@protocol RemoveSectionControllerDelegate <NSObject>

- (void)removeSectionControllerWantsRemoved:(RemoveSectionController *)removeSectionController;

@end

@interface RemoveSectionController : IGListSectionController

@property (nonatomic, weak) id<RemoveSectionControllerDelegate> delegate;
@property (nonatomic, assign) NSInteger number;


@end
