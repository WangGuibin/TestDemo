[关于文本末尾截断的坑](https://juejin.cn/post/6844904153433669639) 
 
```objc
_nameLabel.displaysAsynchronously = YES;//异步渲染
_nameLabel.ignoreCommonProperties = YES;//忽略基本属性提高性能 这些属性由富文本设置渲染

```

```objc
     UIColor *nameColor = [UIColor colorWithHexString:@"#383A3E"];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",model.goods_name]];
        if ([model.is_newer boolValue]) {
            attributedText = [[self stringWithUIImage:[NSString stringWithFormat:@" %@",model.goods_name]] mutableCopy];
        }
 //!! 这里有个坑⚠️  https://juejin.cn/post/6844904153433669639
//        attributedText.lineBreakMode = NSLineBreakByTruncatingTail;
        
        attributedText.alignment = NSTextAlignmentLeft;
        attributedText.lineSpacing = 0;
        attributedText.color = nameColor;
        attributedText.maximumLineHeight = 18.5;
        attributedText.minimumLineHeight = 18.5;
        attributedText.font = nameFont;
        
        YYTextContainer *container = [YYTextContainer new];
        container.size = CGSizeMake(cellItemW-16, MAXFLOAT);
        container.maximumNumberOfRows = 2;
        container.truncationType = YYTextTruncationTypeEnd; // 设置结尾处为省略号，默认只是换行截断
        container.truncationToken = [[NSAttributedString alloc] initWithString:@"..." attributes:attributedText.attributes];

        YYTextLayout *layout = [YYTextLayout layoutWithContainer:container text:attributedText];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.nameLabel.size = layout.textBoundingSize;
            self.nameLabel.textLayout = layout;
        });
    });

```

列表异步渲染,加载新数据直接刷新列表会发生闪烁的问题
[刷新数据异步绘制发生闪烁的问题](https://github.com/ibireme/YYKit/issues/64)
[关闭collectionView的隐式动画](http://adad184.com/2015/11/10/disable-uicollectionview-implicit-animation/)

```objc
NSUInteger oldCount = self.dataArr.count - resArr.count;
NSMutableArray *indexPaths = [NSMutableArray array];
for (NSUInteger i = 0; i < resArr.count; i++) {
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:oldCount+i inSection:0];
    [indexPaths addObject:indexPath];
}

if (self.dataArr.count && indexPaths.count > 0) {
    
    [UIView setAnimationsEnabled:NO];
    [self.collectionView performBatchUpdates:^{
        [self.collectionView insertItemsAtIndexPaths:indexPaths];
    } completion:^(BOOL finished) {
        [UIView setAnimationsEnabled:YES];
    }];
}else{
    [self.collectionView reloadData];
}

```
