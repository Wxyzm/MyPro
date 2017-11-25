//
//  MasterProModel.h
//  FyhNewProj
//
//  Created by yh f on 2017/11/13.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MasterProModel : NSObject

@property (nonatomic,assign)NSInteger masterId;
@property (nonatomic,assign)NSInteger accountId;
@property (nonatomic,copy)NSString *name;
@property (nonatomic,copy)NSString *specificationIds;
@property (nonatomic,assign)NSInteger categoryId;
@property (nonatomic,copy)NSString *imageUrl;
@property (nonatomic,copy)NSString *detail;
@property (nonatomic,copy)NSString *unit;
@property (nonatomic,copy)NSString *skuCode;
@property (nonatomic,copy)NSString *createTime;
@property (nonatomic,copy)NSString *updateTime;
@property (nonatomic,assign)NSInteger status;
@property (nonatomic,assign)BOOL isSample;
@property (nonatomic,strong)NSArray *itemList;

@property (nonatomic,strong)NSArray *attributes;
@property (nonatomic,strong)NSArray *imageUrlList;

@property (nonatomic,assign)BOOL isSelected;


@end

