//
//  TwitterCell.m
//  TwitterListDemo
//
//  Created by bjovov on 2017/11/28.
//  Copyright © 2017年 Cao Xueliang. All rights reserved.
//

#import "TwitterCell.h"
#import "MLTweetCommentCell.h"
#import "MLTweetLayouts.h"
#import "YYControl.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <SDWebImage/UIButton+WebCache.h>
#import "YYTableView.h"

#pragma mark - 个人信息
/**
 个人信息View
 */
@implementation TwitterProfileView{
    BOOL _trackingTouch;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (frame.size.width == 0 && frame.size.height == 0) {
        frame.size.width = kScreenWidth;
        frame.size.height = kWBCellProfileHeight;
    }
    self = [super initWithFrame:frame];
    self.exclusiveTouch = YES;
    @weakify(self);
    
    _avatarView = [UIImageView new];
    _avatarView.size = CGSizeMake(40, 40);
    _avatarView.origin = CGPointMake(kWBCellPadding, kWBCellPadding + 3);
    _avatarView.contentMode = UIViewContentModeScaleAspectFill;
    _avatarView.clipsToBounds = YES;
    [self addSubview:_avatarView];
    
    _nameLabel = [YYLabel new];
    _nameLabel.size = CGSizeMake(kWBCellNameWidth, 24);
    _nameLabel.left = _avatarView.right + kWBCellNamePaddingLeft;
    _nameLabel.centerY = 27;
    _nameLabel.displaysAsynchronously = NO;
    _nameLabel.ignoreCommonProperties = YES;
    _nameLabel.fadeOnAsynchronouslyDisplay = NO;
    _nameLabel.fadeOnHighlight = NO;
    _nameLabel.lineBreakMode = NSLineBreakByClipping;
    _nameLabel.textVerticalAlignment = YYTextVerticalAlignmentCenter;
    [self addSubview:_nameLabel];
    
    _locationLabel = [YYLabel new];
    _locationLabel.frame = _nameLabel.frame;
    _locationLabel.centerY = 47;
    _locationLabel.displaysAsynchronously = NO;
    _locationLabel.ignoreCommonProperties = YES;
    _locationLabel.fadeOnAsynchronouslyDisplay = NO;
    _locationLabel.fadeOnHighlight = NO;
    [self addSubview:_locationLabel];
    _locationLabel.highlightTapAction = ^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
        if ([weak_self.cell.delegate respondsToSelector:@selector(cell: didClickInLabel: textRange:)]) {
            [weak_self.cell.delegate cell:weak_self.cell didClickInLabel:(YYLabel *)containerView textRange:range];
        }
    };
    return self;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    _trackingTouch = NO;
    UITouch *touch = touches.anyObject;
    CGPoint point1 = [touch locationInView:_avatarView];
    CGPoint point2 = [touch locationInView:_nameLabel];
    if (CGRectContainsPoint(_avatarView.bounds, point1)) {
        _trackingTouch = YES;
    }
    if (CGRectContainsPoint(_nameLabel.bounds, point2) && _nameLabel.textLayout.textBoundingRect.size.width > point2.x) {
        _trackingTouch = YES;
    }
    if (!_trackingTouch) {
        [super touchesBegan:touches withEvent:event];
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (!_trackingTouch) {
        [super touchesEnded:touches withEvent:event];
    }else{
        if ([_cell.delegate respondsToSelector:@selector(cell: didClickUser:)]) {
            [_cell.delegate cell:_cell didClickUser:_cell.statusView.layout.tweetModel];
        }
    }
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (!_trackingTouch) {
        [super touchesCancelled:touches withEvent:event];
    }
}

@end

#pragma mark - 视频View
@implementation TwitterVideoView
- (instancetype)initWithFrame:(CGRect)frame{
    if (frame.size.width == 0 && frame.size.height == 0) {
        frame.size.width = KWBVideoWidth;
        frame.size.height = KWBVideoHeight;
    }
    self = [super initWithFrame:frame];
    @weakify(self);
    
    _videoImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _videoImageButton.origin = CGPointMake(kWBCellPadding + 40 + kWBCellNamePaddingLeft, 0);
    _videoImageButton.size = CGSizeMake(KWBVideoWidth, KWBVideoHeight);
    _videoImageButton.contentMode = UIViewContentModeScaleAspectFill;
    [_videoImageButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        if ([weak_self.cell.delegate respondsToSelector:@selector(cellDidClickedVideo:)]) {
            [weak_self.cell.delegate cellDidClickedVideo:weak_self.cell];
        }
    }];
    [self addSubview:_videoImageButton];
    
    _startImageView = [UIImageView new];
    _startImageView.image = [UIImage imageNamed:@"mlgj-2x88"];
    _startImageView.frame = CGRectMake(0, 0, 30, 30);
    _startImageView.center = _videoImageButton.center;
    [self addSubview:_startImageView];
    
    return self;
}

