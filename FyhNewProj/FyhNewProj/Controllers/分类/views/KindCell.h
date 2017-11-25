//
//  KindCell.h
//  FyhNewProj
//
//  Created by yh f on 2017/4/15.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GoodsLVOneModel;
@interface KindCell : UITableViewCell

@property (nonatomic , strong) UIImageView *picture;

@property (nonatomic , strong) UILabel *nameLab;

@property (nonatomic , strong) GoodsLVOneModel *model;

@end
