//
//  MenueView.h
//  FyhNewProj
//
//  Created by yh f on 2017/8/21.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MenueViewDelegate <NSObject>

- (void)didselectedBtnWithButton:(UIButton *)btn;

@end

@interface MenueView : UIView

@property (nonatomic , strong) UIViewController *baseVc;

@property (nonatomic , assign) CGFloat OriginY;

@property (nonatomic , assign) id<MenueViewDelegate>delegate;


- (void)show;

- (void)dismiss;

@end