@end

#pragma mark - 底部工具条
@implementation TwitterToolbarView
- (instancetype)initWithFrame:(CGRect)frame{
    if (frame.size.width == 0 && frame.size.height == 0) {
        frame.size.width = kScreenWidth;
        frame.size.height = kWBCellToolbarHeight;
    }
    self = [super initWithFrame:frame];
    self.exclusiveTouch = YES;
    
    _repostButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _repostButton.exclusiveTouch = YES;
    _repostButton.size = CGSizeMake(CGFloatPixelRound(self.width/3.0), self.height);
    [_repostButton setBackgroundImage:[UIImage imageWithColor:kWBCellHighlightColor] forState:UIControlStateHighlighted];
    
    _commentButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _commentButton.exclusiveTouch = YES;
    _commentButton.size = CGSizeMake(CGFloatPixelRound(self.width/3.0), self.height);
    _commentButton.left = CGFloatPixelRound(self.width/3.0);
    [_commentButton setBackgroundImage:[UIImage imageWithColor:kWBCellHighlightColor] forState:UIControlStateHighlighted];
    
    _likeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _likeButton.exclusiveTouch = YES;
    _likeButton.size = CGSizeMake(CGFloatPixelRound(self.width/3.0), self.height);
    _likeButton.left = CGFloatPixelRound(self.width/3.0 * 2.0);
    [_likeButton setBackgroundImage:[UIImage imageWithColor:kWBCellHighlightColor] forState:UIControlStateHighlighted];
    
    _repostImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"unLiked"]];
    _repostImageView.centerY = self.height / 2.0;
    [_repostButton addSubview:_repostImageView];
    
    _commentImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"commented"]];
    _commentImageView.centerY = self.height / 2.0;
    [_commentButton addSubview:_commentImageView];
    
    _likeImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"shared"]];
    _likeImageView.centerY = self.height / 2.0;
    [_likeButton addSubview:_likeImageView];
    
    _repostLabel = [YYLabel new];
    _repostLabel.userInteractionEnabled = NO;
    _repostLabel.textVerticalAlignment = YYTextVerticalAlignmentCenter;
    _repostLabel.displaysAsynchronously = NO;
    _repostLabel.ignoreCommonProperties = YES;
    _repostLabel.fadeOnHighlight = NO;
    _repostLabel.fadeOnAsynchronouslyDisplay = NO;
    _repostLabel.height = self.height;
    [_repostButton addSubview:_repostLabel];
    
    _commentLabel = [YYLabel new];
    _commentLabel.userInteractionEnabled = NO;
    _commentLabel.textVerticalAlignment = YYTextVerticalAlignmentCenter;
    _commentLabel.displaysAsynchronously = NO;
    _commentLabel.ignoreCommonProperties = YES;
    _commentLabel.fadeOnHighlight = NO;
    _commentLabel.fadeOnAsynchronouslyDisplay = NO;
    _commentLabel.height = self.height;
    [_commentButton addSubview:_commentLabel];
    
    _likeLabel = [YYLabel new];
    _likeLabel.userInteractionEnabled = NO;
    _likeLabel.textVerticalAlignment = YYTextVerticalAlignmentCenter;
    _likeLabel.displaysAsynchronously = NO;
    _likeLabel.ignoreCommonProperties = YES;
    _likeLabel.fadeOnHighlight = NO;
    _likeLabel.fadeOnAsynchronouslyDisplay = NO;
    _likeLabel.height = self.height;
    [_likeButton addSubview:_likeLabel];
    
    UIColor *dark = [UIColor colorWithWhite:0 alpha:0.2];
    UIColor *clear = [UIColor colorWithWhite:0 alpha:0];
    NSArray *colors = @[(id)clear.CGColor,(id)dark.CGColor, (id)clear.CGColor];
    NSArray *locations = @[@0.2, @0.5, @0.8];
    
    _line1 = [CAGradientLayer layer];
    _line1.locations = locations;
    _line1.colors = colors;
    _line1.startPoint = CGPointMake(0, 0);
    _line1.endPoint = CGPointMake(0, 1);
    _line1.size = CGSizeMake(CGFloatFromPixel(1), self.height);
    _line1.left = _repostButton.right;
    
    _line2 = [CAGradientLayer layer];
    _line2.locations = locations;
    _line2.colors = colors;
    _line2.startPoint = CGPointMake(0, 0);
    _line2.endPoint = CGPointMake(0, 1);
    _line2.size = CGSizeMake(CGFloatFromPixel(1), self.height);
    _line2.left = _commentButton.right;
    
    _topLine = [CALayer layer];
    _topLine.size = CGSizeMake(self.width, CGFloatFromPixel(1));
    _topLine.backgroundColor = kWBCellLineColor.CGColor;
    
    _bottomLine = [CALayer layer];
    _bottomLine.size = CGSizeMake(self.width, CGFloatFromPixel(1));
    _bottomLine.bottom = self.height;
    _bottomLine.backgroundColor = UIColorHex(e8e8e8).CGColor;
    
    [self addSubview:_repostButton];
    [self addSubview:_commentButton];
    [self addSubview:_likeButton];
    [self.layer addSublayer:_line1];
    [self.layer addSublayer:_line2];
    [self.layer addSublayer:_topLine];
    [self.layer addSublayer:_bottomLine];

    [_repostButton addTarget:self action:@selector(repostButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [_commentButton addTarget:self action:@selector(commentButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [_likeButton addTarget:self action:@selector(likeButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    return self;
}

- (void)setWithLayout:(MLTweetLayouts *)layout{
    _repostLabel.width = layout.toolbarRepostTextWidth;
    _commentLabel.width = layout.toolbarCommentTextWidth;
    _likeLabel.width = layout.toolbarLikeTextWidth;
    
    _repostLabel.textLayout = layout.toolbarRepostTextLayout;
    _commentLabel.textLayout = layout.toolbarCommentTextLayout;
    _likeLabel.textLayout = layout.toolbarLikeTextLayout;
    
    [self adjustImage:_repostImageView label:_repostLabel inButton:_repostButton];
    [self adjustImage:_commentImageView label:_commentLabel inButton:_commentButton];
    [self adjustImage:_likeImageView label:_likeLabel inButton:_likeButton];
    _repostImageView.image = [layout.tweetModel.is_like isEqualToString:@"Y"] ? [UIImage imageNamed:@"praised_icon"] : [UIImage imageNamed:@"unLiked"];
}

- (void)adjustImage:(UIImageView *)image label:(YYLabel *)label inButton:(UIButton *)button{
    CGFloat imageWidth = image.bounds.size.width;
    CGFloat labelWidth = label.width;
    CGFloat paddingMid = 5;
    CGFloat paddingSide = (button.width - imageWidth - labelWidth - paddingMid) / 2.0;
    image.centerX = CGFloatPixelRound(paddingSide + imageWidth / 2.0);
    label.right = CGFloatPixelRound(button.width - paddingSide);
}

- (void)repostButtonClicked{
    if ([_cell.delegate respondsToSelector:@selector(cellDidClickRepost:)]) {
        [_cell.delegate cellDidClickRepost:_cell];
    }
}

- (void)commentButtonClicked{
    if ([_cell.delegate respondsToSelector:@selector(cellDidClickComment:)]) {
        [_cell.delegate cellDidClickComment:_cell];
    }
}

- (void)likeButtonClicked{
    if ([_cell.delegate respondsToSelector:@selector(cellDidClickLike:)]) {
        [_cell.delegate cellDidClickLike:_cell];
    }
}

@end

#define mark - 点赞评论View
@implementation TwitterLikeOrCommentView
- (instancetype)initWithFrame:(CGRect)frame{
    if (frame.size.width == 0 && frame.size.height == 0) {
        frame.size.width = kWBCellContentWidth;
        frame.size.height = kScreenHeight;
    }
    self = [super initWithFrame:frame];
    self.exclusiveTouch = YES;
    self.backgroundColor = UIColorHex(F7F7F7);
    self.layer.cornerRadius = 3.0f;
    
    _likeBeginImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"praised_icon"]];
    _likeBeginImageView.size = CGSizeMake(16, 16);
    _likeBeginImageView.origin = CGPointMake(8, 9);
    [self addSubview:_likeBeginImageView];
    
    _likeUsersLabel = [YYLabel new];
    _likeUsersLabel.left = 8 + 20;
    _likeUsersLabel.width = kWBCellContentWidth - 8 - 10 - 20;
    _likeUsersLabel.textVerticalAlignment = YYTextVerticalAlignmentTop;
    _likeUsersLabel.displaysAsynchronously = NO;
    _likeUsersLabel.ignoreCommonProperties = YES;
    _likeUsersLabel.fadeOnAsynchronouslyDisplay = NO;
    _likeUsersLabel.fadeOnHighlight = NO;
    [self addSubview:_likeUsersLabel];
    
    _commentTable = [YYTableView new];
    _commentTable.size = CGSizeMake(kWBCellContentWidth, 20);
    _commentTable.origin = CGPointMake(0, 0);
    _commentTable.top = _likeUsersLabel.bottom;
    _commentTable.backgroundColor = [UIColor clearColor];
    [_commentTable registerClass:[MLTweetCommentCell class] forCellReuseIdentifier:@"MLTweetCommentCell"];
    _commentTable.dataSource = self;
    _commentTable.delegate = self;
    _commentTable.scrollEnabled = NO;
    [self addSubview:_commentTable];
    
    _separateLayer = [CALayer layer];
    _separateLayer.backgroundColor = [UIColor colorWithRed:(220 / 255.0) green:(220 / 255.0) blue:(220 / 255.0) alpha:1].CGColor;
    _separateLayer.frame = CGRectMake(0, 0, kWBCellContentWidth, CGFloatFromPixel(1));
    [_commentTable.layer addSublayer:_separateLayer];
    
    return self;
}

- (void)setCommentArray:(NSArray *)commentArray{
    if (!commentArray) {
        return;
    }
    _commentArray = commentArray;
    [_commentTable reloadData];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.commentArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TweetCommentModel *model = self.commentArray.count > 0 ? self.commentArray[indexPath.row] : nil;
    MLTweetCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MLTweetCommentCell" forIndexPath:indexPath];
    cell.commentModel = model;
    
    //点击评论昵称
    @weakify(self);
    cell.DidClickedUserName = ^(TweetCommentModel *commentModel){
        if ([weak_self.cell.delegate respondsToSelector:@selector(cellDidClickedCommentUser:)]) {
            [weak_self.cell.delegate cellDidClickedCommentUser:commentModel];
        }
    };
    
    //点击回复用户的昵称
    cell.DidClickedReplyUserName = ^(NSString *member_id){
        if ([weak_self.cell.delegate respondsToSelector:@selector(cellDidClickedReplyUser:)]) {
            [weak_self.cell.delegate cellDidClickedReplyUser:member_id];
        }
    };
    
    //点击评论链接
    cell.DidClickedLink = ^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect){
        if ([weak_self.cell.delegate respondsToSelector:@selector(cell:didClickInLabel:textRange:)]) {
            [weak_self.cell.delegate cell:weak_self.cell didClickInLabel:(YYLabel *)containerView textRange:range];
        }
    };
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    TweetCommentModel *model = self.commentArray.count > 0 ? self.commentArray[indexPath.row] : nil;
    return [MLTweetCommentCell cellHeightWithModel:model];
}

- (BOOL)tableView:(UITableView *)tableView shouldShowMenuForRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (BOOL)tableView:(UITableView *)tableView canPerformAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
    if (action == @selector(copy:)) {
        return YES;
    }
    return NO;
}

- (void)tableView:(UITableView *)tableView performAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
    if (action == @selector(copy:)) {
        TweetCommentModel *model;
        if (self.commentArray.count > 0) {
            model  = self.commentArray[indexPath.row];
        }
        [UIPasteboard generalPasteboard].string = model.comment;
    }
}

