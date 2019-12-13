//
//  StoryboardLabelSectionController.h
//  IGListKitDemo
//
//  Created by iOS on 2017/7/4.
//  Copyright © 2017年 lg. All rights reserved.
//

#import <IGListKit/IGListKit.h>

@class StoryboardLabelSectionController;

@protocol StoryboardLabelSectionControllerDelegate <NSObject>

- (void)removeSectionControllerWantsRemoved:(StoryboardLabelSectionController *)sectionController;

@end

@interface StoryboardLabelSectionController : IGListSectionController

@property (nonatomic, weak) id<StoryboardLabelSectionControllerDelegate> delegate;

@end
