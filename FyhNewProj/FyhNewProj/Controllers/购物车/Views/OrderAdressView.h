//
//  OrderAdressView.h
//  FyhNewProj
//
//  Created by yh f on 2017/4/17.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AdressModel;
@interface OrderAdressView : UIView

@property (nonatomic , strong) UILabel *nameLab;

@property (nonatomic , strong) UILabel *phoneLab;

@property (nonatomic , strong) UILabel *adressLab;

@property (nonatomic , strong) AdressModel *model;

- (void)showAddAdressView;

- (void)showAdress;




@end
