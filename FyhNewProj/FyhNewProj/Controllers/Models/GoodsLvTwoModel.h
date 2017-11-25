//
//  GoodsLvTwoModel.h
//  FyhNewProj
//
//  Created by yh f on 2017/5/3.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import <Foundation/Foundation.h>
@class GoodsLvThreeModel;
@interface GoodsLvTwoModel : NSObject

@property (nonatomic , copy) NSString *categoryId;

@property (nonatomic , copy) NSString *name;

@property (nonatomic , copy) NSString *parentId;

@property (nonatomic , copy) NSString *logoUrl;

@property (nonatomic , copy) NSString *level;

@property (nonatomic , strong) NSMutableArray *threeModelArr;


@end
