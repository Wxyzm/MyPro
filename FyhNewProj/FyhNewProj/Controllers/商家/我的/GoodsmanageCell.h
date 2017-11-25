//
//  GoodsmanageCell.h
//  FyhNewProj
//
//  Created by yh f on 2017/7/10.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GItemModel;
@class GoodsmanageCell;

@protocol GoodsmanageCellDelegate <NSObject>

- (void)didselectedEditBtnWithCell:(GoodsmanageCell *)cell;

- (void)didselectedDownBtnWithCell:(GoodsmanageCell *)cell;

- (void)didselectedDeleteBtnWithCell:(GoodsmanageCell *)cell;


@end


@interface GoodsmanageCell : UITableViewCell

@property (nonatomic , assign) id<GoodsmanageCellDelegate>delegate;

@property (nonatomic , assign) NSInteger type;

@property (nonatomic , strong) UIImageView *faceImageView;


@property (nonatomic , strong) UIImageView *backImageView;

@property (nonatomic , strong) UILabel *nameLab;

@property (nonatomic , strong) UILabel *unitLab;

@property (nonatomic , strong) UILabel *priceLab;

@property (nonatomic , strong) UILabel *stockLab;

@property (nonatomic , strong) YLButton *editBtn;

@property (nonatomic , strong) YLButton *downBtn;

@property (nonatomic , strong) YLButton *deleteBtn;

@property (nonatomic , strong) GItemModel *model;


@end
