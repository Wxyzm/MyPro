//
//  UserOrderOneCell.h
//  FyhNewProj
//
//  Created by yh f on 2017/7/14.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import <UIKit/UIKit.h>
@class OrderItems;

@class OrderOtherItemModel;

@protocol UserOrderOneCellDelegate <NSObject>

- (void)didselectedUserOrderOneCellPayBtnWithType:(NSInteger)type andModel:(OrderItems *)model;

- (void)didselectedUserOrderOneCellCancleBtnWithType:(NSInteger)type andModel:(OrderItems *)model;

- (void)didselectedUserOrderOneCellOnBtnWithItemId:(NSString *)itemid;



@end
@interface UserOrderOneCell : UITableViewCell

@property (nonatomic,assign) id<UserOrderOneCellDelegate>delegate;

@property (nonatomic , strong) UIImageView *picture;

@property (nonatomic , strong) UIImageView *backImageView;


@property (nonatomic , strong) UILabel *nameLab;

@property (nonatomic , strong) UILabel *unitLab;

@property (nonatomic , strong) UILabel *priceLab;

@property (nonatomic , strong) UILabel *numberLab;

@property (nonatomic , strong) SubBtn *cancleBtn;

@property (nonatomic , strong) SubBtn *payBtn;

@property (nonatomic , strong) UIButton *onBtn;

- (void)showboomView;

- (void)hiddenboomView;

@property (nonatomic , strong) OrderItems *ItemsModel;


@property (nonatomic , strong) OrderOtherItemModel *otherModel;

@end
