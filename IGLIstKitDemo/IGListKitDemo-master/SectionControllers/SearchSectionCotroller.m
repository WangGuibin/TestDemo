//
//  SearchSectionCotroller.m
//  IGListKitDemo
//
//  Created by iOS on 2017/7/3.
//  Copyright © 2017年 lg. All rights reserved.
//

#import "SearchSectionCotroller.h"
#import "SearchCell.h"

@implementation SearchSectionCotroller

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.scrollDelegate = self;
    }
    return self;
}

- (NSInteger)numberOfItems {
    return 1;
}

- (CGSize)sizeForItemAtIndex:(NSInteger)index {
    return CGSizeMake(self.collectionContext.containerSize.width, 44);
}

- (UICollectionViewCell *)cellForItemAtIndex:(NSInteger)index {
    SearchCell *cell = [self.collectionContext dequeueReusableCellOfClass:[SearchCell class] forSectionController:self atIndex:index];
    cell.searchBar.delegate = self;
    
    return cell;
}

#pragma mark - UISearchBarDelegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (self.delegate && [self.delegate respondsToSelector:@selector(searchSectionController:didChangeText:)]) {
        [self.delegate searchSectionController:self didChangeText:searchText];
    }
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    if (self.delegate && [self.delegate respondsToSelector:@selector(searchSectionController:didChangeText:)]) {
        [self.delegate searchSectionController:self didChangeText:@""];
    }
}

#pragma mark - IGListScrollDelegate
- (void)listAdapter:(IGListAdapter *)listAdapter didScrollSectionController:(IGListSectionController *)sectionController {
    SearchCell *cell = [self.collectionContext cellForItemAtIndex:0 sectionController:self];
    cell.searchBar.text = @"";
    [cell.searchBar resignFirstResponder];
}

- (void)listAdapter:(IGListAdapter *)listAdapter willBeginDraggingSectionController:(IGListSectionController *)sectionController {
    
}

- (void)listAdapter:(IGListAdapter *)listAdapter didEndDraggingSectionController:(IGListSectionController *)sectionController willDecelerate:(BOOL)decelerate {
    
}
@end
