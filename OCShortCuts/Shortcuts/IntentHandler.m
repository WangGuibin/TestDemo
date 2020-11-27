//
//  IntentHandler.m
//  Shortcuts
//
//  Created by mac on 2020/11/27.
//

#import "IntentHandler.h"
#import "MarkUppercaseIntent.h"

// As an example, this class is set up to handle Message intents.
// You will want to replace this or add other intents as appropriate.
// The intents you wish to handle must be declared in the extension's Info.plist.

// You can test your example integration by saying things to Siri like:
// "Send a message using <myApp>"
// "<myApp> John saying hello"
// "Search for messages in <myApp>"

/// 创建intents 然后添加属性.返回成功失败结果等字段
/// 编译生成模板 每次得重新卸载APP 清Xcode缓存才会生效 遵守模板类里协议 如下: 一个小写转大写的action即可完成
/// 参考了外国大佬文章 https://toolboxpro.app/blog/adding-shortcuts-to-an-app-1   用的swiftUI, OC方面的资料实在太少了


@interface IntentHandler () <MarkUppercaseIntentHandling>

@end

@implementation IntentHandler

- (id)handlerForIntent:(INIntent *)intent {
    // This is the default implementation.  If you want different objects to handle different intents,
    // you can override this and return the handler you want for that particular intent.
//    return [MarkUppercaseIntent new];
    return self;
}

/*!
 @abstract Handling method - Execute the task represented by the MarkUppercaseIntent that's passed in
 @discussion Called to actually execute the intent. The app must return a response for this intent.

 @param  intent The input intent
 @param  completion The response handling block takes a MarkUppercaseIntentResponse containing the details of the result of having executed the intent

 @see  MarkUppercaseIntentResponse
 */
- (void)handleMarkUppercase:(MarkUppercaseIntent *)intent completion:(void (^)(MarkUppercaseIntentResponse *response))completion {
    NSString *text = intent.text;
    if (text) {
        text = [text uppercaseString];
        completion([MarkUppercaseIntentResponse successIntentResponseWithResult:text]);
    }else{
        completion([MarkUppercaseIntentResponse failureIntentResponseWithError:@"转化失败,输入内容不合法"]);
    }
}

/*!
@abstract Resolution methods - Determine if this intent is ready for the next step (confirmation)
@discussion Called to make sure the app extension is capable of handling this intent in its current form. This method is for validating if the intent needs any further fleshing out.

@param  intent The input intent
@param  completion The response block contains an INIntentResolutionResult for the parameter being resolved

@see INIntentResolutionResult
*/
- (void)resolveTextForMarkUppercase:(MarkUppercaseIntent *)intent withCompletion:(void (^)(MarkUppercaseTextResolutionResult *resolutionResult))completion {
    NSString *text = intent.text;
    if (text) {
        MarkUppercaseTextResolutionResult *success = [MarkUppercaseTextResolutionResult successWithResolvedString:text];
        completion(success);
    }else{
        MarkUppercaseTextResolutionResult *error = [MarkUppercaseTextResolutionResult unsupportedForReason:MarkUppercaseTextUnsupportedReasonReason];
        completion(error);
    }
}

@end
