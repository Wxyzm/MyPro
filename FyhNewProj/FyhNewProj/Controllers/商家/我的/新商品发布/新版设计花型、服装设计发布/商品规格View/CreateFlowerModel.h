//
//  CreateFlowerModel.h
//  FyhNewProj
//
//  Created by yh f on 2017/11/9.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SampleColthModel;

@interface CreateFlowerModel : NSObject

@property (nonatomic,assign)BOOL isFirstEdit;               //第一次编辑默认三种颜色

@property (nonatomic,strong)NSMutableArray *kindArr;        //类型

@property (nonatomic,strong)NSMutableArray *statusArr;      //状态

@property (nonatomic,strong)SampleColthModel *colthModel;   //买断

@property (nonatomic,strong)NSMutableArray *dataArr;        //大货

@property (nonatomic,strong)NSMutableArray *photoArr;       //商品主图数组

@property (nonatomic,strong)UIImage *mineImage;             //商自己添加的主图
@property (nonatomic,assign)NSInteger editType;             //编辑状态 0 ! 未编辑  1未完成  2已完成 3修改

@end
