//
//  MLTweetLayouts.m
//  MeiLin
//
//  Created by 曹学亮 on 2016/10/9.
//  Copyright © 2016年 Li Chuanliang. All rights reserved.
//

#import "MLTweetLayouts.h"
#import "MLTweetCommentCell.h"
/*
 将每行的 baseline 位置固定下来，不受不同字体的 ascent/descent 影响。
 */
@implementation WBTextLinePositionModifier
- (instancetype)init {
    self = [super init];
    if (kiOS9Later) {
        _lineHeightMultiple = 1.34;
    } else {
        _lineHeightMultiple = 1.3125;
    }
    return self;
}

- (void)modifyLines:(NSArray *)lines fromText:(NSAttributedString *)text inContainer:(YYTextContainer *)container {

    CGFloat ascent = _font.pointSize * 0.86;
    CGFloat lineHeight = _font.pointSize * _lineHeightMultiple;
    for (YYTextLine *line in lines) {
        CGPoint position = line.position;
        position.y = _paddingTop + ascent + line.row  * lineHeight;
        line.position = position;
    }
}

- (id)copyWithZone:(NSZone *)zone {
    WBTextLinePositionModifier *one = [self.class new];
    one->_font = _font;
    one->_paddingTop = _paddingTop;
    one->_paddingBottom = _paddingBottom;
    one->_lineHeightMultiple = _lineHeightMultiple;
    return one;
}

- (CGFloat)heightForLineCount:(NSUInteger)lineCount {
    if (lineCount == 0) return 0;
    CGFloat ascent = _font.pointSize * 0.86;
    CGFloat descent = _font.pointSize * 0.14;
    CGFloat lineHeight = _font.pointSize * _lineHeightMultiple;
    return _paddingTop + _paddingBottom + ascent + descent + (lineCount - 1) * lineHeight;
}
@end

/**
 微博的文本中，某些嵌入的图片需要从网上下载，这里简单做个封装
 */
@interface WBTextImageViewAttachment : YYTextAttachment
@property (nonatomic, strong) NSURL *imageURL;
@property (nonatomic, assign) CGSize size;
@end

@implementation WBTextImageViewAttachment {
    UIImageView *_imageView;
}

- (void)setContent:(id)content {
    _imageView = content;
}

- (id)content {
    // UIImageView 只能在主线程访问
    if (pthread_main_np() == 0) return nil;
    if (_imageView) return _imageView;
    
    // 第一次获取时 (应该是在文本渲染完成，需要添加附件视图时)，初始化图片视图，并下载图片
    // 这里改成 YYAnimatedImageView 就能支持 GIF/APNG/WebP 动画了
    _imageView = [UIImageView new];
    _imageView.size = _size;
    
    [_imageView yy_setImageWithURL:_imageURL placeholder:nil];
    return _imageView;
}
@end


/**
 整个cell的布局
 */
@implementation MLTweetLayouts
- (instancetype)initWithStatus:(MLTweetModel *)tweetModel isDeatil:(BOOL)flag{
    if (!tweetModel) return nil;
    self = [super init];
    _tweetModel = tweetModel;
    _isDetail = flag;
    [self layout];
    return self;
}

- (void)layout {
    [self _layout];
}

- (void)updateDate {
    //[self _layoutSource];
}

