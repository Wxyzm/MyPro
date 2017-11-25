//
//  AdressCell.h
//  FyhNewProj
//
//  Created by yh f on 2017/4/12.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AdressModel;
@class AdressCell;

@protocol AdressCellDelegate <NSObject>

//代理
- (void)AdressCellLeftBtnClick:(AdressCell *)cell;
- (void)AdressCellMorenBtnClick:(AdressCell *)cell;
- (void)AdressCellEditBtnClick:(AdressCell *)cell;
- (void)AdressCellDeleteBtnClick:(AdressCell *)cell;


@end

@interface AdressCell : UITableViewCell

@property (nonatomic , assign) id<AdressCellDelegate>delegate;

@property (nonatomic , strong)  UILabel *nameLab;

@property (nonatomic , strong)  UILabel *adressLab;

@property (nonatomic , strong)  UILabel *phoneLab;

@property (nonatomic , strong)  YLButton *editBtn;

@property (nonatomic , strong)  YLButton *deleteBtn;

@property (nonatomic , strong)  YLButton *leftBtn;

@property (nonatomic , strong)  SubBtn *morenBtn;

@property (nonatomic , strong) AdressModel *model;

@end
