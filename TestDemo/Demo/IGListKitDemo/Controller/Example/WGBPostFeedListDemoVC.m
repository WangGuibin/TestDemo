//
// WGBPostFeedListDemoVC.m
// TestDemo
//
// Author:  @CoderWGB
// Github:  https://github.com/WangGuibin/TestDemo
// E-mail:  864562082@qq.com
//
// Created by CoderWGB on 2019/12/13
//
/**
Copyright (c) 2019 Wangguibin  

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
*/
    

#import "WGBPostFeedListDemoVC.h"
#import "WGBPostItemModel.h"
#import "WGBIGListKitDemoPostFeedListSection.h"

@interface WGBPostFeedListDemoVC ()<IGListAdapterDataSource>

@end

@implementation WGBPostFeedListDemoVC

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initSetup];
    }
    return self;
}

- (void)initSetup {
    self.title = @"纯文本列表";
    IGListAdapterUpdater *adapterUpdater = [[IGListAdapterUpdater alloc] init];
    self.adapter = [[IGListAdapter alloc] initWithUpdater:adapterUpdater viewController:self];
    self.dataSource = @[
    [[WGBPostItemModel alloc] initWithUsername:@"用户89757" comments:@[
                                                       @"不错很不错！",
                                                       @"厉害牛逼",
                                                       @"supreme",
                                                       @"野狼disco",
                                                       @"干a它！",
                                                       ]],
    [[WGBPostItemModel alloc] initWithUsername:@"叶孤城" comments:@[
                                                       @"The simplicity here is superb",
                                                       @"thanks!",
                                                       @"That's always so kind of you!",
                                                       @"I think you might like this",
                                                       ]],
    [[WGBPostItemModel alloc] initWithUsername:@"西门吹牛" comments:@[
                                                       @"So good",
                                                       @"how much???"
                                                       ]],
    [[WGBPostItemModel alloc] initWithUsername:@"撸小凤" comments:@[
                                                       @"hope she might like it.",
                                                       @"I love it.",
                                                       @"lol so easy!"
                                                       ]]
    
    ];
    self.adapter.collectionView = self.collectionView;
    self.adapter.dataSource = self;
}


#pragma mark - IGListAdapterDataSource
- (NSArray<id<IGListDiffable>> *)objectsForListAdapter:(IGListAdapter *)listAdapter {
    return self.dataSource;
}

- (IGListSectionController *)listAdapter:(IGListAdapter *)listAdapter sectionControllerForObject:(id)object {
    return [[WGBIGListKitDemoPostFeedListSection alloc] init];
}

- (UIView *)emptyViewForListAdapter:(IGListAdapter *)listAdapter {
    return nil;
}
@end
