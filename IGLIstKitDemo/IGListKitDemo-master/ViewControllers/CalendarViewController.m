//
//  CalendarViewController.m
//  IGListKitDemo
//
//  Created by iOS on 2017/7/5.
//  Copyright © 2017年 lg. All rights reserved.
//

#import "CalendarViewController.h"
#import <IGListKit.h>
#import "Month.h"
#import "MonthSectionController.h"

@interface CalendarViewController () <IGListAdapterDataSource>

@end

@implementation CalendarViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initData];
    }
    return self;
}

- (void)initData {
    self.adapter = [[IGListAdapter alloc] initWithUpdater:[[IGListAdapterUpdater alloc] init] viewController:self];

    NSDate *date = [NSDate date];
    NSInteger currentMonth = [[NSCalendar currentCalendar] component:NSCalendarUnitMonth fromDate:date];
    
    Month *month = [[Month alloc] initWithName:[[NSDateFormatter alloc] init].monthSymbols[currentMonth-1]
                                          days:30
                                  appointments:@{
                                                 @2:@[@"Hair"],
                                                 @4: @[@"Nails"],
                                                 @7: @[@"Doctor appt", @"Pick up groceries"],
                                                 @12: @[@"Call back the cable company", @"Find a babysitter"],
                                                 @13: @[@"Dinner at The Smith"],
                                                 @17: @[@"Buy running shoes", @"Buy a fitbit", @"Start running"],
                                                 @20: @[@"Call mom"],
                                                 @21: @[@"Contribute to IGListKit"],
                                                 @25: @[@"Interview"],
                                                 @26: @[@"Quit running", @"Buy ice cream"]
                                                 }];
    self.datas = @[month];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    IGListCollectionViewLayout *layout = [[IGListCollectionViewLayout alloc] initWithStickyHeaders:NO topContentInset:0 stretchToEdge:NO];
    [self.collectionView setCollectionViewLayout:layout];
    [self.adapter setCollectionView:self.collectionView];
    [self.adapter setDataSource:self];
}

#pragma mark - IGListAdapterDataSource
- (NSArray<id<IGListDiffable>> *)objectsForListAdapter:(IGListAdapter *)listAdapter {
    return self.datas;
}

- (IGListSectionController *)listAdapter:(IGListAdapter *)listAdapter sectionControllerForObject:(id)object {
    MonthSectionController *sc = [[MonthSectionController alloc] init];
    return sc;
}

- (UIView *)emptyViewForListAdapter:(IGListAdapter *)listAdapter {
    return nil;
}

@end
