//
//  MyCollectionCell.h
//  FyhNewProj
//
//  Created by yh f on 2017/4/14.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MyCollectionCellDelegate <NSObject>

- (void)didselectedDelegateBtnWithDic:(NSDictionary *)dic andType:(NSInteger )type;

- (void)didselectedGoingBtnWithShopId:(NSString *)ShopId;


@end

@interface MyCollectionCell : UITableViewCell

@property (nonatomic , assign) id<MyCollectionCellDelegate> delegate;

@property (nonatomic , strong) UIImageView *picture;

@property (nonatomic , strong) UILabel *nameLab;

@property (nonatomic , strong) UILabel *priceLab;

@property (nonatomic , strong) NSDictionary *dataDic;

@property (nonatomic , strong) NSDictionary *shopDic;

@property (nonatomic , strong) NSDictionary *needDic;


@property (nonatomic , strong) UIImageView *backImageView;

@end
