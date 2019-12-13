//
//  DayViewModel.m
//  IGListKitDemo
//
//  Created by iOS on 2017/7/5.
//  Copyright © 2017年 lg. All rights reserved.
//

#import "DayViewModel.h"

@implementation DayViewModel

- (instancetype)initWithDay:(NSInteger)day today:(BOOL)today selected:(BOOL)selected appointment:(NSInteger)appointment
{
    self = [super init];
    if (self) {
        _day = day;
        _today = today;
        _selected = selected;
        _appointments = appointment;
    }
    return self;
}

+ (instancetype)dayViewModelWithDay:(NSInteger)day today:(BOOL)today selected:(BOOL)selected appointment:(NSInteger)appointment {
    return [[self alloc] initWithDay:day today:today selected:selected appointment:appointment];
}

- (id<NSObject>)diffIdentifier {
    return @(_day);
}

- (BOOL)isEqualToDiffableObject:(id<IGListDiffable>)object {
    if (self == object) {
        return YES;
    }
    
    if ([(NSObject *)object isKindOfClass:[DayViewModel class]]) {
        DayViewModel *model = (DayViewModel *)object;
        return _today == model.today && _selected == model.selected && _appointments == model.appointments;
    }
    
    return NO;
}
@end
