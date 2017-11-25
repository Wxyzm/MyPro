//
//  MyPriceCell.h
//  FyhNewProj
//
//  Created by yh f on 2017/7/26.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MyPriceModel;

@interface MyPriceCell : UITableViewCell

@property (nonatomic , strong) UIImageView *faceImage;

@property (nonatomic , strong) UILabel *nameLab;

@property (nonatomic , strong) UILabel *stateLab;

@property (nonatomic , strong) UILabel *kindLab;

@property (nonatomic , strong) UILabel *priceLab;

@property (nonatomic , strong) UILabel *timeLab;

@property (nonatomic , strong) MyPriceModel *model;

@end
