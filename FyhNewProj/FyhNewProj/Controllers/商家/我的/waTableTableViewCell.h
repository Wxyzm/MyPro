//
//  waTableTableViewCell.h
//  FyhNewProj
//
//  Created by yh f on 2017/11/2.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MasterProModel;
@class waTableTableViewCell;


@protocol waTableTableViewCelldelegate <NSObject>

- (void)didselectedSelectedBtnWithCell:(waTableTableViewCell *)cell;

- (void)didselectedEditBtnWithCell:(waTableTableViewCell *)cell;

- (void)didselectedDownBtnWithCell:(waTableTableViewCell *)cell;

- (void)didselectedDeleteBtnWithCell:(waTableTableViewCell *)cell;

- (void)didselectedPrintBtnClickWithCell:(waTableTableViewCell *)cell;




@end


@interface waTableTableViewCell : UITableViewCell

@property (nonatomic , assign) id<waTableTableViewCelldelegate>delegate;

@property (nonatomic , assign) NSInteger type;

@property (nonatomic , strong) YLButton *selectedBtn;

@property (nonatomic , strong) UIImageView *faceImageView;


@property (nonatomic , strong) UIImageView *backImageView;

@property (nonatomic , strong) UILabel *nameLab;

@property (nonatomic , strong) UILabel *unitLab;



@property (nonatomic , strong) YLButton *editBtn;

@property (nonatomic , strong) YLButton *downBtn;

@property (nonatomic , strong) YLButton *deleteBtn;

@property (nonatomic , strong) YLButton *PrintBtn;

@property (nonatomic , strong) MasterProModel *model;


@end


