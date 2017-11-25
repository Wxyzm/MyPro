//
//  AccessCellModel.h
//  FyhNewProj
//
//  Created by yh f on 2017/6/20.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AccessCellModel : NSObject
@property (nonatomic , strong) UIImage *image;

@property (nonatomic , copy) NSString *mainImageUrl;
@property (nonatomic , copy) NSString *cndUrl;


@property (nonatomic , copy) NSString *kind;

@property (nonatomic , copy) NSString *color;

@property (nonatomic , copy) NSString *state;

@property (nonatomic , assign) NSInteger stock;

@property (nonatomic , assign) NSInteger minBuy;

@property (nonatomic , assign) NSInteger limitBuy;


@property (nonatomic , copy) NSString *price;

@property (nonatomic , assign) BOOL select;

@property (nonatomic , assign) BOOL isopen;

@end
