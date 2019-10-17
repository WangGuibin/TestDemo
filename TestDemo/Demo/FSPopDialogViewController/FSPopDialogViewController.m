//
//  FSPopDialogViewController.m
//  PopDialog
//
//  Created by Zhefu Wang on 13-7-23.
//  Copyright (c) 2013年 Finder Studio. All rights reserved.
//

#import "FSPopDialogViewController.h"
#import <QuartzCore/QuartzCore.h>

#define TLSWAP(A,B) do{\
__typeof__(A) __tmp = (A);\
A = B;\
B = __tmp;\
}while(0)

@interface FSPopDialogViewController ()

@property (nonatomic, strong) UIView *backGroundView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *questionLabel;
@property (nonatomic, strong) UIButton *okButton;
@property (nonatomic, strong) UIButton *cancelButton;

@end

@implementation FSPopDialogViewController

- (UIView*)backGroundView
{
    if (!_backGroundView)
    {
        _backGroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [FSPopDialogViewController getApplicationFrameSize].width, [FSPopDialogViewController getApplicationFrameSize].height)];
        _backGroundView.backgroundColor = [UIColor blackColor];
        _backGroundView.alpha = 0.1;
    }
    return _backGroundView;
}

- (UILabel*)titleLabel
{
    if (!_titleLabel)
    {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.contentMode = UIViewContentModeScaleAspectFill;//UIViewContentModeCenter;
        _titleLabel.backgroundColor = [UIColor colorWithRed:0 green:0 blue:1 alpha:0.5f];
        _titleLabel.numberOfLines = 1;
        _titleLabel.adjustsFontSizeToFitWidth=YES;
        _titleLabel.minimumScaleFactor = 0.5;
        _titleLabel.font = [UIFont fontWithName:@"Helvetica" size:25];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin);
    }
    _titleLabel.text = self.dialogViewTitle;
    
    return _titleLabel;
}

- (UILabel*)questionLabel
{
    if (!_questionLabel)
    {
        _questionLabel = [[UILabel alloc] init];
        _questionLabel.backgroundColor = [UIColor clearColor];
        _questionLabel.numberOfLines = 0;
        _questionLabel.contentMode = UIViewContentModeScaleAspectFill;
        _questionLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    }
    _questionLabel.text = self.question;
    
    return _questionLabel;
}

+ (CGSize)getApplicationFrameSize
{
    CGSize size = [UIScreen mainScreen].applicationFrame.size;
    UIInterfaceOrientation deviceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (deviceOrientation == UIInterfaceOrientationLandscapeLeft || deviceOrientation == UIInterfaceOrientationLandscapeRight)
    {
        TLSWAP(size.width, size.height);
    }
    return size;
}

