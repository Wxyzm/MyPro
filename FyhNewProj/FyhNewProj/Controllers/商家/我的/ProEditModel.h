//
//  ProEditModel.h
//  FyhNewProj
//
//  Created by yh f on 2017/11/16.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProEditModel : NSObject

@property (nonatomic,assign)NSInteger ProId;                //产品id
@property (nonatomic,assign)NSInteger accountId;            //账号id
@property (nonatomic,copy)NSString *name;                   //产品名称
@property (nonatomic,copy)NSString *specificationIds;       //产品规格总Id（类型、颜色等）
@property (nonatomic,assign)NSInteger categoryId;           //
@property (nonatomic,copy)NSString *imageUrl;               //不带cdn的图片网址
@property (nonatomic,copy)NSString *detail;                 //html
@property (nonatomic,copy)NSString *unit;                   //null
@property (nonatomic,copy)NSString *skuCode;                //null
@property (nonatomic,copy)NSString *createTime;             //创建时间
@property (nonatomic,copy)NSString *updateTime;             //跟新时间
@property (nonatomic,assign)NSInteger status;               //产品状态 0仓库中 1上架中
@property (nonatomic,assign)BOOL isSample;                  //是否在样品间
@property (nonatomic,copy)NSString *categoryDescription;    //产品类目 （"坯布/半漂布/混纺/锦涤纺")
@property (nonatomic,strong)NSMutableArray *categoryDescriptionArray;//产品类目名称数组
@property (nonatomic,strong)NSMutableArray *categoryPath;   //产品类目详细分类
@property (nonatomic,strong)NSMutableArray *attributes;     //产品参数数组
@property (nonatomic,strong)NSMutableArray *specificationList;     //产品规格数组
@property (nonatomic,assign)NSInteger itemsCount;            //商品组个个数
@property (nonatomic,strong)NSMutableArray *items;           //商品
@property (nonatomic,strong)NSMutableArray *itemsInCurrentSpecification;    // //商品
@property (nonatomic,strong)NSMutableArray *imageUrlList;    //产品图片数组


@end
