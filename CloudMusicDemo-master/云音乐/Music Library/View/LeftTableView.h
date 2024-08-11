//
//  LeftTableView.h
//  云音乐
//
//  Created by 刘超正 on 2017/9/21.
//  Copyright © 2017年 刘超正. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LeftTableView : UITableView

+ (instancetype)initWithLeftTableViewFrame:(CGRect)frame andDelegate:(id<UITableViewDelegate,UITableViewDataSource>)delegate;
@end