+ (UIColor *)colorWithHex:(long)hexColor alpha:(CGFloat)opacity
{
    CGFloat red = ((CGFloat)((hexColor & 0xFF0000) >> 16))/255.0;
    CGFloat green = ((CGFloat)((hexColor & 0xFF00) >> 8))/255.0;
    CGFloat blue = ((CGFloat)(hexColor & 0xFF))/255.0;
    return [UIColor colorWithRed:red green:green blue:blue alpha:opacity];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.view.backgroundColor = [UIColor whiteColor];
    CGRect frame;
    switch (self.popDialogStyle)
    {
        case FSPopDialogStylePop:
            frame = CGRectMake([FSPopDialogViewController getApplicationFrameSize].width/2, [FSPopDialogViewController getApplicationFrameSize].height/2, 1, 1);
            break;
        case FSPopDialogStyleFromBottom:
            frame = CGRectMake(([FSPopDialogViewController getApplicationFrameSize].width-self.size.width)/2, [FSPopDialogViewController getApplicationFrameSize].height, self.size.width, self.size.height);
            break;
        case FSPopDialogStyleFromTop:
            frame = CGRectMake(([FSPopDialogViewController getApplicationFrameSize].width-self.size.width)/2, -self.size.height, self.size.width, self.size.height);
            break;
        case FSPopDialogStyleFromLeft:
            frame = CGRectMake(-self.size.width, ([FSPopDialogViewController getApplicationFrameSize].height-self.size.height)/2, self.size.width, self.size.height);
            break;
        case FSPopDialogStyleFromRight:
            frame = CGRectMake([FSPopDialogViewController getApplicationFrameSize].width, ([FSPopDialogViewController getApplicationFrameSize].height-self.size.height)/2, self.size.width, self.size.height);
            break;
        default:
            break;
    }
    
    self.view.frame = frame;
    
    self.okButton = [[UIButton alloc] initWithFrame:CGRectMake(5, self.size.height-55, self.size.width/2-7.5, 50)];
    self.cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(self.size.width/2+2.5, self.size.height-55, self.size.width/2-7.5, 50)];
    self.titleLabel.frame = CGRectMake(0, 0,self.view.bounds.size.width,40);
    self.questionLabel.frame = CGRectMake(5, self.size.height/2-120, self.view.bounds.size.width, 200);
    [self.okButton setTitle:self.okButtonTitle forState:UIControlStateNormal];
    self.okButton.backgroundColor = [FSPopDialogViewController colorWithHex:0x287dea alpha:1.0];
    self.cancelButton.backgroundColor = [UIColor orangeColor];
    [self.cancelButton setTitle:self.cancelButtonTitle forState:UIControlStateNormal];
    [self.okButton addTarget:self action:@selector(okButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
    [self.cancelButton addTarget:self action:@selector(cancelButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
    
    self.view.layer.masksToBounds = NO;
    self.view.layer.cornerRadius = 8;
    self.view.layer.shadowOffset = CGSizeMake(10, 10);
    self.view.layer.shadowRadius = 5;
    self.view.layer.shadowOpacity = 0.5;
    
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.questionLabel];
    [self.view addSubview:self.okButton];
    [self.view addSubview:self.cancelButton];

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)appear
{
    [self.delegate.view addSubview:self.backGroundView];
    [self.delegate.view addSubview:self.view];

    switch (self.popDialogStyle)
    {
        case FSPopDialogStylePop:
            [self popDialogViewAnimationPop];
            break;
        case FSPopDialogStyleFromBottom:
            [self popDialogViewAnimationFromBottom];
            break;
        case FSPopDialogStyleFromTop:
            [self popDialogViewAnimationFromTop];
            break;
        case FSPopDialogStyleFromRight:
        case FSPopDialogStyleFromLeft:
            [self popDialogViewAnimationFromLeftOrRight];
            break;
        default:
            break;
    }
}

- (void)okButtonTouched:(UIButton*)sender
{
    if (self.okBlock)
        self.okBlock();
}

- (void)cancelButtonTouched:(UIButton*)sender
{
    if (self.cancelBlock)
        self.cancelBlock();
}

- (void)disappear
{
    [self disappearAnimation];
}

- (void)popDialogViewAnimationPop
{
    [UIView animateWithDuration:0.1
                          delay:0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         CGRect frame = CGRectMake(([FSPopDialogViewController getApplicationFrameSize].width-self.size.width)/2-45, ([FSPopDialogViewController getApplicationFrameSize].height-self.size.height)/2-45, self.size.width+90, self.size.height+90);
                         self.view.frame = frame;                         self.backGroundView.alpha = 0.25;
                         self.okButton.frame = CGRectMake(5, frame.size.height-55, frame.size.width/2-7.5, 50);
                         self.cancelButton.frame = CGRectMake(frame.size.width/2+2.5, frame.size.height-55, frame.size.width/2-7.5, 50);
                         self.backGroundView.alpha = 0.2;
                     }
                     completion:^(BOOL finished)
     {
         if (finished)
         {
             [UIView animateWithDuration:0.15
                                   delay:0
                                 options:UIViewAnimationOptionCurveEaseIn
                              animations:^{
                                  CGRect frame = CGRectMake(([FSPopDialogViewController getApplicationFrameSize].width-self.size.width)/2+40, ([FSPopDialogViewController getApplicationFrameSize].height-self.size.height)/2+40, self.size.width-80, self.size.height-80);
                                  self.view.frame = frame;
                                  self.okButton.frame = CGRectMake(5, frame.size.height-55, frame.size.width/2-7.5, 50);
                                  self.cancelButton.frame = CGRectMake(frame.size.width/2+2.5, frame.size.height-55, frame.size.width/2-7.5, 50);
                                  
                                  
                                  self.backGroundView.alpha = 0.4;
                                  
                              }
                              completion:^(BOOL finished)
              {
                  
                  if (finished)
                  {
                      [UIView animateWithDuration:0.15
                                            delay:0
                                          options:UIViewAnimationOptionCurveEaseOut
                                       animations:^{
                                           CGRect frame = CGRectMake(([FSPopDialogViewController getApplicationFrameSize].width-self.size.width)/2, ([FSPopDialogViewController getApplicationFrameSize].height-self.size.height)/2, self.size.width, self.size.height);
                                           self.backGroundView.alpha = 0.6;
                                           self.view.frame = frame;
                                           self.okButton.frame = CGRectMake(5, frame.size.height-55, frame.size.width/2-7.5, 50);
                                           self.cancelButton.frame = CGRectMake(frame.size.width/2+2.5, frame.size.height-55, frame.size.width/2-7.5, 50);
                                           
                                       }
                                       completion:^(BOOL finished)
                       {
                           [UIView animateWithDuration:0.05
                                                 delay:0
                                               options:UIViewAnimationOptionCurveEaseInOut
                                            animations:^{
                                            }
                                            completion:nil
                            ];
                       }
                       ];
                  }
              }];
         }
     }];
}

- (void)popDialogViewAnimationFromBottom
{
    CGFloat mid_x = ([FSPopDialogViewController getApplicationFrameSize].width - self.size.width)/2;
    CGFloat mid_y = ([FSPopDialogViewController getApplicationFrameSize].height - self.size.height)/2;
    
    [UIView animateWithDuration:0.1
                          delay:0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         self.view.frame = CGRectMake(mid_x, mid_y-100, self.size.width, self.size.height);
                         self.backGroundView.alpha += 0.6/4;
                     }
                     completion:^(BOOL finished){
                         if (finished)
                         {
                             [UIView animateWithDuration:0.1
                                                   delay:0
                                                 options:UIViewAnimationOptionCurveEaseIn
                                              animations:^{
                                                  self.view.frame = CGRectMake(mid_x, mid_y+50, self.size.width, self.size.height);
                                                  self.backGroundView.alpha += 0.6/4;
                                              }
                                              completion:^(BOOL finished){
                                                  if (finished)
                                                  {
                                                      [UIView animateWithDuration:0.1
                                                                            delay:0
                                                                          options:UIViewAnimationOptionCurveEaseIn
                                                                       animations:^{
                                                                           self.view.frame = CGRectMake(mid_x, mid_y-10, self.size.width, self.size.height);
                                                                           self.backGroundView.alpha += 0.6/4;
                                                                       }
                                                                       completion:^(BOOL finished){
                                                                           if (finished)
                                                                           {
                                                                               [UIView animateWithDuration:0.1
                                                                                                     delay:0
                                                                                                   options:UIViewAnimationOptionCurveEaseOut
                                                                                                animations:^{
                                                                                                    self.view.frame = CGRectMake(mid_x, mid_y, self.size.width, self.size.height);
                                                                                                    self.backGroundView.alpha += 0.6/4;
                                                                                                }
                                                                                                completion:^(BOOL finished){
                                                                                                    if (finished)
                                                                                                    {
                                                                                                    }
                                                                                                }
                                                                                ];
                                                                           }
                                                                       }
                                                       ];
                                                  }
                                              }
                              ];
                         }
                     }
     ];
}