- (void)_layout {
    
    _marginTop = kWBCellTopMargin;
    _profileHeight = 0;
    _textHeight = 0;

    _picHeight = 0;
    _toolbarHeight = kWBCellToolbarHeight;
    _marginBottom = kWBCellToolbarBottomMargin;
    
    
    // 文本排版，计算布局
    [self _layoutProfile];
    [self _layoutPics];

    [self _layoutText];
    [self _layoutToolbar];
    
    
    if (!_isDetail) {
        //点赞，评论布局
        [self _layoutLikeUser];
        [self _layoutCommentList];
    }

    //发布时间
    [self _layoutPostTime];
    
    // 计算高度
    _totalHeight = 0;
    _totalHeight += _marginTop;
    _totalHeight += _profileHeight;
    _totalHeight += _textHeight;
    
    //布局视频View
    if (_tweetModel.tweetVideoArray.count > 0) {
       _videoHeight = KWBVideoHeight;
       _totalHeight += KWBVideoHeight + 8;
    }else{
        _videoHeight = 0;
    }
    
    //布局语音View
    if (_tweetModel.tweetVoiceArray.count > 0) {
        _voiceHeight = KWBVoiceHeight;
        _totalHeight += KWBVoiceHeight + 8;
    }else{
        _voiceHeight = 0;
    }
    
    //判断是否显示展开按钮，和高度计算
    if (_isShowExpendButton) {
        _totalHeight += KWBExpendButtonHeight + 8;
    }

    if (_picHeight > 0) {
        _totalHeight += _picHeight;
    }
 
    if (_picHeight > 0 ) {
        _totalHeight += kWBCellPadding;
    }
    
    if (!_isDetail) {
        _totalHeight += _likeUserHeight;
        _totalHeight += _commentHeight;
        
        if (_likeUserHeight > 0 || _commentHeight > 0) {
            _totalHeight +=  KWBBeginNameHeight + KWBCommentPadding;
        }
    }
    
    if (_textHeight == 0 && _picHeight > 0) {
        _totalHeight += 6;
    }
    
    _totalHeight += _toolbarHeight;
    _totalHeight += _marginBottom;
}


- (void)_layoutProfile {
    [self _layoutName];
    [self _layoutSource];
    _profileHeight = kWBCellProfileHeight;
}

//发布时间
- (void)_layoutPostTime{
    NSMutableAttributedString *sourceText = [NSMutableAttributedString new];
    NSString *postTime = _tweetModel.post_time;
    

    if (postTime.length) {
        NSMutableAttributedString *timeText = [[NSMutableAttributedString alloc] initWithString:postTime];
        [timeText yy_appendString:@"  "];
        timeText.yy_font = [UIFont systemFontOfSize:kWBCellSourceFontSize];
        if ([postTime isEqualToString:@"发送失败"] ||[postTime isEqualToString:@"正在上传"] ) {
           timeText.yy_color = kWBCellTimeOrangeColor;
        }else{
           timeText.yy_color = kWBCellTimeNormalColor;
        }
        
        timeText.yy_alignment = NSTextAlignmentRight;
        [sourceText appendAttributedString:timeText];
    }
    
    if (sourceText.length == 0) {
        _timeTextLayout = nil;
    } else {
        YYTextContainer *container = [YYTextContainer containerWithSize:CGSizeMake(80, 9999)];
        container.maximumNumberOfRows = 1;
        _timeTextLayout = [YYTextLayout layoutWithContainer:container text:sourceText];
    }
}


//名字
- (void)_layoutName{

    NSString *nameStr = nil;
    if (_tweetModel.nick_name.length) {
        nameStr = _tweetModel.nick_name;
    }
    if (nameStr.length == 0) {
        _nickNameTextLayout = nil;
        return;
    }
    NSMutableAttributedString *nameText = [[NSMutableAttributedString alloc] initWithString:nameStr];
    
    
    // 男性
    if ([_tweetModel.sex isEqualToString:@"男"]) {
     UIImage *manImage = [UIImage imageNamed:@"h2x_04"];
     NSAttributedString *blueVText = [self _attachmentWithFontSize:kWBCellNameFontSize image:manImage shrink:NO];
     [nameText yy_appendString:@" "];
     [nameText appendAttributedString:blueVText];
     }
     
     // 女性
     if ([_tweetModel.sex isEqualToString:@"女"]) {
     UIImage *womenImage = [UIImage imageNamed:@"h2x_05"];
     NSAttributedString *vipText = [self _attachmentWithFontSize:kWBCellNameFontSize image:womenImage shrink:NO];
     [nameText yy_appendString:@" "];
     [nameText appendAttributedString:vipText];
     }
    
    nameText.yy_font = [UIFont systemFontOfSize:kWBCellNameFontSize];
    nameText.yy_color = kWBCellNameNormalColor;
    nameText.yy_lineBreakMode = NSLineBreakByCharWrapping;
    
    YYTextContainer *container = [YYTextContainer containerWithSize:CGSizeMake(kWBCellNameWidth, 9999)];
    container.maximumNumberOfRows = 1;
    _nickNameTextLayout = [YYTextLayout layoutWithContainer:container text:nameText];
}

