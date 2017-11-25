//
//  SpecificationListEditModel.h
//  FyhNewProj
//
//  Created by yh f on 2017/11/17.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SpecificationListEditModel : NSObject


@property (nonatomic,assign)NSInteger SpecificationListEditId;
@property (nonatomic,assign)NSInteger accountId;
@property (nonatomic,copy)NSString *name;
@property (nonatomic,copy)NSString *memo;
@property (nonatomic,strong)NSMutableArray *specificationValues;



@end