- (void)popDialogViewAnimationFromTop
{
    CGFloat mid_y = ([FSPopDialogViewController getApplicationFrameSize].height - self.size.height)/2;
    [UIView animateWithDuration:0.1
                          delay:0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         CGRect frame = self.view.frame;
                         frame.origin.y = mid_y+100;
                         self.view.frame = frame;
                         self.backGroundView.alpha+=0.6/4;
                     }
                     completion:^(BOOL finished){
       if (finished)
       {
           [UIView animateWithDuration:0.1
                                 delay:0
                               options:UIViewAnimationOptionCurveEaseIn
                            animations:^{
                                CGRect frame = self.view.frame;
                                frame.origin.y = mid_y-50;
                                self.view.frame = frame;
                                self.backGroundView.alpha+=0.6/4;
                            }
                            completion:^(BOOL finished){
                                if (finished)
                                {
                                    [UIView animateWithDuration:0.1
                                                          delay:0
                                                        options:UIViewAnimationOptionCurveEaseIn
                                                     animations:^{
                                                         CGRect frame = self.view.frame;
                                                         frame.origin.y = mid_y+25;
                                                         self.view.frame = frame;
                                                         self.backGroundView.alpha+=0.6/4;
                                                     }
                                                     completion:^(BOOL finished){
                                                         if (finished)
                                                         {
                                                             [UIView animateWithDuration:0.1
                                                                                   delay:0
                                                                                 options:UIViewAnimationOptionCurveEaseOut
                                                                              animations:^{
                                                                                  CGRect frame = self.view.frame;
                                                                                  frame.origin.y = mid_y;
                                                                                  self.view.frame = frame;
                                                                                  self.backGroundView.alpha+=0.6/4;
                                                                              }
                                                                              completion:^(BOOL finished){
                                                                                  if (finished)
                                                                                  {
                                                                                  }
                                                                              }];

                                                         }
                                                     }];

                                }
                            }];
       }
    }];
    
}