//地址和来源
- (void)_layoutSource {
    
    NSMutableAttributedString *sourceText = [NSMutableAttributedString new];
    NSString *postLocation = _tweetModel.community_name;
    
    //发布地址
    if (postLocation.length) {
        NSMutableAttributedString *locationText = [[NSMutableAttributedString alloc] initWithString:postLocation];
        [locationText yy_appendString:@"  "];
        locationText.yy_font = [UIFont systemFontOfSize:kWBCellSourceFontSize];
        locationText.yy_color = kWBCellTimeNormalColor;
        [sourceText appendAttributedString:locationText];
    }
    
    if (sourceText.length == 0) {
        _locationTextLayout = nil;
    } else {
        YYTextContainer *container = [YYTextContainer containerWithSize:CGSizeMake(kWBCellNameWidth, 9999)];
        container.maximumNumberOfRows = 1;
        _locationTextLayout = [YYTextLayout layoutWithContainer:container text:sourceText];
    }
}

//文本
- (void)_layoutText {
    _textHeight = 0;
    _textLayout = nil;
    
    NSMutableAttributedString *text = [self _textWithStatus:_tweetModel
                                                  isRetweet:NO
                                                   fontSize:kWBCellTextFontSize
                                                  textColor:kWBCellTextNormalColor];

    
    if (text.length == 0) return;
    
    WBTextLinePositionModifier *modifier = [WBTextLinePositionModifier new];
    modifier.font = [UIFont fontWithName:@"Heiti SC" size:kWBCellTextFontSize];
    modifier.paddingTop = kWBCellPaddingText;
    modifier.paddingBottom = kWBCellPaddingText;
    
    YYTextContainer *container = [YYTextContainer new];
    container.size = CGSizeMake(kWBCellContentWidth, HUGE);
    container.linePositionModifier = modifier;
    
    //计算文本的行数,判断显示6行，还是显示完全
    YYTextLayout *tmpTextLayout = [YYTextLayout layoutWithContainer:container text:text];
    NSUInteger rowCount = tmpTextLayout.rowCount;
    
    //判断是否是详情界面
    if (_isDetail) {
        _isShowExpendButton = NO;
    }else{
        //判断是否隐藏展开按钮
        if (rowCount > 6) {
            _isShowExpendButton = YES;
            
            //判断展开或者收起状态
            if (_isExpend == NO) {
                container.maximumNumberOfRows = 6;
                _expendButtonTitle = @"全文";
            }else{
                _expendButtonTitle = @"收起";
            }
        }else{
            _isShowExpendButton = NO;
        }
    }
    
    _textLayout = [YYTextLayout layoutWithContainer:container text:text];
    if (!_textLayout) return;
    _textHeight = [modifier heightForLineCount:_textLayout.rowCount];
}


- (void)_layoutPics {
    [self _layoutPicsWithStatus:_tweetModel isRetweet:NO];
}


- (void)_layoutPicsWithStatus:(MLTweetModel *)status isRetweet:(BOOL)isRetweet {

    _picSize = CGSizeZero;
    _picHeight = 0;

    if (status.tweetPictureArray.count == 0) return;
    
    CGSize picSize = CGSizeZero;
    CGFloat picHeight = 0;
    
    CGFloat len1_3 = (kWBCellContentWidth + kWBCellPaddingPic) / 3 - kWBCellPaddingPic;
    len1_3 = CGFloatPixelRound(len1_3);
    switch (status.tweetPictureArray.count) {
        case 1: {
            TweetPictureModel *pic = _tweetModel.tweetPictureArray.firstObject;
            
            if (pic.ico_width < 1 || pic.ico_height < 1) {
                CGFloat maxLen = kWBCellContentWidth / 2.0;
                maxLen = CGFloatPixelRound(maxLen);
                picSize = CGSizeMake(maxLen, maxLen);
                picHeight = maxLen;
            } else {
                CGFloat maxLen = len1_3 * 2 + kWBCellPaddingPic;
                if (pic.ico_width < pic.ico_height) {
                    picSize.width = (float)pic.ico_width / (float)pic.ico_height * maxLen;
                    picSize.height = maxLen;
                } else {
                    picSize.width = maxLen;
                    picSize.height = (float)pic.ico_height / (float)pic.ico_width * maxLen;
                }
                picSize = CGSizePixelRound(picSize);
                picHeight = picSize.height;
            }
        } break;
        case 2: case 3: {
            picSize = CGSizeMake(len1_3, len1_3);
            picHeight = len1_3;
        } break;
        case 4: case 5: case 6: {
            picSize = CGSizeMake(len1_3, len1_3);
            picHeight = len1_3 * 2 + kWBCellPaddingPic;
        } break;
        default: { // 7, 8, 9
            picSize = CGSizeMake(len1_3, len1_3);
            picHeight = len1_3 * 3 + kWBCellPaddingPic * 2;
        } break;
    }
    
    _picSize = picSize;
    _picHeight = picHeight;

}


