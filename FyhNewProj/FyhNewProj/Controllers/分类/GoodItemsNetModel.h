//
//  GoodItemsNetModel.h
//  FyhNewProj
//
//  Created by yh f on 2017/5/22.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GoodItemsNetModel : NSObject

@property (nonatomic , assign) NSInteger pageNum;

@property (nonatomic , copy) NSString *title;

@property (nonatomic , copy) NSString *categoryId;

@property (nonatomic , copy) NSString *sort;

@end
