//
//  ComponentModel.h
//  FyhNewProj
//
//  Created by yh f on 2017/11/8.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ComponentModel : NSObject


@property (nonatomic,assign)BOOL isFirstEdit;

@property (nonatomic,strong)NSMutableArray *chenfenArr;

@property (nonatomic,copy)NSString *upStr;              //上传是所用


@end
