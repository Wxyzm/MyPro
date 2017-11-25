//
//  UserOrderTopCell.h
//  FyhNewProj
//
//  Created by yh f on 2017/7/14.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UserOrder;
@class OrderOtherModel;

@protocol UserOrderTopCellDelegate <NSObject>

- (void)didselectedShopbtnWithId:(NSString *)shopId;

@end


@interface UserOrderTopCell : UITableViewCell


@property (nonatomic , strong) UIImageView *facImageView;

@property (nonatomic , assign) id<UserOrderTopCellDelegate> delegate;

@property (nonatomic , strong)YLButton *btn;

@property (nonatomic , strong)UILabel *RightLab;

@property (nonatomic , strong) UserOrder *model;

@property (nonatomic , strong) OrderOtherModel *oterModel;

@property (nonatomic , strong)     UILabel *nameLab;


@end