- (void)popDialogViewAnimationFromLeftOrRight
{
    CGFloat mid_x = ([FSPopDialogViewController getApplicationFrameSize].width - self.size.width)/2;
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         CGRect frame = self.view.frame;
                         frame.origin.x = mid_x;
                         self.view.frame = frame;
                         self.backGroundView.alpha = 0.6;
                     }
                     completion:nil
     ];
}

- (void)disappearAnimation
{
    [UIView animateWithDuration:0.35
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         switch (self.disappearDialogStyle)
                         {
                             case FSPopDialogStylePop:
                             {
                                 CGRect frame = CGRectMake([FSPopDialogViewController getApplicationFrameSize].width/2, [FSPopDialogViewController getApplicationFrameSize].height/2, 0, 0);
                                 self.view.frame = frame;
                                 self.okButton.frame = CGRectMake(0, 0, 0, 0);
                                 self.cancelButton.frame = CGRectMake(0, 0, 0, 0);
                                 break;
                             }
                             case FSPopDialogStyleFromBottom:
                             {
                                 CGRect frame = self.view.frame;
                                 frame.origin.y = [FSPopDialogViewController getApplicationFrameSize].height;
                                 self.view.frame = frame;

                                 break;
                             }
                             case FSPopDialogStyleFromTop:
                             {
                                 CGRect frame = self.view.frame;
                                 frame.origin.y = - self.size.height;
                                 self.view.frame = frame;
                                 break;
                             }
                             case FSPopDialogStyleFromLeft:
                             {
                                 CGRect frame = self.view.frame;
                                 frame.origin.x = - self.size.width;
                                 self.view.frame = frame;
                                 break;
                             }
                             case FSPopDialogStyleFromRight:
                             {
                                 CGRect frame = self.view.frame;
                                 frame.origin.x = [FSPopDialogViewController getApplicationFrameSize].width;
                                 self.view.frame = frame;
                                 break;
                             }
                             default:
                                 break;
                         }
                         self.backGroundView.alpha = 0;
                     }
                     completion:^(BOOL finished){
                         if (finished)
                         {
                             [self.titleLabel removeFromSuperview];
                             [self.questionLabel removeFromSuperview];
                             [self.okButton removeFromSuperview];
                             [self.cancelButton removeFromSuperview];
                             [self.backGroundView removeFromSuperview];
                             [self.view removeFromSuperview];
                             
                         }
                     }];
}

@end
