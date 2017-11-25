//
//  ConnectBuyerCell.h
//  FyhNewProj
//
//  Created by yh f on 2017/7/18.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ConnectBuyerCellDelegate <NSObject>

- (void)didselectedconnectbtnWithId:(NSString *)sellerId andsellinfo:(NSString *)sellinfo;

@end

@class SellerOrderModel;

@interface ConnectBuyerCell : UITableViewCell

@property (nonatomic , assign) id<ConnectBuyerCellDelegate> delegate;

@property (nonatomic , strong) UIImageView *faceView;

@property (nonatomic , strong) UILabel *connectLab;

@property (nonatomic , strong) UILabel *freightLab;

@property (nonatomic , strong) UILabel *payLab;

@property (nonatomic , strong) SellerOrderModel *model;

@property (nonatomic , copy) NSString *accountId;

@property (nonatomic , copy) NSString *sellerinfo;


- (void)setTheLogPay:(CGFloat )logPay andAmountPay:(CGFloat )amountPay;

@end
