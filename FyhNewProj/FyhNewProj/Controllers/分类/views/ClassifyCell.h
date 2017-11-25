//
//  ClassifyCell.h
//  FyhNewProj
//
//  Created by yh f on 2017/4/13.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GoodsLvTwoModel;
@class ClassifyCell;

@protocol ClassifyCellDelegate <NSObject>


- (void)didselectedItemWithBtn:(YLButton *)button andcell:(ClassifyCell *)cell;

- (void)didselectedMoreBtnwithcell:(ClassifyCell *)cell;

@end



@interface ClassifyCell : UITableViewCell

@property (nonatomic,assign)id<ClassifyCellDelegate>delegate;

@property (nonatomic , strong) UILabel *namelab;

@property (nonatomic , strong) YLButton *moreBtn;

@property (nonatomic , strong) GoodsLvTwoModel *goodModel;

@end
