//
//  UserOrderBoomCell.h
//  FyhNewProj
//
//  Created by yh f on 2017/7/14.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UserOrder;
@class OrderOtherModel;

@protocol UserOrderBoomCellDelegate <NSObject>

- (void)didselectedBoomCellPayBtnWithType:(NSInteger)type andModel:(UserOrder *)model;

- (void)didselectedBoomCellCancleBtnWithType:(NSInteger)type andModel:(UserOrder *)model;

- (void)waitAcceptdidselectedUserOrderOneCellPayBtnWithModel:(OrderOtherModel *)model;

- (void)waitAcceptdidselectedUserOrderOneCellCancleBtnWithModel:(OrderOtherModel *)model;

@end


@interface UserOrderBoomCell : UITableViewCell


@property (nonatomic,assign) id<UserOrderBoomCellDelegate>delegate;

@property (nonatomic , strong) UserOrder *model;

@property (nonatomic , strong) OrderOtherModel *otherModel;


@property (nonatomic , strong) SubBtn *cancleBtn;

@property (nonatomic , strong) SubBtn *payBtn;

@property (nonatomic , strong) UILabel *traLab;

@property (nonatomic , strong) UILabel *priceLab;

@property (nonatomic , strong) UILabel *numbrLab;
@end
