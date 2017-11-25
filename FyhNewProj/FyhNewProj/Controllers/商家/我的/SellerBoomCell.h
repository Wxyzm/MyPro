//
//  SellerBoomCell.h
//  FyhNewProj
//
//  Created by yh f on 2017/7/17.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SellerOrderModel;
@class SellerBoomCell;

@protocol SellerBoomCellDelegate <NSObject>

- (void)didSelectedCancleBtnWithCell:(SellerBoomCell *)cell;

- (void)didSelectedPayBtnWithCell:(SellerBoomCell *)cell;

@end

@interface SellerBoomCell : UITableViewCell

@property (nonatomic , assign) id<SellerBoomCellDelegate> delegate;

@property (nonatomic , strong) SellerOrderModel *model;

@property (nonatomic , strong) SubBtn *cancleBtn;

@property (nonatomic , strong) SubBtn *payBtn;

@property (nonatomic , strong) UILabel *traLab;

@property (nonatomic , strong) UILabel *priceLab;

@property (nonatomic , strong) UILabel *numbrLab;

@property (nonatomic , assign) NSInteger Type;


@end
