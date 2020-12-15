设置寄宿图,然后再设置`contentsRect`

```objc
    UIImage *logo = [UIImage imageNamed:@"shot"];
    UIView *demoView = [[UIView alloc] initWithFrame:CGRectMake(100, 100, 122 , 200)];
    demoView.layer.contents = (__bridge id)logo.CGImage;
    demoView.layer.contentsRect = CGRectMake(0, 0.25, 1, 0.5);
    // CGRectMake(0, 0, 0.25, 0.25) // 显示左上角四分之一
//    CGRectMake(0.25, 0.25, 0.5 , 0.5)//显示中间
    //CGRectMake(0, 0, 1 , 0.5) //上半部分
    //CGRectMake(0, 0.5, 1 , 0.5) //下半部分
        ///配合`contentMode`可以灵活设置
    demoView.contentMode = UIViewContentModeScaleAspectFill;
    demoView.clipsToBounds = YES;
    demoView.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:demoView];

```