@end

#pragma mark - TwitterView
@implementation TwitterView
- (instancetype)initWithFrame:(CGRect)frame{
    if (frame.size.width == 0 && frame.size.height == 0) {
        frame.size.width = kScreenWidth;
        frame.size.height = 1;
    }
    self = [super initWithFrame:frame];
    self.backgroundColor = [UIColor clearColor];
    self.exclusiveTouch = YES;
    
    @weakify(self);
    _contentView = [UIView new];
    _contentView.width = kScreenWidth;
    _contentView.height = 1;
    _contentView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_contentView];
    
    _profileView = [TwitterProfileView new];
    [_contentView addSubview:_profileView];
    
    _menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _menuButton.size = CGSizeMake(30, 30);
    [_menuButton setImage:[UIImage imageNamed:@"timeline_icon_more"] forState:UIControlStateNormal];
    [_menuButton setImage:[UIImage imageNamed:@"timeline_icon_more_highlighted"] forState:UIControlStateHighlighted];
    _menuButton.centerX = self.width - 20;
    _menuButton.centerY = 18;
    [_menuButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(id sender) {
        if ([weak_self.cell.delegate respondsToSelector:@selector(cellDidClickMenu:)]) {
            [weak_self.cell.delegate cellDidClickMenu:weak_self.cell];
        }
    }];
    [_contentView addSubview:_menuButton];
    
    _timeLabel = [YYLabel new];
    _timeLabel.size = CGSizeMake(80, 24);
    _timeLabel.right = self.width - 20 - 15;
    _timeLabel.centerY = 18;
    _timeLabel.displaysAsynchronously = NO;
    _timeLabel.ignoreCommonProperties = YES;
    _timeLabel.fadeOnAsynchronouslyDisplay = NO;
    _timeLabel.fadeOnHighlight = NO;
    [_contentView addSubview:_timeLabel];
    
    _textLabel = [YYLabel new];
    _textLabel.left = kWBCellPadding + 40 + kWBCellNamePaddingLeft;
    _textLabel.width = kWBCellContentWidth;
    _textLabel.highlightTapAction = ^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect) {
        if ([weak_self.cell.delegate respondsToSelector:@selector(cell:didClickInLabel:textRange:)]) {
            [weak_self.cell.delegate cell:weak_self.cell didClickInLabel:(YYLabel *)containerView textRange:range];
        }
    };
    [_contentView addSubview:_textLabel];
    
    _expendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _expendButton.size = CGSizeMake(KWBExpendButtonWidth, KWBExpendButtonHeight);
    _expendButton.left = kWBCellPadding +  40 + kWBCellNamePaddingLeft;
    [_expendButton setTitleColor:RGBMAIN forState:UIControlStateNormal];
    _expendButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [_expendButton setImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    [_expendButton setImage:[UIImage imageWithColor:[UIColor lightGrayColor]] forState:UIControlStateHighlighted];
    [_expendButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(id sender) {
        if ([weak_self.cell.delegate respondsToSelector:@selector(cellDidClickExpendButton:)]) {
            [weak_self.cell.delegate cellDidClickExpendButton:weak_self.cell];
        }
    }];
    [_contentView addSubview:_expendButton];
    
    NSMutableArray *picViews = [NSMutableArray array];
    for (int i = 0; i < 9; i++) {
        YYControl *imageView = [YYControl new];
        imageView.size = CGSizeMake(100, 100);
        imageView.hidden = YES;
        imageView.clipsToBounds = YES;
        imageView.backgroundColor = kWBCellHighlightColor;
        imageView.exclusiveTouch = YES;
        imageView.touchBlock = ^(YYControl *view, YYGestureRecognizerState state, NSSet *touches, UIEvent *event) {
            if (![weak_self.cell.delegate respondsToSelector:@selector(cell:didClickImageAtIndex:)])
               return;
            if (state == YYGestureRecognizerStateEnded) {
                UITouch *touch = touches.anyObject;
                CGPoint point = [touch locationInView:view];
                if (CGRectContainsPoint(view.bounds, point)) {
                    [weak_self.cell.delegate cell:weak_self.cell didClickImageAtIndex:i];
                }
            }
        };
        [picViews addObject:imageView];
        [_contentView addSubview:imageView];
    }
    _picViews = picViews;
    
    _videoView = [TwitterVideoView new];
    [_contentView addSubview:_videoView];
    
    _likeOrCommentView = [TwitterLikeOrCommentView new];
    [_contentView addSubview:_likeOrCommentView];
    
    _toolbarView = [TwitterToolbarView new];
    [_contentView addSubview:_toolbarView];
    
    return self;
}

