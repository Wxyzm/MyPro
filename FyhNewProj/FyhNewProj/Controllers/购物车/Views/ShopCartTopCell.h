//
//  ShopCartTopCell.h
//  FyhNewProj
//
//  Created by yh f on 2017/4/17.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ShopCartTopCell;
@class ShopCartDataModel;

@protocol ShopCartTopCellDelegate <NSObject>

-(void)shopTopLeftBtnClick:(ShopCartTopCell *)cell;

-(void)shopTopshopBtnClick:(ShopCartTopCell *)cell;

-(void)shopTopReceiveBtnClick:(ShopCartTopCell *)cell;

-(void)shopTopEditBtnClick:(ShopCartTopCell *)cell;


-(void)shopGoTopShopBtnClick:(ShopCartTopCell *)cell;


@end
@interface ShopCartTopCell : UITableViewCell


@property (nonatomic , strong) YLButton *selectBtn;

@property (nonatomic , strong) YLButton *shopBtn;

@property (nonatomic , strong) YLButton *receiveBtn;

@property (nonatomic , strong) YLButton *editBtn;

@property (nonatomic,assign)id<ShopCartTopCellDelegate>delegate;

@property (nonatomic , strong) ShopCartDataModel *model;


- (void)sdlayoutBuyTopView;


@end
