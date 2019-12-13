//
//  DemoSectionController.h
//  IGListKitExamples
//
//  Created by iOS on 2017/6/27.
//  Copyright © 2017年 Instagram. All rights reserved.
//

#import <IGListKit/IGListKit.h>
#import "DemoItem.h"

@interface DemoSectionController : IGListSectionController

@property (nonatomic, strong, readonly) DemoItem *object;

@end