//布局喜欢的View
- (void)_layoutLikeUser{
    @weakify(self);
    _likeUserHeight = 0;
    _likeUserTextLayout = nil;
    
    NSMutableAttributedString *likeUserStr = [[NSMutableAttributedString alloc]init];
    [_tweetModel.likesArray enumerateObjectsUsingBlock:^(TweetLikeModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        TweetLikeModel *userModel = obj;
        [likeUserStr yy_appendString:userModel.nick_name];
        if (idx < _tweetModel.likesArray.count - 1) {
            [likeUserStr yy_appendString:@","];
        }
    }];
    
    //添加高亮点击事件
    __block CGFloat userLength = 0;
    [_tweetModel.likesArray enumerateObjectsUsingBlock:^(TweetLikeModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        TweetLikeModel *userModel = obj;
        //点击名字进入个人详情
        [likeUserStr yy_setTextHighlightRange:NSMakeRange(userLength + idx, userModel.nick_name.length) color:RGBMAIN backgroundColor:[UIColor lightGrayColor] tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
            
            if (weak_self.DidClickedLikeUser) {
                weak_self.DidClickedLikeUser(userModel);
            }
        }];
        userLength += userModel.nick_name.length;
    }];

    likeUserStr.yy_color = RGBMAIN;
    likeUserStr.yy_font = [UIFont systemFontOfSize:14.5];
    
    if (likeUserStr.length == 0) return;
    
    WBTextLinePositionModifier *modifier = [WBTextLinePositionModifier new];
    modifier.font = [UIFont fontWithName:@"Heiti SC" size:kWBCellTextFontSize];
    modifier.paddingTop = kWBCellPaddingText;
    modifier.paddingBottom = kWBCellPaddingText;
    
    YYTextContainer *container = [YYTextContainer new];
    container.size = CGSizeMake(kWBCellContentWidth - 10 - 8 - 20, HUGE);
    container.linePositionModifier = modifier;
    
    _likeUserTextLayout = [YYTextLayout layoutWithContainer:container text:likeUserStr];
    if (!_likeUserTextLayout) return;
    
    _likeUserHeight = [modifier heightForLineCount:_likeUserTextLayout.rowCount];
    
}

//布局评论的列表
- (void)_layoutCommentList{
    _commentHeight = 0;
    _commentHeight = [self commentListViewHeightWithTweet:_tweetModel];
    
    if (_tweetModel.likesArray.count == 0 && _tweetModel.commentArray.count == 0) {
        _beginViewIsShow = NO;
        _commentHeight = 0;
        _likeUserHeight = 0;
    }else{
        _beginViewIsShow = YES;
   }
}

//计算评论列表tableView的高度
- (CGFloat)commentListViewHeightWithTweet:(MLTweetModel *)tweet{
    if (!tweet) {
        return 0;
    }
    CGFloat commentListViewHeight = 0;
    NSInteger numOfComments = tweet.commentArray.count;
    
    for (int i = 0; i < numOfComments; i++) {
      commentListViewHeight += [MLTweetCommentCell cellHeightWithModel:tweet.commentArray[i]];
    }
    return commentListViewHeight;
}

