//
//  UIViewController+ViewControllerTimeProfiler.h
//  VCTimeProfiler
//
//  Created by Su XinDe on 2018/7/17.
//

#import <UIKit/UIKit.h>


@interface VCTimeProfilerKVOObserver : NSObject

@end

@interface VCTimeProfilerKVORemover : NSObject

@property (nonatomic, unsafe_unretained) id target;
@property (nonatomic, copy) NSString *keyPath;

@end


@interface UIViewController (ViewControllerTimeProfiler)

+ (void)bindViewControllerTimeProfiler;

@end
