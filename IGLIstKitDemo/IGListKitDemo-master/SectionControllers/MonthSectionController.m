//
//  MonthSectionController.m
//  IGListKitDemo
//
//  Created by iOS on 2017/7/5.
//  Copyright © 2017年 lg. All rights reserved.
//

#import "MonthSectionController.h"
#import "Month.h"
#import "MonthTitleViewModel.h"
#import "DayViewModel.h"
#import "LabelCell.h"
#import "CalendarDayCell.h"
#import "MonthTitleCell.h"

@interface MonthSectionController () <IGListBindingSectionControllerDataSource, IGListBindingSectionControllerSelectionDelegate>

@end

@implementation MonthSectionController {
    NSInteger _selectedDay;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.dataSource = self;
        self.selectionDelegate = self;
        _selectedDay = -1;
    }
    return self;
}

#pragma mark - IGListBindingSectionControllerDataSource
- (NSArray<id<IGListDiffable>> *)sectionController:(IGListBindingSectionController *)sectionController viewModelsForObject:(id)object {
    if ([object isKindOfClass:[Month class]]) {
        Month *month = object;
        
        NSDate *date = [NSDate date];
        NSInteger today = [[NSCalendar currentCalendar] component:NSCalendarUnitDay fromDate:date];
        
        NSMutableArray *viewModels = [@[] mutableCopy];
        [viewModels addObject:[MonthTitleViewModel monthTitleViewModelWithName:month.name]];
        
        for (int i=1; i <= month.days; i++) {
            DayViewModel *viewModel = [DayViewModel dayViewModelWithDay:i today:i==today selected:i==_selectedDay appointment:month.appointments[@(i)].count];
            [viewModels addObject:viewModel];
        }
        
        for (NSString *appointment in month.appointments[@(_selectedDay)]) {
            [viewModels addObject:appointment];
        }
        
        return [viewModels copy];
    }
    return @[];
}

- (UICollectionViewCell<IGListBindable> *)sectionController:(IGListBindingSectionController *)sectionController cellForViewModel:(id)viewModel atIndex:(NSInteger)index {
    
    Class cellClass;
    if ([viewModel isKindOfClass:[DayViewModel class]]) {
        cellClass = [CalendarDayCell class];
    } else if ([viewModel isKindOfClass:[MonthTitleViewModel class]]) {
        cellClass = [MonthTitleCell class];
    } else {
        cellClass = [LabelCell class];
    }
    
    return [self.collectionContext dequeueReusableCellOfClass:cellClass forSectionController:self atIndex:index];
}

- (CGSize)sectionController:(IGListBindingSectionController *)sectionController sizeForViewModel:(id)viewModel atIndex:(NSInteger)index {
    
    CGFloat width = self.collectionContext.containerSize.width;
    if ([viewModel isKindOfClass:[DayViewModel class]]) {
        CGFloat square = width/7;
        return CGSizeMake(square, square);
    } else if ([viewModel isKindOfClass:[MonthTitleViewModel class]]) {
        return CGSizeMake(width, 30.0);
    } else {
        return CGSizeMake(width, 55.0);
    }
}

#pragma mark - IGListBindingSectionControllerSelectionDelegate
- (void)sectionController:(IGListBindingSectionController *)sectionController didSelectItemAtIndex:(NSInteger)index viewModel:(id)viewModel {
    if ([viewModel isKindOfClass:[DayViewModel class]]) {
        DayViewModel *dayViewModel = (DayViewModel *)viewModel;
        
        if (dayViewModel.day == _selectedDay) {
            _selectedDay = -1;
        } else {
            _selectedDay = dayViewModel.day;
        }
        [self updateAnimated:YES completion:nil];
    }
}

@end
