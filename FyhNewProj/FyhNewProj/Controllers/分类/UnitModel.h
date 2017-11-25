//
//  UnitModel.h
//  FyhNewProj
//
//  Created by yh f on 2017/5/25.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UnitModel : NSObject

@property (nonatomic , copy) NSString *unitId;

@property (nonatomic , copy) NSString *accountId;

@property (nonatomic , copy) NSString *specificationId;

@property (nonatomic , copy) NSString *name;

@property (nonatomic , assign) NSInteger originId;


@property (nonatomic , assign) BOOL on;


@end
