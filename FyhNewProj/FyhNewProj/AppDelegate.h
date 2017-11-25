//
//  AppDelegate.h
//  FyhNewProj
//
//  Created by yh f on 2017/3/2.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConnectViewController.h"
#import "LYConnectViewController.h"

@class DOTabBarController;
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) DOTabBarController *mainController;
@property (strong, nonatomic) ConnectViewController *mConnBLE;
@property (strong, nonatomic) LYConnectViewController *LYConnBLE;

@end

