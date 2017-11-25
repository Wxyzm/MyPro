//
//  ShopBuyCell.h
//  FyhNewProj
//
//  Created by yh f on 2017/6/30.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ShopCartModel;


@interface ShopBuyCell : UITableViewCell


@property (nonatomic , strong) UIImageView *picture;

@property (nonatomic , strong) UILabel *nameLab;

@property (nonatomic , strong) UILabel *colorLab;

@property (nonatomic , strong) UILabel *priceLab;

@property (nonatomic , strong) UILabel *oldPriceLab;

@property (nonatomic , strong) ShopCartModel *model;


@property (nonatomic , strong) UITextField *numTxt;

@end
