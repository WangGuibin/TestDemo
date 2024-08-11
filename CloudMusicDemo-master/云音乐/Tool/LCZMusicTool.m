//
//  LCZMusicTool.m
//  云音乐
//
//  Created by 刘超正 on 2017/9/25.
//  Copyright © 2017年 刘超正. All rights reserved.
//

#import "LCZMusicTool.h"
#import "LrcModel.h"
@implementation LCZMusicTool




-(RankingListModel *)previousMusic{
    //获取上一首音乐的下标值
    NSInteger index = self.index;
    NSInteger previousIndex = --index;
    RankingListModel *model = nil;
    if (previousIndex < 0) {
        previousIndex = self.musicModelAry.count -1;
    }
    model = self.musicModelAry[previousIndex];
    self.index = previousIndex;
    return model;
}

-(RankingListModel *)nextMusic{
    //获取下一首音乐的下标值
    NSInteger index = self.index;
    NSInteger previousIndex = ++index;
    RankingListModel *model = nil;
    if (previousIndex < 0) {
        previousIndex = self.musicModelAry.count -1;
    }
    model = self.musicModelAry[previousIndex];
    self.index = previousIndex;
    return model;
}

- (NSMutableArray *)lrcToolWithLrcName:(NSString *)lrcName{
    //转化为数组歌词
    NSArray *lrcAry = [lrcName componentsSeparatedByString:@"\r\n"];
    NSMutableArray *lrcMustableAry = [NSMutableArray array];
    for (NSString *name in lrcAry) {
       NSArray *nameAry = [name componentsSeparatedByString:@"]"];
        //时间
        NSString *time = [[[nameAry firstObject] componentsSeparatedByString:@"["] lastObject];
        //歌词
        NSString *lrc = [nameAry lastObject];
        LrcModel *model = [[LrcModel alloc]init];
        model.time = [self timeWithString:time];
        model.text = lrc;
        [lrcMustableAry addObject:model];
    }
    return lrcMustableAry;
}

- (NSTimeInterval)timeWithString:(NSString *)string{
    //[00:02.34
    
    //NSString *minS = [string componentsSeparatedByString:@"["][1];
    
    if ([string isEqualToString:@""] || [string containsString:@"$"] || ![string containsString:@"."]) {
        return 100;
    }
    else{
        NSInteger min = [[string componentsSeparatedByString:@":"][0] integerValue];
        NSInteger sec = [[[string componentsSeparatedByString:@":"][1] componentsSeparatedByString:@"."][0] integerValue];
        NSInteger hm = [[string componentsSeparatedByString:@"."][1] integerValue];
        return min *60 + sec +hm *0.01;
    }
}
@end
