//
//  StoryboardViewController.m
//  IGListKitDemo
//
//  Created by iOS on 2017/7/4.
//  Copyright © 2017年 lg. All rights reserved.
//

#import "StoryboardViewController.h"
#import <IGListKit.h>
#import "Person.h"
#import "StoryboardLabelSectionController.h"

@interface StoryboardViewController () <IGListAdapterDataSource, StoryboardLabelSectionControllerDelegate>

@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;

@property (nonatomic, strong) IGListAdapter *adapter;
@property (nonatomic, strong) NSArray *people;

@end

@implementation StoryboardViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initData];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self initData];
    }
    return self;
}

- (void)initData {
    self.adapter = [[IGListAdapter alloc] initWithUpdater:[[IGListAdapterUpdater alloc] init] viewController:self];
    
    self.people = @[
                    [Person personWithPk:1 name:@"Littlefinger"],
                    [Person personWithPk:2 name:@"Tommen Baratheon"],
                    [Person personWithPk:3 name:@"Roose Bolton"],
                    [Person personWithPk:4 name:@"Brienne of Tarth"],
                    [Person personWithPk:5 name:@"Bronn"],
                    [Person personWithPk:6 name:@"Gilly"],
                    [Person personWithPk:7 name:@"Theon Greyjoy"],
                    [Person personWithPk:8 name:@"Jaqen H'ghar"],
                    [Person personWithPk:9 name:@"Cersei Lannister"],
                    [Person personWithPk:10 name:@"Jaime Lannister"],
                    [Person personWithPk:11 name:@"Tyrion Lannister"],
                    [Person personWithPk:12 name:@"Melisandre"],
                    [Person personWithPk:13 name:@"Missandei"],
                    [Person personWithPk:14 name:@"Jorah Mormont"],
                    [Person personWithPk:15 name:@"Khal Moro"],
                    [Person personWithPk:16 name:@"Daario Naharis"],
                    [Person personWithPk:17 name:@"Jon Snow"],
                    [Person personWithPk:18 name:@"Arya Stark"],
                    [Person personWithPk:19 name:@"Bran Stark"],
                    [Person personWithPk:20 name:@"Sansa Stark"],
                    [Person personWithPk:21 name:@"Daenerys Targaryen"],
                    [Person personWithPk:22 name:@"Samwell Tarly"],
                    [Person personWithPk:23 name:@"Tormund"],
                    [Person personWithPk:24 name:@"Margaery Tyrell"],
                    [Person personWithPk:25 name:@"Varys"],
                    [Person personWithPk:26 name:@"Renly Baratheon"],
                    [Person personWithPk:27 name:@"Joffrey Baratheon"],
                    [Person personWithPk:28 name:@"Stannis Baratheon"],
                    [Person personWithPk:29 name:@"Hodor"],
                    [Person personWithPk:30 name:@"Tywin Lannister"],
                    [Person personWithPk:31 name:@"The Hound"],
                    [Person personWithPk:32 name:@"Ramsay Bolton"]
                    ];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.adapter setCollectionView:self.collectionView];
    [self.adapter setDataSource:self];
}

#pragma mark - IGListAdapterDataSource
- (NSArray<id<IGListDiffable>> *)objectsForListAdapter:(IGListAdapter *)listAdapter {
    return self.people;
}

- (IGListSectionController *)listAdapter:(IGListAdapter *)listAdapter sectionControllerForObject:(id)object {
    StoryboardLabelSectionController *sc = [[StoryboardLabelSectionController alloc] init];
    sc.delegate = self;
    
    return sc;
}

- (UIView *)emptyViewForListAdapter:(IGListAdapter *)listAdapter {
    return nil;
}

#pragma mark - StoryboardLabelSectionControllerDelegate
- (void)removeSectionControllerWantsRemoved:(StoryboardLabelSectionController *)sectionController {
    NSInteger section = [self.adapter sectionForSectionController:sectionController];
    
    NSMutableArray *tmp = [self.people mutableCopy];
    [tmp removeObjectAtIndex:section];
    self.people = [tmp copy];
    [self.adapter performUpdatesAnimated:YES completion:nil];
    
}

@end
