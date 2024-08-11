//
//  RankingListModel.m
//  云音乐
//
//  Created by 刘超正 on 2017/9/23.
//  Copyright © 2017年 刘超正. All rights reserved.
//

#import "RankingListModel.h"

@implementation RankingListModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"hashId":@"hash"
             
             };
}
@end
