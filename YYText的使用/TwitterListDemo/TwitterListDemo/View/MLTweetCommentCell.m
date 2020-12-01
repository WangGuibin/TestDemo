//
//  MLTweetCommentCell.m
//  MeiLin
//
//  Created by 曹学亮 on 2016/10/10.
//  Copyright © 2016年 Li Chuanliang. All rights reserved.
//

#import "MLTweetCommentCell.h"
#import "YYText.h"
#import "MLTweetModel.h"
#import "MLTweetLayouts.h"

@interface MLTweetCommentCell()
@property (nonatomic,strong) YYLabel *commentLabel;
@end

@implementation MLTweetCommentCell
#pragma mark - Init Menthod
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addSubViews];
        
        self.backgroundColor = [UIColor clearColor];
        self.backgroundView = nil;
    }
    return self;
}

- (void)addSubViews{
    @weakify(self);
    _commentLabel = [YYLabel new];
    _commentLabel.left = 8;
    _commentLabel.width = kWBCellContentWidth - 16;
    _commentLabel.textVerticalAlignment = YYTextVerticalAlignmentTop;
    _commentLabel.displaysAsynchronously = NO;
    _commentLabel.ignoreCommonProperties = YES;
    _commentLabel.fadeOnAsynchronouslyDisplay = NO;
    _commentLabel.fadeOnHighlight = NO;
    _commentLabel.highlightTapAction = ^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect) {
        if (weak_self.DidClickedLink) {
            weak_self.DidClickedLink(containerView,text,range,rect);
        }
    };
    [self.contentView addSubview:_commentLabel];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}


#pragma mark - Setter && Getter
- (void)setCommentModel:(TweetCommentModel *)commentModel{
    if (!commentModel) {
        return;
    }
    
    @weakify(self);
    _commentModel = commentModel;
   
    //评论的是微博
     NSMutableAttributedString *commentStr;
    if ([_commentModel.is_replay isEqualToString:@"N"]) {
        commentStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@: ",_commentModel.nick_name]];
        NSMutableAttributedString *emotionString = [_commentModel.comment convertToEmotionWithFont:[UIFont systemFontOfSize:16] normalColor:kWBCellTextNormalColor];
        [commentStr appendAttributedString:emotionString];
        commentStr.yy_font = [UIFont systemFontOfSize:16];
        
    //回复的是用户
    }else if ([_commentModel.is_replay isEqualToString:@"Y"]){
        commentStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@回复%@: ",_commentModel.nick_name,_commentModel.re_nick_name]];
        NSMutableAttributedString *emotionString = [_commentModel.comment convertToEmotionWithFont:[UIFont systemFontOfSize:16] normalColor:kWBCellTextNormalColor];
        [commentStr appendAttributedString:emotionString];
        commentStr.yy_font = [UIFont systemFontOfSize:16];
    }
    
    commentStr.yy_lineBreakMode = NSLineBreakByCharWrapping;
    [commentStr yy_setColor:RGBMAIN range:NSMakeRange(0, _commentModel.nick_name.length)];
    
    if ([_commentModel.is_replay isEqualToString:@"Y"]){
      [commentStr yy_setColor:RGBMAIN range:NSMakeRange(_commentModel.nick_name.length + 2, _commentModel.re_nick_name.length)];
    }
 
    //点击名字进入个人详情
    [commentStr yy_setTextHighlightRange:NSMakeRange(0, _commentModel.nick_name.length) color:RGBMAIN backgroundColor:[UIColor lightGrayColor] tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
        
        if (weak_self.DidClickedUserName) {
            weak_self.DidClickedUserName(commentModel);
        }
    }];
    
    
    //点击回复的名字进个人详情
    if ([_commentModel.is_replay isEqualToString:@"Y"]){
       [commentStr yy_setTextHighlightRange:NSMakeRange(_commentModel.nick_name.length + 2,_commentModel.re_nick_name.length) color:RGBMAIN backgroundColor:[UIColor lightGrayColor] tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
           
           if (weak_self.DidClickedReplyUserName) {
               weak_self.DidClickedReplyUserName(commentModel.reply_member_id);
           }
      }];
    }

    WBTextLinePositionModifier *modifier = [WBTextLinePositionModifier new];
    modifier.font = [UIFont fontWithName:@"Heiti SC" size:kWBCellTextFontSize];
    modifier.paddingTop = KWBCommentPadding;
    modifier.paddingBottom = KWBCommentPadding;
    
    YYTextContainer *container = [YYTextContainer new];
    container.size = CGSizeMake(kWBCellContentWidth - 16, HUGE);
    container.linePositionModifier = modifier;
    
    YYTextLayout *commentLayout = [YYTextLayout layoutWithContainer:container text:commentStr];
    if (!commentLayout) return;
    
    CGFloat commentHeight = [modifier heightForLineCount:commentLayout.rowCount];
    
    _commentLabel.height = commentHeight;
    _commentLabel.top = 0;
    _commentLabel.textLayout = commentLayout;
    
}

+ (CGFloat)cellHeightWithModel:(TweetCommentModel*)model{
    if (!model) {
        return 0;
    }
    
    //评论的是微博
    NSMutableAttributedString *commentStr;
    if ([model.is_replay isEqualToString:@"N"]) {
        commentStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@: ",model.nick_name]];
        NSMutableAttributedString *emotionString = [model.comment convertToEmotionWithFont:[UIFont systemFontOfSize:16] normalColor:kWBCellTextNormalColor];
        [commentStr appendAttributedString:emotionString];
        
        
    //回复的是用户
    }else if ([model.is_replay isEqualToString:@"Y"]){
        commentStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@回复%@: ",model.nick_name,model.re_nick_name]];
        NSMutableAttributedString *emotionString = [model.comment convertToEmotionWithFont:[UIFont systemFontOfSize:16] normalColor:kWBCellTextNormalColor];
        [commentStr appendAttributedString:emotionString];
        
    }
    
    commentStr.yy_font = [UIFont systemFontOfSize:16];
    commentStr.yy_lineBreakMode = NSLineBreakByCharWrapping;
    [commentStr yy_setColor:RGBMAIN range:NSMakeRange(0, model.nick_name.length + 1)];
    
    if ([model.is_replay isEqualToString:@"Y"]){
      [commentStr yy_setColor:RGBMAIN range:NSMakeRange(model.nick_name.length + 2, model.re_nick_name.length)];
    }

    
    WBTextLinePositionModifier *modifier = [WBTextLinePositionModifier new];
    modifier.font = [UIFont fontWithName:@"Heiti SC" size:kWBCellTextFontSize];
    modifier.paddingTop = KWBCommentPadding;
    modifier.paddingBottom = KWBCommentPadding;
    
    YYTextContainer *container = [YYTextContainer new];
    container.size = CGSizeMake(kWBCellContentWidth - 16, HUGE);
    container.linePositionModifier = modifier;
    
    YYTextLayout *commentLayout = [YYTextLayout layoutWithContainer:container text:commentStr];
    
    CGFloat commentHeight = [modifier heightForLineCount:commentLayout.rowCount];
    
    return commentHeight;
}

@end
