//
//  DiffTableViewController.m
//  IGListKitDemo
//
//  Created by iOS on 2017/7/3.
//  Copyright © 2017年 lg. All rights reserved.
//

#import "DiffTableViewController.h"
#import <IGListKit.h>
#import "Person.h"

@interface DiffTableViewController ()

@property (nonatomic, strong) NSArray *oldPeople;
@property (nonatomic, strong) NSArray *nwPeople;
@property (nonatomic, strong) NSArray <Person *> *people;
@property (nonatomic, assign) BOOL usingOldPeople;

@end

@implementation DiffTableViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initData];
    }
    return self;
}

/// Diff算法的使用

- (void)initData {
    
    _oldPeople = @[
                       [Person personWithPk:1 name:@"Kevin"],
                       [Person personWithPk:2 name:@"Mike"],
                       [Person personWithPk:3 name:@"Ann"],
                       [Person personWithPk:4 name:@"Jane"],
                       [Person personWithPk:5 name:@"Philip"],
                       [Person personWithPk:6 name:@"Mona"],
                       [Person personWithPk:7 name:@"Tami"],
                       [Person personWithPk:8 name:@"Jesse"],
                       [Person personWithPk:9 name:@"Jaed"]
                       ];
    _nwPeople = @[
                      [Person personWithPk:2 name:@"Mike"],
                      [Person personWithPk:10 name:@"Marne"],
                      [Person personWithPk:5 name:@"Philip"],
                      [Person personWithPk:1 name:@"Kevin"],
                      [Person personWithPk:3 name:@"Ryan"],
                      [Person personWithPk:8 name:@"Jesse"],
                      [Person personWithPk:7 name:@"Tami"],
                      [Person personWithPk:4 name:@"Jane"],
                      [Person personWithPk:9 name:@"Chen"]
                      ];
    
    self.people = _oldPeople;
    self.usingOldPeople = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPlay target:self action:@selector(onDiff)];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
}

- (void)onDiff {
    NSArray *from = self.people;
    NSArray *to = _usingOldPeople ? _nwPeople : _oldPeople;
    self.usingOldPeople = !_usingOldPeople;
    
    self.people = to;
    IGListIndexPathResult *result = [IGListDiffPaths(0, 0, from, to, IGListDiffEquality) resultForBatchUpdates];
    //移除重复的 插入新的 
    [self.tableView beginUpdates];
    [self.tableView deleteRowsAtIndexPaths:result.deletes withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView insertRowsAtIndexPaths:result.inserts withRowAnimation:UITableViewRowAnimationFade];
    [[result moves] enumerateObjectsUsingBlock:^(IGListMoveIndexPath * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.tableView moveRowAtIndexPath:obj.from toIndexPath:obj.to];
    }];
    [self.tableView endUpdates];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.people.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    Person *person = self.people[indexPath.row];
    cell.textLabel.text = person.name;
    
    return cell;
}
@end
