//
//  DemoSectionController.m
//  IGListKitExamples
//
//  Created by iOS on 2017/6/27.
//  Copyright © 2017年 Instagram. All rights reserved.
//

#import "DemoSectionController.h"
#import "LabelCell.h"
#import "DemoItem.h"

@implementation DemoSectionController

- (CGSize)sizeForItemAtIndex:(NSInteger)index {
    return CGSizeMake(self.collectionContext.containerSize.width, 55);
}

- (UICollectionViewCell *)cellForItemAtIndex:(NSInteger)index {
    LabelCell *cell = [self.collectionContext dequeueReusableCellOfClass:[LabelCell class] forSectionController:self atIndex:index];
    
    cell.text = _object.name;
    return cell;
}

- (void)didUpdateToObject:(id)object {
    if ([object isKindOfClass:[DemoItem class]]) {
        _object = (DemoItem *)object;
    }
}

- (void)didSelectItemAtIndex:(NSInteger)index {
    UIViewController *controller;
    
    if (self.object.controllerIdentifier) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Demo" bundle:nil];
        controller = [storyboard instantiateViewControllerWithIdentifier:self.object.controllerIdentifier];
        
    } else {
        controller = [[self.object.controllerClass alloc] init];
    }
    
    if (controller) {
        controller.title = self.object.name;
        [self.viewController.navigationController pushViewController:controller animated:YES];
    }
}
@end
