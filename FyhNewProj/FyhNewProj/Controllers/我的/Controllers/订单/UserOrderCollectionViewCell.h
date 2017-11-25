//
//  UserOrderCollectionViewCell.h
//  FyhNewProj
//
//  Created by yh f on 2017/7/14.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import <UIKit/UIKit.h>
@class OrderItems;

@interface UserOrderCollectionViewCell : UICollectionViewCell

@property (nonatomic,strong) UIImageView *productFace;

@property (nonatomic , strong) OrderItems *model;

@property (nonatomic , strong) UIImageView *backImageView;


@end
