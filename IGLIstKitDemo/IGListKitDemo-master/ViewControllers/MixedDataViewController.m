//
//  MixedDataViewController.m
//  IGListKitDemo
//
//  Created by iOS on 2017/6/29.
//  Copyright © 2017年 lg. All rights reserved.
//

#import "MixedDataViewController.h"
#import <IGListKit.h>
#import "ExpandableSectionController.h"
#import "GridSectionController.h"
#import "UserSectionController.h"
#import "GridItem.h"
#import "User.h"

@interface MixedDataViewController () <IGListAdapterDataSource>

@property (nonatomic, strong) NSArray *segments;
@property (nonatomic, copy) Class selectedClass;

@end

@implementation MixedDataViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initSetup];
    }
    return self;
}

- (void)initSetup {
    IGListAdapterUpdater *updater = [[IGListAdapterUpdater alloc] init];
    self.adapter = [[IGListAdapter alloc] initWithUpdater:updater viewController:self];

    self.datas = @[
                   @"Maecenas faucibus mollis interdum. Duis mollis, est non commodo luctus, nisi erat porttitor ligula, eget lacinia odio sem nec elit.",
                   [[GridItem alloc] initWithColor:[UIColor colorWithRed:237/255.0 green:73/255.0 blue:86/255.0 alpha:1] itemCount:6],
                   [[User alloc] initWithPk:2 name:@"Ryan Olson" handle:@"ryanolsonk"],
                   @"Praesent commodo cursus magna, vel scelerisque nisl consectetur et.",
                   [[User alloc] initWithPk:4 name:@"Oliver Rickard" handle:@"ocrickard"],
                   [[GridItem alloc] initWithColor:[UIColor colorWithRed:56/255.0 green:151/255.0 blue:240/255.0 alpha:1] itemCount:5],
                   @"Nullam quis risus eget urna mollis ornare vel eu leo. Praesent commodo cursus magna, vel scelerisque nisl consectetur et.",
                   [[User alloc] initWithPk:3 name:@"Jesse Squires" handle:@"jesse_squires"],
                   [[GridItem alloc] initWithColor:[UIColor colorWithRed:112/255.0 green:192/255.0 blue:80/255.0 alpha:1] itemCount:3],
                   @"Fusce dapibus, tellus ac cursus commodo, tortor mauris condimentum nibh, ut fermentum massa justo sit amet risus.",
                   [[GridItem alloc] initWithColor:[UIColor colorWithRed:163/255.0 green:42/255.0 blue:186/255.0 alpha:1] itemCount:7],
                   [[User alloc] initWithPk:1 name:@"Ryan Nystrom" handle:@"_ryannystrom"]
                   ];
    
    
    
    self.segments = @[
                      @[@"全部", @""],
                      @[@"颜色", NSStringFromClass(GridItem.class)],
                      @[@"文本", NSStringFromClass(NSString.class)],
                      @[@"用户", NSStringFromClass(User.class)]
                      ];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSMutableArray *map = [@[] mutableCopy];
    for (NSArray *item in self.segments) {
        [map addObject:item[0]];
    }
    
    UISegmentedControl *control = [[UISegmentedControl alloc] initWithItems:[map copy]];
    [control setSelectedSegmentIndex:0];
    [control addTarget:self action:@selector(onControl:) forControlEvents:UIControlEventValueChanged];
    
    self.navigationItem.titleView = control;
    
    [self.adapter setDataSource:self];
    [self.adapter setCollectionView:self.collectionView];
}

- (void)onControl:(UISegmentedControl *)control {
    NSString *classStr = [[self.segments objectAtIndex:control.selectedSegmentIndex] objectAtIndex:1];
    self.selectedClass = NSClassFromString(classStr);
    
    [self.adapter performUpdatesAnimated:YES completion:nil];
}

#pragma mark - IGListAdapterDataSource
- (NSArray<id<IGListDiffable>> *)objectsForListAdapter:(IGListAdapter *)listAdapter {
    
    if (self.selectedClass) {

        NSMutableArray *array = [@[] mutableCopy];
        for (id object in self.datas) {
            if ([object isKindOfClass:self.selectedClass]) {
                [array addObject:object];
            }
        }
        return [array copy];
    } else {
        return self.datas;
    }
}

- (IGListSectionController *)listAdapter:(IGListAdapter *)listAdapter sectionControllerForObject:(id)object {
    if ([object isKindOfClass:[NSString class]]) {
        return [[ExpandableSectionController alloc] init];
    } else if ([object isKindOfClass:[GridItem class]]) {
        return [[GridSectionController alloc] init];
    } else {
        return [[UserSectionController alloc] init];
    }
}

- (UIView *)emptyViewForListAdapter:(IGListAdapter *)listAdapter {
    return nil;
}

@end
