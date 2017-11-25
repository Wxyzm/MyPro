//
//  DOHNavigationController.m
//  DomesticOutfitHelper
//
//  Created by 象萌cc003a on 15/11/25.
//  Copyright (c) 2015年 象萌cc003a. All rights reserved.
//

#import "DOHNavigationController.h"
#import "SubBtn.h"
@interface DOHNavigationController ()

@end

@implementation DOHNavigationController

+(void)initialize
{
    UINavigationBar *bar = [UINavigationBar appearance];
    [bar setShadowImage:[[UIImage alloc] init]];

    [bar setTintColor:UIColorFromRGB(RedColorValue)];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
     _myView = [[self valueForKey:@"_navigationBar"] valueForKey:@"_backgroundView"];
    _myView.frame =CGRectMake(0, -STATUSBAR_HEIGHT, ScreenWidth, NaviHeight64);
    //  创建 CAGradientLayer 对象
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    //  设置 gradientLayer 的 Frame
    gradientLayer.frame = _myView.bounds;
    //  gradientLayer.cornerRadius = 10;
    //  创建渐变色数组，需要转换为CGColor颜色
    gradientLayer.colors = @[(id)UIColorFromRGB(0xff2d66).CGColor,
                             (id)UIColorFromRGB(0xff4452).CGColor,
                             (id)UIColorFromRGB(0xff5d3b).CGColor];
    //  设置三种颜色变化点，取值范围 0.0~1.0
    gradientLayer.locations = @[@(0.1f) ,@(0.5f),@(1.0f)];
    
    //  设置渐变颜色方向，左上点为(0,0), 右下点为(1,1)
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1, 0);
    
    //  添加渐变色到创建的 UIView 上去
    [_myView.layer addSublayer:gradientLayer];
    
    /*
     The following two lines make it possible to remove the shadow at the bottom of navigation bar~ Awesome!
     */
    [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
    [[UINavigationBar appearance] setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];

    
    [self.navigationBar setTitleTextAttributes:
     
     @{NSFontAttributeName:[UIFont systemFontOfSize:17]
       ,NSForegroundColorAttributeName:UIColorFromRGB(0xffffff)
       }];
    self.navigationBar.translucent = NO;
    
    
    
}
-(void)viewWillAppear:(BOOL)animated
{

//     The following two lines make it possible to remove the shadow at the bottom of navigation bar~ Awesome!
//     */
      [[UINavigationBar appearance] setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
    // Modify the color of UITextField's cursor when inputing text.
    [[UITextField appearance] setTintColor:UIColorFromRGB(0x333333)];
    
    [self.navigationBar setTitleTextAttributes:
     
     @{NSFontAttributeName:[UIFont systemFontOfSize:17]
       ,NSForegroundColorAttributeName:UIColorFromRGB(0xffffff)
       }];
    self.navigationBar.translucent = NO;
}

- (id)initWithRootViewController:(UIViewController *)rootViewController {
    
    self = [super initWithRootViewController:rootViewController];
    
    if (self) {
        
        [self.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor],NSForegroundColorAttributeName,nil]];


        //修改UIBarButtonItem title字体大小
        NSDictionary *textAttributes = [NSDictionary dictionaryWithObjectsAndKeys:FSYSTEMFONT(18), NSFontAttributeName, nil];
        
        [[UIBarButtonItem appearance] setTitleTextAttributes:textAttributes forState:0];
        
    }
    return self;
}

- (void)backPopViewController {
    
    [super popViewControllerAnimated:YES];
}


/**
 *  重写push方法,当推送到其他控制器的时候隐藏tabbar
 */
-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
        
        //设置给定图片做按钮
        UIImage * bacImage = [[UIImage imageNamed:@"nav_back.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];

        
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithImage:bacImage style:UIBarButtonItemStylePlain target:self action:@selector(backPopViewController)];
        viewController.navigationItem.leftBarButtonItem = backItem;
        
        if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            
            self.interactivePopGestureRecognizer.delegate = nil;
        }
    }
    
    [super pushViewController:viewController animated:animated];
}





@end
