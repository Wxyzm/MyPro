//
//  PayWayView.h
//  FyhNewProj
//
//  Created by yh f on 2017/7/3.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PayWayViewDelegate <NSObject>

- (void)didSelectedSetUpBtn;

- (void)didSelectedCloseBtn;


@end


@interface PayWayView : UIView


@property (nonatomic , assign) BOOL isAilPayWay;

@property (nonatomic , assign) id<PayWayViewDelegate>delegate;


- (void)showinView:(UIView *)view;
- (void)dismiss;

@end
