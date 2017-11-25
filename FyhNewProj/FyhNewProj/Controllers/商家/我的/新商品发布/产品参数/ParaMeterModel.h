//
//  ParaMeterModel.h
//  FyhNewProj
//
//  Created by yh f on 2017/10/30.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ComponentModel;

typedef NS_ENUM(NSInteger, KindWayType) {
    INPUT_WAY             = 1,  //纯输入
    SELECT_WAY            = 2,  //纯选择
    ALLTWO_WAY            = 3   //两种都存在
    };


@interface ParaMeterModel : NSObject

@property (nonatomic,copy)       NSString *ParaKind;         //属性种类

@property (nonatomic,assign)  KindWayType KindWay;           //是否是输入格式

@property (nonatomic,copy)       NSString *inputValue;       //输入数值

@property (nonatomic,copy) NSMutableArray *ParaNameArr;      //属性值数组

@property (nonatomic,copy)       NSString *twoValue;         //半输入半选择数值

@property (nonatomic,copy)       NSString *twoUnit;          //半输入半选择单位

@property (nonatomic,assign)        BOOL  isNew;            //是新增属性


@property (nonatomic,copy) ComponentModel *componentModel;          //成分数组 里面是dic {NSMutableDictionary unit isFirst}

@end
