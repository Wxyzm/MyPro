//
//  FabricUnitModel.h
//  FyhNewProj
//
//  Created by yh f on 2017/11/4.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SampleCardModel;
@class SampleColthModel;

@interface FabricUnitModel : NSObject

@property (nonatomic,assign)BOOL isFirstEdit;               //第一次编辑默认三种颜色

@property (nonatomic,assign)NSInteger editType;             //编辑状态 0 ! 未编辑  1未完成  2已完成 3修改

@property (nonatomic,strong)NSMutableArray *kindArr;        //类型

@property (nonatomic,strong)NSMutableArray *statusArr;      //状态

@property (nonatomic,strong)NSMutableArray *colorArr;       //颜色

@property (nonatomic,strong)SampleCardModel *cardModel;     //样卡

@property (nonatomic,strong)SampleColthModel *colthModel;   //样布

@property (nonatomic,strong)NSMutableArray *dataArr;        //

@property (nonatomic,strong)NSMutableArray *photoArr;       //商品主图数组

@property (nonatomic,strong)UIImage *mineImage;             //商自己添加的主图



@end
