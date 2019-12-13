//
//  SearchCell.m
//  IGListKitDemo
//
//  Created by iOS on 2017/7/3.
//  Copyright © 2017年 lg. All rights reserved.
//

#import "SearchCell.h"

@implementation SearchCell

- (UISearchBar *)searchBar {
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc] init];
    }
    return _searchBar;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.searchBar];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.searchBar setFrame:self.contentView.bounds];
}
@end
