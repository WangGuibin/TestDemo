//
// WGBRewardAlertView.h
//
//  Created by mac on 2019/7/19.
//  Copyright © 2019 cool. All rights reserved.
//
/**
 *
 *                #####################################################
 *                #                                                   #
 *                #                       _oo0oo_                     #
 *                #                      o8888888o                    #
 *                #                      88" . "88                    #
 *                #                      (| -_- |)                    #
 *                #                      0\  =  /0                    #
 *                #                    ___/`---'\___                  #
 *                #                  .' \\|     |# '.                 #
 *                #                 / \\|||  :  |||# \                #
 *                #                / _||||| -:- |||||- \              #
 *                #               |   | \\\  -  #/ |   |              #
 *                #               | \_|  ''\---/''  |_/ |             #
 *                #               \  .-\__  '-'  ___/-. /             #
 *                #             ___'. .'  /--.--\  `. .'___           #
 *                #          ."" '<  `.___\_<|>_/___.' >' "".         #
 *                #         | | :  `- \`.;`\ _ /`;.`/ - ` : | |       #
 *                #         \  \ `_.   \_ __\ /__ _/   .-` /  /       #
 *                #     =====`-.____`.___ \_____/___.-`___.-'=====    #
 *                #                       `=---='                     #
 *                #     ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~   #
 *                #                                                   #
 *                #               佛祖保佑         永无BUG              #
 *                #                                                   #
 *                #####################################################
 */



#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WGBRewardAlertView : UIView



/**
 * `canPay` 能否支付，为NO则去充值页面，YES则调起支付
 * `money` 打赏金额数
 * `message` 留言
 */

@property (nonatomic,copy) void(^confirmBlock) (BOOL canPay,NSString *money,NSString * message);
@property (nonatomic,copy) dispatch_block_t cancelBlock;
//余额 从外界传 或者 单例获取
@property (nonatomic,assign) double balanceValue;

@end

NS_ASSUME_NONNULL_END
