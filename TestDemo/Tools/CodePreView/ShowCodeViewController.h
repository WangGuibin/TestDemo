//
//  ShowCodeViewController.h
//
//  Created by 王贵彬 on 2022/9/20.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ShowCodeViewController : UIViewController

@property(nonatomic, copy) NSString *language;
@property(nonatomic, copy) NSString *theme;
@property(nonatomic, copy) NSString *codeText;

@end

NS_ASSUME_NONNULL_END