- (void)setLayout:(MLTweetLayouts *)layout{
    _layout = layout;
    self.height = layout.totalHeight;
    _contentView.top = layout.marginTop;
    _contentView.height = layout.totalHeight - layout.marginTop - layout.marginBottom;
    
    CGFloat top = 0;
    //布局个人信息
    [_profileView.avatarView sd_setImageWithURL:[NSURL URLWithString:layout.tweetModel.avatar] placeholderImage:[UIImage imageNamed:@"80x80"]];
    _profileView.nameLabel.textLayout = layout.nickNameTextLayout;
    _profileView.locationLabel.textLayout = layout.locationTextLayout;
    _profileView.height = layout.profileHeight;
    _profileView.top = top;
    top += layout.profileHeight;
    _timeLabel.textLayout = layout.timeTextLayout;
    
    
    //布局文本
    _textLabel.top = top;
    _textLabel.height = layout.textHeight;
    _textLabel.textLayout = layout.textLayout;
    top += layout.textHeight;
    
    
    //布局展开收起按钮
    if (layout.isShowExpendButton) {
        _expendButton.hidden = NO;
        _expendButton.top = top;
        top +=KWBExpendButtonHeight + 8;
        [_expendButton setTitle:layout.expendButtonTitle forState:UIControlStateNormal];
    }else{
        _expendButton.hidden = YES;
    }
    
    //布局视频Video
    if (layout.videoHeight == 0) {
        _videoView.hidden = YES;
    }else{
        _videoView.hidden = NO;
        TweetVideoModel *videoModel = layout.tweetModel.tweetVideoArray[0];
        _videoView.top = top;
        [_videoView.videoImageButton sd_setBackgroundImageWithURL:[NSURL URLWithString:videoModel.video_img] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"80x80"]];
        top += layout.videoHeight;
    }
    
    //布局图片
    if (layout.picHeight == 0) {
        [self _hideImageViews];
    }
    
    if (layout.picHeight > 0) {
        //解决只有图片时，间距太紧的问题
        if (_textLabel.height == 0) {
            top = top + 8;
        }
        [self _setImageViewWithTop:top isRetweet:NO];
    }
    
    //点击喜欢的名字的回调
    @weakify(self);
    layout.DidClickedLikeUser = ^(TweetLikeModel *likeModel){
        if ([weak_self.cell.delegate respondsToSelector:@selector(cellDidClickedLikedUser:)]) {
            [weak_self.cell.delegate cellDidClickedLikedUser:likeModel];
        }
    };
    
    
    //布局喜欢和评论View
    _likeOrCommentView.top = layout.totalHeight - layout.marginBottom - kWBCellToolbarHeight - kWBCellTopMargin - layout.commentHeight - layout.likeUserHeight - kWBCellPaddingText;
    _likeOrCommentView.left = kWBCellPadding +  40 + kWBCellNamePaddingLeft;
    _likeOrCommentView.width = kWBCellContentWidth;
    _likeOrCommentView.height = layout.commentHeight + layout.likeUserHeight;
    
    _likeOrCommentView.likeUsersLabel.origin = CGPointMake(8 + 20, 0);
    _likeOrCommentView.likeUsersLabel.height = layout.likeUserHeight;
    _likeOrCommentView.likeUsersLabel.width = kWBCellContentWidth - 10 - 8 - 20;
    _likeOrCommentView.likeUsersLabel.textLayout = layout.likeUserTextLayout;
    
    _likeOrCommentView.commentTable.height = layout.commentHeight;
    _likeOrCommentView.commentTable.top = layout.likeUserHeight;
    _likeOrCommentView.commentTable.width = kWBCellContentWidth;
    _likeOrCommentView.commentTable.left = 0;
    
    _likeOrCommentView.commentArray = layout.tweetModel.commentArray;
    _likeOrCommentView.likeUsersLabel.textLayout = layout.likeUserTextLayout;
    _likeOrCommentView.likeBeginImageView.hidden = !layout.tweetModel.likesArray.count;
    _likeOrCommentView.separateLayer.hidden = !layout.tweetModel.likesArray.count;
    
    _toolbarView.bottom = _contentView.height;
    [_toolbarView setWithLayout:layout];
}

