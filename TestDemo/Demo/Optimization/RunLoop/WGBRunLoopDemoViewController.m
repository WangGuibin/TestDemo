//
// WGBRunLoopDemoViewController.m
// TestDemo
//
// Author:  @CoderWGB
// Github:  https://github.com/WangGuibin/TestDemo
// E-mail:  864562082@qq.com
//
// Created by CoderWGB on 2019/12/18
//
/**
Copyright (c) 2019 Wangguibin  

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
*/
    

#import "WGBRunLoopDemoViewController.h"

// cell高度
static const CGFloat kCellHeight = 150.f;
// cell边框宽度
static const CGFloat kCellBorderWidth = 10.f;


@interface WGBRunLoopDemoViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
// 装任务的Arr
@property (nonatomic, strong) NSMutableArray *tasksArr;
// 最大任务数
@property (nonatomic, assign) NSUInteger maxTaskCount;

@end

@implementation WGBRunLoopDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 模拟器效果不明显  必须真机
    
    // 可以自己设置最大任务数量(我这里是当前页面最多同时显示几张照片)
    self.maxTaskCount = 50;
    [self.view addSubview:self.tableView];

    // 创建定时器 (保证runloop回调函数一直在执行)
    CADisplayLink *displayLink = [CADisplayLink displayLinkWithTarget:self
                                                             selector:@selector(notDoSomething)];
    [displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];

    //添加runloop观察者
    [self addRunloopObserver];
}

- (void)notDoSomething{
    //不做任何事 只为了runloop保活(保证runloop回调函数一直在执行)
}


///MARK:- <UITableViewDelegate && UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2000;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    
    for (UIView *sub in cell.subviews) {
        if ([sub isMemberOfClass:[UIImageView class]]) {
            [sub removeFromSuperview];
        }
    }
    
    CGFloat width = (self.view.bounds.size.width-4*kCellBorderWidth) /3;
    // 耗时操作可以放在任务中
    [self addTasks:^{
        UIImageView *img1 = [[UIImageView alloc] initWithFrame:CGRectMake(kCellBorderWidth,kCellBorderWidth,width,kCellHeight-kCellBorderWidth)];
        img1.image = [UIImage imageNamed:@"Blue Pond.jpg"];
        [cell addSubview:img1];
    }];
    [self addTasks:^{
        UIImageView *img2 = [[UIImageView alloc] initWithFrame:CGRectMake(width+2*kCellBorderWidth,kCellBorderWidth,width,kCellHeight-kCellBorderWidth)];
        img2.image = [UIImage imageNamed:@"El Capitan 2.jpg"];
        [cell addSubview:img2];
    }];
    [self addTasks:^{
        UIImageView *img3 = [[UIImageView alloc] initWithFrame:CGRectMake(2*width+3*kCellBorderWidth,kCellBorderWidth,width,kCellHeight-kCellBorderWidth)];
        img3.image = [UIImage imageNamed:@"El Capitan.jpg"];
        [cell addSubview:img3];
    }];
    
    return cell;
}


///MARK:- 添加任务
- (void)addTasks:(dispatch_block_t)task {
    // 保存新任务
    [self.tasksArr addObject:task];
    // 如果超出最大任务数 丢弃之前的任务  超出范围则挤掉从最开始的任务开始挤掉
    if (self.tasksArr.count > self.maxTaskCount) {
        [self.tasksArr removeObjectAtIndex:0];
    }
}

// 添加runloop观察者
- (void)addRunloopObserver {
    // 1.获取当前Runloop
    CFRunLoopRef runloop = CFRunLoopGetCurrent();
    
    // 2.创建观察者
    // 2.0 定义上下文
    CFRunLoopObserverContext context = {
        0,
        (__bridge void *)(self),
        &CFRetain,
        &CFRelease,
        NULL
    };
    
    // 2.1 定义观察者
    static CFRunLoopObserverRef defaultModeObserver;
    // 2.2 创建观察者
    
//    typedef CF_OPTIONS(CFOptionFlags, CFRunLoopActivity) {
//        kCFRunLoopEntry         = (1UL << 0), // 即将进入Loop
//        kCFRunLoopBeforeTimers  = (1UL << 1), // 即将处理 Timer
//        kCFRunLoopBeforeSources = (1UL << 2), // 即将处理 Source
//        kCFRunLoopBeforeWaiting = (1UL << 5), // 即将进入休眠
//        kCFRunLoopAfterWaiting  = (1UL << 6), // 刚从休眠中唤醒
//        kCFRunLoopExit          = (1UL << 7), // 即将退出Loop
//        kCFRunLoopAllActivities = 0x0FFFFFFFU // 所有事件
//    };

    defaultModeObserver = CFRunLoopObserverCreate(kCFAllocatorDefault,
                                                  kCFRunLoopBeforeWaiting,
                                                  YES,
                                                  0,
                                                  &callBack,
                                                  &context);
   
    // 3. 给当前Runloop添加观察者
    // CFRunLoopMode mode : 设置任务执行的模式
    CFRunLoopAddObserver(runloop, defaultModeObserver, kCFRunLoopCommonModes);
    
    // C中出现 copy,retain,Create等关键字,都需要release
    CFRelease(defaultModeObserver);
}


static void callBack(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info) {
    
    WGBRunLoopDemoViewController *vc = (__bridge WGBRunLoopDemoViewController *)info;
    // 无任务  退出
    if (vc.tasksArr.count == 0) return;
    // 从数组中取出任务
    dispatch_block_t block = [vc.tasksArr firstObject];
    // 执行任务
    if (block) {
        block();
    }
    // 执行完任务之后移除任务
    [vc.tasksArr removeObjectAtIndex:0];
}


- (NSMutableArray *)tasksArr {
    if (!_tasksArr) {
        _tasksArr = [[NSMutableArray alloc] init];
    }
    return _tasksArr;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.tableHeaderView = [UIView new];
        _tableView.tableFooterView = [UIView new];
        _tableView.rowHeight = kCellHeight;
        _tableView.delegate =self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

@end
