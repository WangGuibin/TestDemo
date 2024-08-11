//
//  RankingListModel.h
//  云音乐
//
//  Created by 刘超正 on 2017/9/23.
//  Copyright © 2017年 刘超正. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RankingListModel : NSObject
@property (nonatomic,strong) NSString *filename;//歌手和歌名
@property (nonatomic,copy) NSString *hashId;//音乐id
@property (nonatomic,copy) NSString *album_id;
@property (nonatomic,copy) NSString *album_audio_id;

@end
