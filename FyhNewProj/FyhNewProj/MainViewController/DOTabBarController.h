//
//  DOTabBarController.h
//  FyhNewProj
//
//  Created by yh f on 2017/3/4.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DOTabBarController : UITabBarController
@property (strong, nonatomic) UIViewController *rootCtl;
@property (strong, nonatomic) UIViewController *lastVC;
@property (assign, nonatomic) NSInteger versionsType;

@property (assign, nonatomic) NSInteger barIndex;

- (void)settheType:(NSInteger)type;



@end
