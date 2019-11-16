//
//  VCTimeProfilerRecorder.h
//  VCTimeProfiler
//
//  Created by Su XinDe on 2018/8/2.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, VCLifeCycleState) {
    VCLifeCycleStateInit = 0,
    VCLifeCycleStateLoadView,
    VCLifeCycleStateViewDidLoad,
    VCLifeCycleStateViewWillAppear,
    VCLifeCycleStateViewDidAppear,
    VCLifeCycleStateViewWillDisappear,
    VCLifeCycleStateViewDidDisappear,
};

@interface VCTimeProfilerRecord : NSObject

@property (nonatomic, copy) NSString *instancePtr;
@property (nonatomic, copy) NSString *className;
@property (nonatomic, assign) NSTimeInterval recordCreateTimePoint;

@property (nonatomic, assign) NSTimeInterval loadViewTimePoint;
@property (nonatomic, assign) NSTimeInterval viewDidLoadTimePoint;
@property (nonatomic, assign) NSTimeInterval viewDidAppearTimePoint;

- (NSTimeInterval)loadVCTimeCostInMS;

@end

@interface VCTimeProfilerRecorder : NSObject

@property (nonatomic, strong, readonly) NSArray<VCTimeProfilerRecord *> *records;

+ (instancetype)shared;

- (void)start;
- (void)stop;

- (void)recordVCLoadTimeConsume:(UIViewController *)vc
                 lifeCycleState:(VCLifeCycleState)lifeCycleState
                      timePoint:(NSTimeInterval)timePoint;

@end
