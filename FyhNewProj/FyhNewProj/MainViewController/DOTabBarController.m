//
//  DOTabBarController.m
//  FyhNewProj
//
//  Created by yh f on 2017/3/4.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import "DOTabBarController.h"
#import "HomeViewController.h"
#import "ShopViewController.h"
#import "ClassifyViewController.h"
#import "ShoppingCarViewController.h"
#import "MineViewController.h"
#import "DOHNavigationController.h"
//商家
#import "SellerViewController.h"

#import "homepageViewController.h"


#import "UserPL.h"
#import "MemberLoginController.h"

@interface DOTabBarController ()<UITabBarControllerDelegate,UINavigationControllerDelegate>

@property (strong, nonatomic) HomeViewController            *HomeVc;
@property (strong, nonatomic) ShopViewController            *ShopVc;
@property (strong, nonatomic) ClassifyViewController        *ClassifyVc;
@property (strong, nonatomic) ShoppingCarViewController     *ShoppingCarVc;
@property (strong, nonatomic) MineViewController            *MineVc;

@property (nonatomic , strong) homepageViewController *newhomeVc;

@property (strong, nonatomic) MemberLoginController            *LoginVc;

@property (nonatomic , strong) SellerViewController *sellVc;


@end

@implementation DOTabBarController{

    UIView *_bgview;
}
-(void)viewWillAppear:(BOOL)animated
{
    [self.selectedViewController beginAppearanceTransition: YES animated: animated];
    
}

-(void) viewDidAppear:(BOOL)animated
{
    [self.selectedViewController endAppearanceTransition];
}

-(void) viewWillDisappear:(BOOL)animated
{
    [self.selectedViewController beginAppearanceTransition: NO animated: animated];
}

-(void) viewDidDisappear:(BOOL)animated
{
    [self.selectedViewController endAppearanceTransition];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置标签栏为不透明的 中天
    self.tabBar.translucent = NO;
    //设置标签栏的颜色
    self.tabBar.barTintColor = [UIColor whiteColor];
    
    //设置标签的颜色
    self.tabBar.tintColor = UIColorFromRGB(0x333333);
    [self setTabBarControllerChildView];
    
    //初始化
    _barIndex= 0;
    
    self.delegate = self;
}

- (void)viewWillLayoutSubviews{
    
    CGRect tabFrame =self.tabBar.frame;
    
    tabFrame.size.height= TABBAR_HEIGHT;
    
    tabFrame.origin.y= self.view.frame.size.height- TABBAR_HEIGHT;
    
    self.tabBar.frame= tabFrame;
    
}




- (void)settheType:(NSInteger)type{
    
    self.versionsType = type;
    //创建tabBarController管理的子控制器
    [self replaceView];

    //初始化
    _barIndex = 0;
    
    self.delegate = self;
    
}

- (void)replaceView{
    if (self.versionsType != 2) {
        DOHNavigationController *nav1 = [[DOHNavigationController alloc] initWithRootViewController:self.MineVc];
      //  nav1.navigationBar.barStyle = UIBarStyleDefault;
        nav1.delegate = self;
        nav1.tabBarItem.title = @"我的";
        nav1.tabBarItem.imageInsets = UIEdgeInsetsMake(-2, 0, 2, 0);
        [self setViewControllers:@[[self.viewControllers objectAtIndex:0],[self.viewControllers objectAtIndex:1],[self.viewControllers objectAtIndex:2],[self.viewControllers objectAtIndex:3],nav1] animated:NO];
        
        
    }else{
                 self.sellVc = [[SellerViewController alloc] init];
                 self.sellVc.navigationItem.title = @"我的";
                 self.sellVc = [[SellerViewController alloc] init];
                 self.sellVc.navigationItem.title = @"我的";
                 [self addOneChildVc:self.sellVc
                               title:@"我的"
                           imageName:@"iv_mine_normal"
                   selectedImageName:@"iv_mine_on"
                          badgeValue:nil];
        DOHNavigationController *nav1 = [[DOHNavigationController alloc] initWithRootViewController:self.sellVc];
       // nav1.navigationBar.barStyle = UIBarStyleDefault;
        nav1.delegate = self;
        nav1.tabBarItem.title = @"我的";
        nav1.tabBarItem.imageInsets = UIEdgeInsetsMake(-2, 0, 2, 0);
        [self setViewControllers:@[[self.viewControllers objectAtIndex:0],[self.viewControllers objectAtIndex:1],[self.viewControllers objectAtIndex:2],[self.viewControllers objectAtIndex:3],nav1] animated:NO];
    }
}

