//
//  DIYGoodsMessageCell.h
//  FyhNewProj
//
//  Created by yh f on 2017/9/7.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import <RongIMKit/RongIMKit.h>

@interface DIYGoodsMessageCell : RCMessageCell

@property(nonatomic, strong) UIImageView *bubbleBackgroundView;

@property(nonatomic, strong) UILabel *nameLab;

@property(nonatomic, strong) UILabel *desLab;

@property(nonatomic, strong) UILabel *priceLab;


@property(nonatomic, strong) UIImageView *rightImageView;


- (void)setDataModel:(RCMessageModel *)model;

- (void)initialize;

@end
