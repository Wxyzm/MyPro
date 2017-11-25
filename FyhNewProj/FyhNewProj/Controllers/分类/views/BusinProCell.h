//
//  BusinProCell.h
//  FyhNewProj
//
//  Created by yh f on 2017/7/4.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ItemsModel;

@interface BusinProCell : UICollectionViewCell

@property (nonatomic,strong) UIImageView *productFace;

@property (nonatomic,strong) UILabel *productNameL;

@property (nonatomic,strong) UILabel *priceL;

@property (nonatomic,strong) UILabel *buyNumberL;

@property (nonatomic , strong) UIImageView *imageview;

@property (nonatomic , strong) ItemsModel *model;

@property (nonatomic , strong) UIImageView *backImageView;

@end
