//
//  IdeaCellModel.h
//  FyhNewProj
//
//  Created by yh f on 2017/6/16.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IdeaCellModel : NSObject

@property (nonatomic , strong) UIImage *image;

@property (nonatomic , copy) NSString *mainImageUrl;

@property (nonatomic , copy) NSString *cndUrl;

@property (nonatomic , copy) NSString *kind;

@property (nonatomic , copy) NSString *use;

@property (nonatomic , assign) NSInteger stock;

@property (nonatomic , copy) NSString *price;

@property (nonatomic , assign) BOOL select;

@property (nonatomic , assign) BOOL isopen;


@end
