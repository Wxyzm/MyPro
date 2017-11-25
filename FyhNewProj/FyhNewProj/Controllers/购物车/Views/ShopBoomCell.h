//
//  ShopBoomCell.h
//  FyhNewProj
//
//  Created by yh f on 2017/4/18.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ShopCartDataModel;

@interface ShopBoomCell : UITableViewCell

@property (nonatomic , strong) UILabel *moneyLab;

@property (nonatomic , strong) UITextField *beizhuTxt;

@property (nonatomic , strong) ShopCartDataModel *model;

@end
