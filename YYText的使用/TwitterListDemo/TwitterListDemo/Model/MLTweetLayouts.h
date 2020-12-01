//
//  MLTweetLayouts.h
//  MeiLin
//
//  Created by 曹学亮 on 2016/10/9.
//  Copyright © 2016年 Li Chuanliang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MLTweetModel.h"
#import "EmoticonHelper.h"
#import "YYText.h"

/**
 一个 Cell 的布局。
 布局排版应该在后台线程完成。
 */
@interface  MLTweetLayouts: NSObject
- (instancetype)initWithStatus:(MLTweetModel *)tweetModel isDeatil:(BOOL)flag;
- (void)layout;     //计算布局
- (void)updateDate; //更新时间字符串

//----------------------------------以下是数据--------------------------
@property (nonatomic, strong) MLTweetModel *tweetModel;
@property (nonatomic, assign) NSInteger selectIndex;       //当前选中的index
@property (nonatomic, assign) BOOL isExpend;               //是否是展开状态
@property (nonatomic, assign) BOOL isShowExpendButton;     //是否显示展开按钮
@property (nonatomic ,copy)   NSString *expendButtonTitle; //展开按钮名称
@property (nonatomic, assign) BOOL isDetail;               //是否是详情界面


//---------------------------------以下是布局结果------------------------
//顶部留白
@property (nonatomic,assign) CGFloat marginTop;                //顶部灰色留白
@property (nonatomic,strong) YYTextLayout *timeTextLayout;     //发布时间布局

//个人资料
@property (nonatomic,assign) CGFloat profileHeight;            //个人资料高度(包括留白)
@property (nonatomic,strong) YYTextLayout *nickNameTextLayout; //名字布局
@property (nonatomic,strong) YYTextLayout *locationTextLayout; //地址布局

//动态内容
@property (nonatomic, assign) CGFloat textHeight;              //文本高度(包括下方留白)
@property (nonatomic, strong) YYTextLayout *textLayout;        //文本

//图片
@property (nonatomic, assign) CGFloat picHeight;               //图片高度，0为没图片
@property (nonatomic, assign) CGSize picSize;                  //图片大小

//视频
@property (nonatomic, assign) CGFloat videoHeight;             //视频高度

//语音
@property (nonatomic, assign) CGFloat voiceHeight;              //语音高度

//喜欢，评论
@property (nonatomic,assign) CGFloat likeUserHeight;           //点赞高度
@property (nonatomic,assign) CGFloat commentHeight;            //评论高度
@property (nonatomic,assign) BOOL beginViewIsShow;             //开始图片是否显示
@property (nonatomic,strong) YYTextLayout *likeUserTextLayout; //点赞user布局
@property (nonatomic,copy) void(^DidClickedLikeUser)(TweetLikeModel *likeModel);

//工具栏
@property (nonatomic, assign) CGFloat toolbarHeight; //工具栏高度
@property (nonatomic, strong) YYTextLayout *toolbarRepostTextLayout;
@property (nonatomic, strong) YYTextLayout *toolbarCommentTextLayout;
@property (nonatomic, strong) YYTextLayout *toolbarLikeTextLayout;
@property (nonatomic, assign) CGFloat toolbarRepostTextWidth;
@property (nonatomic, assign) CGFloat toolbarCommentTextWidth;
@property (nonatomic, assign) CGFloat toolbarLikeTextWidth;

//下边留白
@property (nonatomic, assign) CGFloat marginBottom; //下边留白

//总高度
@property (nonatomic, assign) CGFloat totalHeight;  //动态cell总高度
@end


/**
 文本 Line 位置修改
 将每行文本的高度和位置固定下来，不受中英文/Emoji字体的 ascent/descent 影响
 */
@interface WBTextLinePositionModifier : NSObject <YYTextLinePositionModifier>
@property (nonatomic, strong) UIFont *font;               //基准字体
@property (nonatomic, assign) CGFloat paddingTop;         //文本顶部留白
@property (nonatomic, assign) CGFloat paddingBottom;      //文本底部留白
@property (nonatomic, assign) CGFloat lineHeightMultiple; //行距倍数
- (CGFloat)heightForLineCount:(NSUInteger)lineCount;
@end

