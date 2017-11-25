//
//  MoreSelectedView.h
//  FyhNewProj
//
//  Created by yh f on 2017/7/15.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MoreSelectedView : UIView


@property (nonatomic , strong) UIButton *sentBtn;

@property (nonatomic , strong) UIButton *comBtn;

@property (nonatomic , strong) UIButton *closeBtn;


- (void)showinView:(UIView *)view;
- (void)dismiss;


@end
