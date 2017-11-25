//
//  AssetDetailModel.h
//  FyhNewProj
//
//  Created by yh f on 2017/9/16.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AssetDetailModel : NSObject

@property (nonatomic , copy) NSString *amount;

@property (nonatomic , copy) NSString *name;

@property (nonatomic , assign) NSInteger type;

@property (nonatomic , copy) NSString *memo;

@property (nonatomic , copy) NSString *createTime;

@end
