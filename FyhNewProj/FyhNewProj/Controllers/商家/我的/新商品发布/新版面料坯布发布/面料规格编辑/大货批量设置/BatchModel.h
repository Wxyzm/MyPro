//
//  BatchModel.h
//  FyhNewProj
//
//  Created by yh f on 2017/11/6.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BatchModel : NSObject

@property (nonatomic,assign)BOOL isOn;

@property (nonatomic,assign)NSInteger type;    //0坯布面料  1花型设计  2服装设计  3辅料  4服装  5家纺


@property (nonatomic,copy)NSString *kind;

@property (nonatomic,copy)NSString *minePictureStr;

@property (nonatomic,copy)NSString *price;

@property (nonatomic,copy)NSString *stock;

@property (nonatomic,copy)NSString *mineBuy;

@property (nonatomic,copy)NSString *limitBuy;


@property (nonatomic,strong)NSMutableArray *pictureArr;

@property (nonatomic,strong)UIImage *minePicture;

@property (nonatomic,copy)NSString *cndUrl;

@end