- (void)_hideImageViews {
    for (UIImageView *imageView in _picViews) {
        imageView.hidden = YES;
    }
}

- (void)_setImageViewWithTop:(CGFloat)imageTop isRetweet:(BOOL)isRetweet{
    CGSize picSize = _layout.picSize;
    NSArray *pics = _layout.tweetModel.tweetPictureArray;
    int picsCount = (int)pics.count;
    
    for (int i = 0; i < 9; i++) {
        UIView *imageView = _picViews[i];
        if (i >= picsCount) {
            [imageView.layer yy_cancelCurrentImageRequest];
            imageView.hidden = YES;
        }else{
            CGPoint origin = {0};
            switch (picsCount) {
                case 1:{
                    origin.x = kWBCellPadding + 40 + kWBCellNamePaddingLeft;
                    origin.y = imageTop;
                }break;
                case 4:{
                    origin.x = kWBCellPadding + 40 + kWBCellNamePaddingLeft + (i % 2) * (picSize.width + kWBCellPaddingPic);
                    origin.y = imageTop + (int)(i / 2) * (picSize.height + kWBCellPaddingPic);
                }break;
                default:{
                    origin.x = kWBCellPadding + 40 + kWBCellNamePaddingLeft + (i % 3) * (picSize.width + kWBCellPaddingPic);
                    origin.y = imageTop + (int)(i / 3) * (picSize.height + kWBCellPaddingPic);
                }break;
            }
            imageView.frame = (CGRect){.origin = origin, .size = picSize};
            imageView.hidden = NO;
            [imageView.layer removeAnimationForKey:@"contents"];
            TweetPictureModel *pic = pics[i];
            
            [imageView.layer yy_setImageWithURL:[NSURL URLWithString:pic.images_small]
                                 placeholder:[UIImage imageNamed:@"80x80"]
                                     options:YYWebImageOptionAvoidSetImage
                                  completion:^(UIImage *image, NSURL *url, YYWebImageFromType from, YYWebImageStage stage, NSError *error) {
                    //@strongify(imageView);
                    if (!imageView) return;
                    if (image && stage == YYWebImageStageFinished) {
                        ///防止出现分母为0，出现崩溃
                        int width = pic.ico_width ? : 1;
                        int height = pic.ico_height ? : 1;
                      CGFloat scale = (height / width) / (imageView.height / imageView.width);
                      if (scale < 0.99 || isnan(scale)) { // 宽图把左右两边裁掉
                      imageView.contentMode = UIViewContentModeScaleAspectFill;
                      imageView.layer.contentsRect = CGRectMake(0, 0, 1, 1);
                      } else { // 高图只保留顶部
                        imageView.contentMode = UIViewContentModeScaleToFill;
                        imageView.layer.contentsRect = CGRectMake(0, 0, 1, (float)width / height);
                      }
                                          
                       ((YYControl *)imageView).image = image;
                      if (from != YYWebImageFromMemoryCacheFast) {
                          CATransition *transition = [CATransition animation];
                          transition.duration = 0.15;
                          transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
                          transition.type = kCATransitionFade;
                          [imageView.layer addAnimation:transition forKey:@"contents"];
                      }
                  }
             }];
         }
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [(_contentView) performSelector:@selector(setBackgroundColor:) withObject:kWBCellHighlightColor afterDelay:0.15];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self touchesRestoreBackgroundColor];
    UITouch *touch = touches.anyObject;
    CGPoint point = [touch locationInView:_timeLabel];
    if (CGRectContainsPoint(_timeLabel.bounds, point)) {
        if ([_cell.delegate respondsToSelector:@selector(cellDidClickMenu:)]) {
            [_cell.delegate cellDidClickMenu:_cell];
        }
    }else{
        if ([_cell.delegate respondsToSelector:@selector(cellDidClick:)]) {
            [_cell.delegate cellDidClick:_cell];
        }
    }
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self touchesRestoreBackgroundColor];
}

- (void)touchesRestoreBackgroundColor {
    [NSObject cancelPreviousPerformRequestsWithTarget:_contentView selector:@selector(setBackgroundColor:) object:kWBCellHighlightColor];
    _contentView.backgroundColor = [UIColor whiteColor];
}

@end

#pragma mark - TwitterCell
@implementation TwitterCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    _statusView = [TwitterView new];
    _statusView.cell = self;
    _statusView.likeOrCommentView.cell = self;
    _statusView.profileView.cell = self;
    _statusView.toolbarView.cell = self;
    _statusView.videoView.cell = self;
    [self.contentView addSubview:_statusView];
    return self;
}

- (void)setLayout:(MLTweetLayouts *)layout {
    self.height = layout.totalHeight;
    self.contentView.height = layout.totalHeight;
    _statusView.layout = layout;
}

@end