- (void)setTabBarControllerChildView{
    
    // if (self.versionsType != 2) {
         
    //加载普通用户子控制器
    //首页
    self.HomeVc = [[HomeViewController alloc] init];
    self.HomeVc.navigationItem.title = @"首页";
         self.newhomeVc = [[homepageViewController alloc]init];
         self.newhomeVc.navigationItem.title = @"首页";

    [self addOneChildVc: self.newhomeVc
                  title:@"首页"
              imageName:@"iv_home_normal"
      selectedImageName:@"iv_home_on"
             badgeValue:nil];
    
    DOHNavigationController *nav = [[DOHNavigationController alloc] initWithRootViewController:self.newhomeVc];
   // nav.navigationBar.barStyle = UIBarStyleDefault;
    nav.delegate = self;
    nav.tabBarItem.title = @"首页";
    nav.tabBarItem.imageInsets = UIEdgeInsetsMake(-2, 0, 2, 0);
    
    //采购
    self.ShopVc = [[ShopViewController alloc] init];
    self.ShopVc.navigationItem.title = @"采购";
    [self addOneChildVc:self.ShopVc
                  title:@"采购"
              imageName:@"iv_procurement_normal"
      selectedImageName:@"iv_procurement_on"
             badgeValue:nil];
    
    DOHNavigationController *nav1 = [[DOHNavigationController alloc] initWithRootViewController:self.ShopVc];
   // nav1.navigationBar.barStyle = UIBarStyleDefault;
    nav1.delegate = self;
    nav1.tabBarItem.title = @"采购";
    nav1.tabBarItem.imageInsets = UIEdgeInsetsMake(-2, 0, 2, 0);
    
         //分类
         self.ClassifyVc = [[ClassifyViewController alloc] init];
         self.ClassifyVc.navigationItem.title = @"分类";
         [self addOneChildVc:self.ClassifyVc
                       title:@"分类"
                   imageName:@"iv_classify"
           selectedImageName:@"iv_classify"
                  badgeValue:nil];

    DOHNavigationController *nav2 = [[DOHNavigationController alloc] initWithRootViewController:self.ClassifyVc];
   // nav2.navigationBar.barStyle = UIBarStyleDefault;
    nav2.delegate = self;
    nav2.tabBarItem.title = @"分类";
    nav2.tabBarItem.imageInsets = UIEdgeInsetsMake(-2, 0, 2, 0);
  
    //购物车
    self.ShoppingCarVc = [[ShoppingCarViewController alloc] init];
    self.ShoppingCarVc.navigationItem.title = @"购物车";
    [self addOneChildVc:self.ShoppingCarVc
                  title:@"购物车"
              imageName:@"iv_shopping_cart_normal"
      selectedImageName:@"iv_shopping_cart_on"
             badgeValue:nil];
    
    DOHNavigationController *nav3 = [[DOHNavigationController alloc] initWithRootViewController:self.ShoppingCarVc];
   // nav3.navigationBar.barStyle = UIBarStyleDefault;
    nav3.delegate = self;
    nav3.tabBarItem.title = @"购物车";
    nav3.tabBarItem.imageInsets = UIEdgeInsetsMake(-2, 0, 2, 0);
    //我的
    self.MineVc = [[MineViewController alloc] init];
    self.MineVc.navigationItem.title = @"我的";
    [self addOneChildVc:self.MineVc
                  title:@"我的"
              imageName:@"iv_mine_normal"
      selectedImageName:@"iv_mine_on"
             badgeValue:nil];
    DOHNavigationController *nav4 = [[DOHNavigationController alloc] initWithRootViewController:self.MineVc];
   // nav4.navigationBar.barStyle = UIBarStyleDefault;
    nav4.delegate = self;
    nav4.tabBarItem.title = @"我的";
    nav4.tabBarItem.imageInsets = UIEdgeInsetsMake(-2, 0, 2, 0);
    [self setViewControllers:@[nav,nav1,nav2,nav3,nav4] animated:NO];
    
  
    
 }

/**
 *  添加子控制器
 *
 *  @param ChildVc           传进来的子控制器
 *  @param title             传进来的子控制器标题
 *  @param imageName         传进来的子控制器图片路径
 *  @param selectedImageName 传进来的子控制器被选中后的图片路径
 */
