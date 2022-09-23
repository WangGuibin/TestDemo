//
//  ViewController.m
//  LocationDemo
//
//  Created by 王贵彬  on 2022/6/9.
//

#import "ViewController.h"
#import "PHTrackPointsManager.h"


#define kLogFunc  [self printLog:[NSString stringWithFormat:@"%s",__FUNCTION__]];

@interface NSArray (SaveJSON)

- (BOOL)saveToDocumentsWithFileName:(NSString *)fileName;
@end


@implementation NSArray (SaveJSON)

- (BOOL)saveToDocumentsWithFileName:(NSString *)fileName{
    NSString *filePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:fileName];
    NSData *data = [NSJSONSerialization dataWithJSONObject:self options:(NSJSONWritingPrettyPrinted) error:nil];
    return [data writeToFile:filePath atomically:NO];
}
@end


@interface ViewController ()

@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) NSMutableString *logStr;
@property (nonatomic,copy) NSString *entity_name;

@end

@implementation ViewController

//MARK: - 日志打印
- (void)printLog:(NSString *)logStr{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSDate *date = [NSDate date];
        NSDateFormatter *dateformat = [[NSDateFormatter  alloc] init];
        [dateformat setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
        NSString *dateStr = [dateformat stringFromDate:date];
        NSString *content = [NSString stringWithFormat:@"\n⌜𝙇𝙊𝘾𝘼𝙏𝙄𝙊𝙉-𝙇𝙊𝙂⌟ Date: %@ >⎽<  \n %@",dateStr,logStr];
        printf("\n%s\n",[content UTF8String]);
        [self.logStr appendString:content];
        self.textView.text = self.logStr;
        [self.textView scrollRangeToVisible:NSMakeRange(self.textView.text.length, 1)];
    });
}

- (void)setupButtonWithY:(CGFloat)lastY
                   title:(NSString *)title
                  action:(SEL)action {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(50, lastY, 200 , 44);
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.backgroundColor = [UIColor blackColor];
    button.layer.cornerRadius = 5;
    button.layer.masksToBounds = YES;
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    kLogFunc
    // Do any additional setup after loading the view.
    [self setupButtonWithY:168 title:@"开启收集定位" action:@selector(startLocation)];
    [self setupButtonWithY:248 title:@"停止收集定位" action:@selector(stopLocation)];


    NSArray *items = @[@"WGS-84",@"BD-09ll",@"GCJ-02"];
    UISegmentedControl *segment = [[UISegmentedControl alloc] initWithItems:items];
    segment.frame = CGRectMake(30, 480, self.view.frame.size.width - 60 , 44);
    segment.selectedSegmentIndex = 0;
    [PHTrackPointsManager shareManager].coordType = PHLocationCoordTypeWGS84;
    [segment addTarget:self action:@selector(changeSelectAction:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:segment];

    self.logStr = @"".mutableCopy;
    self.textView = ({
        CGFloat textY = CGRectGetMaxY(segment.frame) + 50;
        UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(0, textY, self.view.bounds.size.width , self.view.bounds.size.height - textY)];
        textView.editable = NO;
        textView.alwaysBounceVertical = YES;
        textView.backgroundColor = [UIColor blackColor];
        textView.textColor = [UIColor greenColor];
        textView.font = [UIFont boldSystemFontOfSize:12];
        textView;
    });
    [self.view addSubview:self.textView];
    
    /**
     GPS定位减小精度误差的几种处理方法
     https://blog.csdn.net/qq_29098447/article/details/121677863
     */
    
//    [[PHTrackPointsManager shareManager] setCurrentLocationBlock:^(CLLocation * _Nonnull location) {
//        [self printLog:[NSString stringWithFormat:@"%@",location]];
//    }];
    
    [[PHTrackPointsManager shareManager] setPrintInfo:^(NSString * _Nonnull msg) {
        [self printLog:msg];
    }];
}



- (void)changeSelectAction:(UISegmentedControl *)seg{
    [self printLog:[NSString stringWithFormat:@"%s",__FUNCTION__]];
    NSString *msg = [NSString stringWithFormat:@"已选择 %@ 坐标类型",@[@"WGS-84",@"BD-09",@"GCJ-02"][seg.selectedSegmentIndex]];
    [self printLog:msg];
    [self showMessage: msg];
    [PHTrackPointsManager shareManager].coordType = seg.selectedSegmentIndex;
}

- (void)startLocation{
    [self printLog: [NSString stringWithFormat:@"%s",__FUNCTION__]];
    kLogFunc
    
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"自定义路线名" message:@"标识这是走的哪一段路线" preferredStyle:(UIAlertControllerStyleAlert)];
    [alertVC addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请输入路线名称";
        textField.text = @"前海自贸大厦-西乡";
        textField.keyboardType = UIKeyboardTypeDefault;
    }];
    
    [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"开始走!" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        NSString *argStr = [alertVC.textFields.firstObject.text stringByReplacingOccurrencesOfString:@" " withString:@""];
        [self showMessage:@"开启📌"];
        self.entity_name = argStr;
        [[PHTrackPointsManager shareManager] startWithEntryName:argStr];
    }];
    [alertVC addAction:okAction];
    [self presentViewController:alertVC animated:YES completion:nil];
}

- (void)stopLocation{
    kLogFunc
    [self showMessage:@"停止📌"];
    [[PHTrackPointsManager shareManager] stop];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSString *fileName = [NSString stringWithFormat:@"%@.log",self.entity_name];
        NSString *filePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:fileName];
        NSURL *urlToShare = [NSURL fileURLWithPath:filePath];
        [self.logStr writeToURL:urlToShare atomically:NO encoding:NSUTF8StringEncoding error:nil];
    });
}



- (void)showMessage:(NSString *)message {
    UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    messageLabel.textAlignment = NSTextAlignmentCenter;
    messageLabel.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.75];
    messageLabel.textColor = [UIColor whiteColor];
    messageLabel.layer.cornerRadius = 5.0f;
    messageLabel.layer.masksToBounds = YES;
    messageLabel.text = message;
    
    CGSize messageSize = [messageLabel sizeThatFits:self.view.bounds.size];
    messageSize.width += 30;
    messageSize.height += 14;
    messageLabel.frame = CGRectMake((self.view.bounds.size.width-messageSize.width)/2.0f, (self.view.bounds.size.height-messageSize.height)/2.0f, messageSize.width, messageSize.height);
    messageLabel.alpha = 0;
    [self.view addSubview:messageLabel];
    
    [UIView animateWithDuration:0.3 animations:^{
        messageLabel.alpha = 1;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3 delay:1.5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            messageLabel.alpha = 0;
        } completion:^(BOOL finished) {
            [messageLabel removeFromSuperview];
        }];
    }];
}


@end
