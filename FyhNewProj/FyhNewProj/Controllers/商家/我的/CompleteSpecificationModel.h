//
//  CompleteSpecificationModel.h
//  FyhNewProj
//
//  Created by yh f on 2017/6/17.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SpecificationModel;

@interface CompleteSpecificationModel : NSObject

@property (nonatomic , strong) SpecificationModel *specification;

@property (nonatomic , strong) NSArray *specificationValueList;


@end
