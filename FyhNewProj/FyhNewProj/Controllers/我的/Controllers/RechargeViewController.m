//
//  RechargeViewController.m
//  FyhNewProj
//
//  Created by yh f on 2017/9/12.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import "RechargeViewController.h"

@interface RechargeViewController ()

@end

@implementation RechargeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBarBackBtnWithImage:nil];
    //顶部导航栏
    UILabel *titlelab;
    titlelab = [BaseViewFactory labelWithFrame:CGRectMake(0, 0, 200, 44) textColor:UIColorFromRGB(BlackColorValue) font:APPFONT(17) textAligment:NSTextAlignmentCenter andtext:@"充值"];
    self.navigationItem.titleView = titlelab;
    
    
    

}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    UIView *myView = [[self.navigationController valueForKey:@"_navigationBar"] valueForKey:@"_backgroundView"];
    myView.backgroundColor = [UIColor whiteColor];
    myView.layer.sublayers[0].hidden = YES;
    for (CALayer *layers in myView.layer.sublayers) {
        layers.hidden = YES;
    }
    NSLog(@"%@",myView.layer.sublayers);
    self.navigationController.navigationBar.backgroundColor = UIColorFromRGB(WhiteColorValue);
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    UIView *myView = [[self.navigationController valueForKey:@"_navigationBar"] valueForKey:@"_backgroundView"];
    for (CALayer *layers in myView.layer.sublayers) {
        layers.hidden = NO;
    }
}


@end
