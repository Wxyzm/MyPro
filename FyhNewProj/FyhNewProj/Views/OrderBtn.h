//
//  OrderBtn.h
//  FyhNewProj
//
//  Created by yh f on 2017/4/10.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderBtn : UIButton

@property (nonatomic , strong) UIButton * badge;


- (void)setThebadgeNumber:(NSString *)numStr;

@end
