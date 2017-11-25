//
//  NewGoBuyCell.h
//  FyhNewProj
//
//  Created by yh f on 2017/10/20.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MyNeedsModel;
@class NewGoBuyCell;
@protocol NewGoBuyCellDelegate <NSObject>

@optional
//代理
- (void)didSelectedCollectBtnWithcell:(NewGoBuyCell *)cell;

@end




@interface NewGoBuyCell : UITableViewCell

@property (nonatomic , strong) UIView *backView;

@property (nonatomic , strong) UIImageView *typeeImageView;

@property (nonatomic , strong) UILabel *typeLab;

@property (nonatomic , strong) UIImageView *pictureImageView;

@property (nonatomic , strong) UILabel *nameLab;

@property (nonatomic , strong) UILabel *statuesLab;

@property (nonatomic , strong) UILabel *kindLab;

@property (nonatomic , strong) UILabel *dateLab;

@property (nonatomic , strong) UILabel *numberLab;

@property (nonatomic , strong) MyNeedsModel *model;

@property (nonatomic , strong) YLButton *collectBtn;

@property (nonatomic , assign)id<NewGoBuyCellDelegate>delegate;

@end
