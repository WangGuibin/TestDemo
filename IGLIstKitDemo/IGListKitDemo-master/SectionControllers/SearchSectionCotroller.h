//
//  SearchSectionCotroller.h
//  IGListKitDemo
//
//  Created by iOS on 2017/7/3.
//  Copyright © 2017年 lg. All rights reserved.
//

#import <IGListKit/IGListKit.h>

@class SearchSectionCotroller;

@protocol SearchSectionCotrollerDelegate <NSObject>

- (void)searchSectionController:(SearchSectionCotroller *)searchSectionController didChangeText:(NSString *)text;

@end

@interface SearchSectionCotroller : IGListSectionController <UISearchBarDelegate, IGListScrollDelegate>

@property (nonatomic, weak) id<SearchSectionCotrollerDelegate> delegate;

@end
