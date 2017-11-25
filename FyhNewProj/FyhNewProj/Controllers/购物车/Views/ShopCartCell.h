//
//  ShopCartCell.h
//  FyhNewProj
//
//  Created by yh f on 2017/4/15.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ShopCartModel;

@class ShopCartCell;

@protocol ShopCartCellDelegate <NSObject>

- (void)shopBtnTabVClick:(ShopCartCell *)cell;


- (void)shopDeleteBtnClickWithCell:(ShopCartCell *)cell;



@end





@interface ShopCartCell : UITableViewCell


@property (nonatomic , strong) YLButton *leftBtn;

@property (nonatomic , strong) UIImageView *picture;

@property (nonatomic , strong) UIImageView *backImageView;

@property (nonatomic , strong) UILabel *nameLab;

@property (nonatomic , strong) UILabel *colorLab;

@property (nonatomic , strong) UILabel *priceLab;

@property (nonatomic , strong) UILabel *oldPriceLab;

@property (nonatomic , strong) ShopCartModel *model;

@property (nonatomic,assign)id<ShopCartCellDelegate>delegate;

@property (nonatomic , strong) UITextField *numTxt;

@property (nonatomic , strong) SubBtn *deleteBtn;

@end
