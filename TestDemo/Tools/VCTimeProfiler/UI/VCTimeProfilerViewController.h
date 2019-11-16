//
//  VCTimeProfilerViewController.h
//  VCTimeProfiler
//
//  Created by SuXinDe on 2018/8/6.
//  Copyright © 2018年 su xinde. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VCTimeProfilerRecorder.h"


@interface CallTraceViewControllerViewModel : NSObject

- (instancetype)initWithViewControllerTimeRecords:(NSArray<VCTimeProfilerRecord *> *)records;

@end



@interface VCTimeProfilerViewController : UIViewController

@end