- (void)addOneChildVc:(UIViewController *)ChildVc title:(NSString *)title imageName:(NSString *)imageName selectedImageName:(NSString *)selectedImageName badgeValue:(NSString*)badgeValue {
    
    if (badgeValue) {
        ChildVc.tabBarItem.badgeValue=badgeValue;
    }
    
    [ChildVc.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                UIColorFromRGB(BlackColorValue),NSForegroundColorAttributeName,
                                                [UIFont fontWithName:@"Helvetica" size:12.0], NSFontAttributeName, nil]
                                      forState:UIControlStateNormal];
    if (self.versionsType==2) {
         [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:UIColorFromRGB(RedColorValue),NSForegroundColorAttributeName, [UIFont fontWithName:@"Helvetica"size:12.0f],NSFontAttributeName,nil]forState:UIControlStateSelected];
    }else{
        [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:UIColorFromRGB(RedColorValue),NSForegroundColorAttributeName, [UIFont fontWithName:@"Helvetica"size:12.0f],NSFontAttributeName,nil]forState:UIControlStateSelected];
    }
   
    ChildVc.tabBarItem.image = [[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *selectedImage = [UIImage imageNamed:selectedImageName];
    if ([[UIDevice currentDevice].systemVersion doubleValue] >= 7.0) {
        selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    ChildVc.tabBarItem.selectedImage = selectedImage;
    [ChildVc.tabBarItem setTitlePositionAdjustment:UIOffsetMake(0, -5)];
    

    
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    //每次当navigation中的界面切换，设为空。本次赋值只在程序初始化时执行一次
    static UIViewController *lastController = nil;
    
    //若上个view不为空
    if (lastController != nil)
    {
        //若该实例实现了viewWillDisappear方法，则调用
        if ([lastController respondsToSelector:@selector(viewWillDisappear:)])
        {
            [lastController viewWillDisappear:animated];
        }
    }
    
    //将当前要显示的view设置为lastController，在下次view切换调用本方法时，会执行viewWillDisappear
    lastController = viewController;
    
    [viewController viewWillAppear:animated];
}
/**
 设置每个nav的RootVc
 */
- (void)getRootVcORLastVC {
    
    
    if (self.versionsType != 2) {
        switch (_barIndex) {
            case 0:
            {
                self.rootCtl = self.HomeVc;
                
            }
                break;
            case 1:
            {
                
                self.rootCtl = self.ClassifyVc;
            }
                break;
                
            case 2:
            {
                self.rootCtl = self.ShopVc;
                
            }
                break;
            case 3:
            {
                self.rootCtl = self.ShoppingCarVc;
                
            }
                break;
            case 4:
            {
                self.rootCtl = self.MineVc;
                self.MineVc.navigationController.navigationBar.hidden = YES;
                
            }
                break;
                
        }
        
    }else{
        switch (_barIndex) {
            case 0:
            {
                self.rootCtl = self.HomeVc;
                
            }
                break;
            case 1:
            {
                
                self.rootCtl = self.ClassifyVc;
            }
                break;
                
            case 2:
            {
                self.rootCtl = self.ShopVc;
                
            }
                break;
            case 3:
            {
                self.rootCtl = self.ShoppingCarVc;
                
            }
                break;
            case 4:
            {
                self.rootCtl = self.sellVc;
                self.sellVc.navigationController.navigationBar.hidden = YES;

            }
                break;
                
        }
        
    }
    
    
}
#pragma mark   =========== tabbarcontrollerdelegate
/**
 tabBar代理点击方法
 
 @param tabBar tabBar
 @param item item
 */
-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    NSArray* arr=self.tabBar.items;

    for (int i=0; i<arr.count; i++)
    {
        
        if ([item isEqual:self.tabBar.items[i]])
        {
        _barIndex = i;
            
        }
    }
            [self getRootVcORLastVC];
            if (_barIndex == 3) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"shopcartShouldRefresh" object:nil];
            }else if (_barIndex == 4){
            
                [[NSNotificationCenter defaultCenter] postNotificationName:@"MineShouldRefresh" object:nil];
            }else if (_barIndex == 1){
                [[NSNotificationCenter defaultCenter] postNotificationName:@"NeedsShouldRefresh" object:nil];

            }

        [self getRootVcORLastVC];


    
    
    NSLog(@"barIndex的值是：%ld",(long)_barIndex);
    
}

//获取当前屏幕显示的viewcontroller
- (UIViewController *)getCurrentVC
{
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    UIViewController *currentVC = [self getCurrentVCFrom:rootViewController];
    
    return currentVC;
}

- (UIViewController *)getCurrentVCFrom:(UIViewController *)rootVC
{
    UIViewController *currentVC;
    
    if ([rootVC presentedViewController]) {
        // 视图是被presented出来的
        
        rootVC = [rootVC presentedViewController];
    }
    
    if ([rootVC isKindOfClass:[UITabBarController class]]) {
        // 根视图为UITabBarController
        
        currentVC = [self getCurrentVCFrom:[(UITabBarController *)rootVC selectedViewController]];
        
    } else if ([rootVC isKindOfClass:[UINavigationController class]]){
        // 根视图为UINavigationController
        
        currentVC = [self getCurrentVCFrom:[(UINavigationController *)rootVC visibleViewController]];
        
    } else {
        // 根视图为非导航类
        
        currentVC = rootVC;
    }
    
    return currentVC;
}


@end