- (void)_layoutToolbar {
    // should be localized
    UIFont *font = [UIFont systemFontOfSize:kWBCellToolbarFontSize];
    YYTextContainer *container = [YYTextContainer containerWithSize:CGSizeMake(kScreenWidth, kWBCellToolbarHeight)];
    container.maximumNumberOfRows = 1;
    
    NSMutableAttributedString *likeText = [[NSMutableAttributedString alloc] initWithString:@"点赞"];
    likeText.yy_font = font;
    likeText.yy_color =  kWBCellToolbarTitleColor;
    _toolbarRepostTextLayout = [YYTextLayout layoutWithContainer:container text:likeText];
    _toolbarRepostTextWidth = CGFloatPixelRound(_toolbarRepostTextLayout.textBoundingRect.size.width);
    
    
    NSMutableAttributedString *commentText = [[NSMutableAttributedString alloc] initWithString:@"评论"];
    commentText.yy_font = font;
    commentText.yy_color = kWBCellToolbarTitleColor;
    _toolbarCommentTextLayout = [YYTextLayout layoutWithContainer:container text:commentText];
    _toolbarCommentTextWidth = CGFloatPixelRound(_toolbarCommentTextLayout.textBoundingRect.size.width);
    
    
    NSMutableAttributedString *repostText = [[NSMutableAttributedString alloc] initWithString: @"分享"];
    repostText.yy_font = font;
    repostText.yy_color = kWBCellToolbarTitleColor;
    _toolbarLikeTextLayout = [YYTextLayout layoutWithContainer:container text:repostText];
    _toolbarLikeTextWidth = CGFloatPixelRound(_toolbarLikeTextLayout.textBoundingRect.size.width);
}

- (NSMutableAttributedString *)_textWithStatus:(MLTweetModel *)status
                                     isRetweet:(BOOL)isRetweet
                                      fontSize:(CGFloat)fontSize
                                     textColor:(UIColor *)textColor {
    if (!status) return nil;
    
    NSString *tweetText = status.news_content;
    NSMutableString *string = tweetText.mutableCopy;
    if (string.length == 0) return nil;
    if (isRetweet) {
        NSString *name = status.nick_name;
        if (name.length == 0) {
            name = status.nick_name;
        }
        if (name) {
            NSString *insert = [NSString stringWithFormat:@"@%@:",name];
            [string insertString:insert atIndex:0];
        }
    }
    
    UIFont *font = [UIFont systemFontOfSize:fontSize];
    NSMutableAttributedString *tmpString = [string convertToEmotionWithFont:font normalColor:textColor];
    return tmpString;
}


- (NSAttributedString *)_attachmentWithFontSize:(CGFloat)fontSize image:(UIImage *)image shrink:(BOOL)shrink {
  
    // Heiti SC 字体。。
    CGFloat ascent = fontSize * 0.86;
    CGFloat descent = fontSize * 0.14;
    CGRect bounding = CGRectMake(0, -0.14 * fontSize, fontSize, fontSize);
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(ascent - (bounding.size.height + bounding.origin.y), 0, descent + bounding.origin.y, 0);
    
    YYTextRunDelegate *delegate = [YYTextRunDelegate new];
    delegate.ascent = ascent;
    delegate.descent = descent;
    delegate.width = bounding.size.width;
    
    YYTextAttachment *attachment = [YYTextAttachment new];
    attachment.contentMode = UIViewContentModeScaleAspectFit;
    attachment.contentInsets = contentInsets;
    attachment.content = image;
    
    if (shrink) {
        // 缩小~
        CGFloat scale = 1 / 10.0;
        contentInsets.top += fontSize * scale;
        contentInsets.bottom += fontSize * scale;
        contentInsets.left += fontSize * scale;
        contentInsets.right += fontSize * scale;
        contentInsets = UIEdgeInsetPixelFloor(contentInsets);
        attachment.contentInsets = contentInsets;
    }
    
    NSMutableAttributedString *atr = [[NSMutableAttributedString alloc] initWithString:YYTextAttachmentToken];
    [atr  yy_setTextAttachment:attachment range:NSMakeRange(0, atr.length)];
    CTRunDelegateRef ctDelegate = delegate.CTRunDelegate;
    [atr  yy_setRunDelegate:ctDelegate range:NSMakeRange(0, atr.length)];
    if (ctDelegate) CFRelease(ctDelegate);
    
    return atr;
}

- (WBTextLinePositionModifier *)_textlineModifier {
    static WBTextLinePositionModifier *mod;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mod = [WBTextLinePositionModifier new];
        mod.font = [UIFont fontWithName:@"Heiti SC" size:kWBCellTextFontSize];
        mod.paddingTop = 10;
        mod.paddingBottom = 10;
    });
    return mod;
}

@end
