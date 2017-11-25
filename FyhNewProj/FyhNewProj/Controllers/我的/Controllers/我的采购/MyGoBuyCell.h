//
//  MyGoBuyCell.h
//  FyhNewProj
//
//  Created by yh f on 2017/4/14.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MyNeedsModel;
@class MyGoBuyCell;
@protocol MyGoBuyCellDelegate <NSObject>


//代理
- (void)didSelectedDeleteBtnWithcell:(MyGoBuyCell *)cell;

- (void)didSelectedEditBtnWithcell:(MyGoBuyCell *)cell;

- (void)didSelectedBgBtnWithcell:(MyGoBuyCell *)cell;

- (void)didSelectedacceptWithcell:(MyGoBuyCell *)cell;

@end




@interface MyGoBuyCell : UITableViewCell

@property (nonatomic,assign) id<MyGoBuyCellDelegate>delegate;

@property (nonatomic , strong) UIImageView *picture;

@property (nonatomic , strong) UIImageView *backImageView;

@property (nonatomic , strong) UILabel *nameLab;

@property (nonatomic , strong) UILabel *priceLab;

@property (nonatomic , strong) UILabel *statuesLab;

@property (nonatomic , strong) UILabel *kindLab;

@property (nonatomic , strong) UILabel *dateLab;

@property (nonatomic , strong) UIScrollView *bgscrollView;

@property (nonatomic , strong) MyNeedsModel *model;

@property (nonatomic , strong) SubBtn *acceptBtn;

@property (nonatomic , strong) NSDictionary *priceDic;

@end
