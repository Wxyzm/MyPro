//
//  SearchProductCollectionCell.h
//  FyhNewProj
//
//  Created by yh f on 2017/3/12.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ItemsModel;
//搜索商品展示cell
@interface SearchProductCollectionCell : UICollectionViewCell

@property (nonatomic,strong) UILabel *productNameL;

@property (nonatomic,strong) UILabel *priceL;

@property (nonatomic,strong) UILabel *buyNumberL;

@property (nonatomic,strong) UILabel *comL;

@property (nonatomic , strong) UIImageView *imageview;

@property (nonatomic , strong) UIImageView *backImageView;

@property (nonatomic,strong) UIImageView *productFace;

@property (nonatomic , strong) ItemsModel *model;

- (void)setDataDic:(NSDictionary *)dataDic;



@end
