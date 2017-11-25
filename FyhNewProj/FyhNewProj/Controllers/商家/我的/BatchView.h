//
//  BatchView.h
//  FyhNewProj
//
//  Created by yh f on 2017/8/25.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import <UIKit/UIKit.h>




@interface BatchView : UIView

@property (nonatomic , strong) UIButton   *sureBtn;

@property (nonatomic , strong) UITextField *stocktxt;       //库存

@property (nonatomic , strong) UITextField *mintxt;      //起订量

@property (nonatomic , strong) UITextField *maxtxt;      //限购

@property (nonatomic , strong) UITextField *pricetxt;       //库存

@property (nonatomic , assign) NSInteger type;              //0.创意设计（无起订量、限购）1.大货、批发（起订量）2.零售、样布样卡（限购） 3（起订量、限购都有）
- (void)showinView:(UIView *)view;

- (void)dismiss;

@end
