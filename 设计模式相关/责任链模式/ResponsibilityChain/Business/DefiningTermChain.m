//
//  DefiningTermChain.m
//  NeoTV
//
//  Created by neotv on 2018/6/15.
//  Copyright © 2018年 iOS. All rights reserved.
//

#import "DefiningTermChain.h"
#import "DJQTextFiledTitleView.h"

@interface DefiningTermChain ()

@property (nonatomic, strong) NSString *errorMessage;

@end

@implementation DefiningTermChain

- (ResponsibilityMessage *)canPassThrough {
    
    if ([self.object isKindOfClass:DJQTextFiledTitleView.class]){
        DJQTextFiledTitleView *titleView  = self.object;
        ResponsibilityMessage *message   = [ResponsibilityMessage new];
        message.object                   = self.object;
        message.checkSuccess             = YES;
        
        if ([titleView.modelDicKey isEqualToString:@"qq"]) {
            if (titleView.field.text.length < 5) {
                message.errorMessage = @"QQ号最低五位";
                message.checkSuccess = NO;
            }
        }
        
        
        if (titleView.field.text.length <= 0) {
            
            message.errorMessage = [NSString stringWithFormat:@"%@输入不能为空", self.errorMessage];
            message.checkSuccess = NO;
            
        }
        
        if ([titleView.modelDicKey isEqualToString:@"mobile"]) {
            if (titleView.field.text.length > 11) {
                message.errorMessage = @"手机号不合法";
                message.checkSuccess = NO;
            }
        }
        
        return message;
    }else {
        UITextField           *field   = self.object;
        ResponsibilityMessage *message  = [ResponsibilityMessage new];
        message.object                  = self.object;
        message.checkSuccess           = YES;
        
        
        if (field.text.length <= 0) {
            
            message.errorMessage = [NSString stringWithFormat:@"%@输入不能为空", self.errorMessage];
            message.checkSuccess = NO;
            
        }
        
        return message;
    }
}

+ (instancetype)DefiningTermChainWithErrorMessage:(NSString *)string {
    DefiningTermChain *chain = [DefiningTermChain new];
    chain.errorMessage       = string;
    
    return chain;
}
@end
