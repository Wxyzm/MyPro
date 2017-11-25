//
//  SellerTopCell.h
//  FyhNewProj
//
//  Created by yh f on 2017/7/17.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SellerOrderModel;

@interface SellerTopCell : UITableViewCell

@property (nonatomic , strong) UILabel *nameLab;

@property (nonatomic , strong) UILabel *numberLab;

@property (nonatomic , strong) UILabel *stateLab;

@property (nonatomic , strong) SellerOrderModel *model;

@end
