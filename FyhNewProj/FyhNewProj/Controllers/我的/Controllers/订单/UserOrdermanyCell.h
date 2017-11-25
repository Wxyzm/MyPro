//
//  UserOrdermanyCell.h
//  FyhNewProj
//
//  Created by yh f on 2017/7/14.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import <UIKit/UIKit.h>
@class OrderSellerItems;
@class UserOrder;
@protocol UserOrdermanyCelllDelegate <NSObject>

- (void)didselectedUserOrdermanyCellPayBtnWithType:(NSInteger)type andArr:(NSMutableArray *)arr;

- (void)didselectedUserOrdermanyCellCancleBtnWithType:(NSInteger)type andArr:(NSMutableArray *)arr;

- (void)didselectedCollecTionViewWithArr:(NSMutableArray *)dataArr andModel:(UserOrder *)model;

@end
@interface UserOrdermanyCell : UITableViewCell

@property (nonatomic,assign) id<UserOrdermanyCelllDelegate>delegate;


@property (nonatomic , strong) NSMutableArray *dataArr;

@property (nonatomic , strong) UserOrder *model;

@property (nonatomic , strong) SubBtn *cancleBtn;

@property (nonatomic , strong) SubBtn *payBtn;


- (void)showboomView;

- (void)hiddenboomView;

@end
