//
//  MyEvaluateCell.h
//  FyhNewProj
//
//  Created by yh f on 2017/4/15.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EvaModel;


@interface MyEvaluateCell : UITableViewCell

@property (nonatomic , strong) UIImageView *picture;

@property (nonatomic , strong) UILabel *nameLab;

@property (nonatomic , strong) UILabel *priceLab;

@property (nonatomic , strong) YLButton *evaluBtn;

@property (nonatomic , strong) UILabel *dateLab;

@property (nonatomic , strong) UILabel *evaluLab;

@property (nonatomic,strong) EvaModel *model;

@end
