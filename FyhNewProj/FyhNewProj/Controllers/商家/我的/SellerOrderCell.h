//
//  SellerOrderCell.h
//  FyhNewProj
//
//  Created by yh f on 2017/7/17.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import <UIKit/UIKit.h>
@class itemOrdersDataModel;

@interface SellerOrderCell : UITableViewCell


@property (nonatomic , strong) UIImageView *picture;

@property (nonatomic , strong) UIImageView *backImageView;

@property (nonatomic , strong) UILabel *nameLab;

@property (nonatomic , strong) UILabel *colorLab;

@property (nonatomic , strong) UILabel *priceLab;

@property (nonatomic , strong) UILabel *numberLab;

@property (nonatomic , strong) itemOrdersDataModel *model;


@end
