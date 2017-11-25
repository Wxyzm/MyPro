//
//  SideView.h
//  demo_sidemove
//
//  Created by nixinyue on 16/6/28.
//  Copyright © 2016年 nixinyue. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GoodsLVOneModel;
@protocol ComplainCellDelegate <NSObject>


- (void)didselectedRowWithModel:(GoodsLVOneModel *)model;


@end


@interface SideView : UIView

@property (nonatomic, strong) UIViewController *baseVC;
//上一层的viewController
@property (nonatomic,assign)id<ComplainCellDelegate>delegate;

- (void)show;
- (void)dismiss;

- (void)setthedic:(NSDictionary *)dic;

@property (nonatomic , strong) NSMutableArray  *dataArr;


@property (nonatomic, assign) int type;

@property (nonatomic, strong) NSString *ident_trainer;

@property (nonatomic, strong) NSString *trainer_name;

@property (nonatomic, strong) NSString *trainer_phone;

@property (nonatomic, strong) NSDictionary *yuyueInfo;


@end
