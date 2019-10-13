# WGBEasyMarqueeView

<p align='center'>
<img src="https://img.shields.io/badge/build-passing-brightgreen.svg">
<a href="https://cocoapods.org/pods/WGBEasyMarqueeView"> <img src="https://img.shields.io/cocoapods/v/WGBEasyMarqueeView.svg?style=flat"> </a>
<img src="https://img.shields.io/badge/platform-iOS-ff69b4.svg">
<img src="https://img.shields.io/badge/language-Objective--C-orange.svg">
<a href=""><img src="https://img.shields.io/badge/license-MIT-000000.svg"></a>
<a href="http://wangguibin.github.io"><img src="https://img.shields.io/badge/Blog-CoderWGB-80d4f9.svg?style=flat"></a>
<img src="https://img.shields.io/badge/Enjoy-it%20!-brightgreen.svg?colorA=a0cd34">
</p>


## Example
```objc
    WGBEasyMarqueeView *marqueeView = [[WGBEasyMarqueeView alloc] init];
    marqueeView.backgroundColor = [UIColor lightGrayColor];
    marqueeView.contentMargin = 50;
    marqueeView.speed = 1.5f;
    [self.view addSubview: marqueeView];
    if (self.marqueeType != 3) {
        marqueeView.marqueeType = self.marqueeType;
        marqueeView.contentView = self.label;
    }else{
        marqueeView.marqueeType = WGBEasyMarqueeTypeReverse;
        marqueeView.contentView = self.customView;
    }
    self.marqueeView = marqueeView;
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    self.marqueeView.bounds = CGRectMake(0, 0, 300 , 60);
    self.marqueeView.center = self.view.center;
}

```

 **更具体使用例子可参考demo**

 #### [swift版本 请前往](https://github.com/pujiaxin33/JXMarqueeView)
To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

WGBEasyMarqueeView is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'WGBEasyMarqueeView'
```

## Author

Wangguibin, 864562082@qq.com

## License

WGBEasyMarqueeView is available under the MIT license. See the LICENSE file for more info.
