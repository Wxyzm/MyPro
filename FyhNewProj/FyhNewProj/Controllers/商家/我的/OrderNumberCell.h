//
//  OrderNumberCell.h
//  FyhNewProj
//
//  Created by yh f on 2017/7/19.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SellerOrderModel;
@interface OrderNumberCell : UITableViewCell

@property (nonatomic , strong) UILabel *numLab;

@property (nonatomic , strong) UILabel *setTimeLab;

@property (nonatomic , strong) UILabel *payTimeLab;

@property (nonatomic , strong) UILabel *sentTimeLab;

@property (nonatomic , strong) SellerOrderModel *model;

- (void)setOrderNumber:(NSString *)orderNumber andcreateTime:(NSString *)createTime;


@end
