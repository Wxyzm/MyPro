//
//  JYLocation.h
//  JYAreaPicker
//
//  Created by nixinyue on 14-8-7.
//  Copyright (c) 2014年 nixinyue. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JYLocation : NSObject

@property (copy, nonatomic) NSString *country; //国家
@property (copy, nonatomic) NSString *state;   //省、区
@property (copy, nonatomic) NSString *city;    //市
@property (copy, nonatomic) NSString *district;//区
@property (copy, nonatomic) NSString *street;  //街
@property (nonatomic) double latitude;         //维度
@property (nonatomic) double longitude;        //经度

@end
