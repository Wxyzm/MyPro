//
//  AdressModel.h
//  FyhNewProj
//
//  Created by yh f on 2017/6/30.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AdressModel : NSObject

@property (nonatomic , copy) NSString *accountId;                //账号id
@property (nonatomic , copy) NSString *area;                     //
@property (nonatomic , copy) NSString *areaCode;                 //
@property (nonatomic , copy) NSString *city;                     //
@property (nonatomic , copy) NSString *cityCode;                 //
@property (nonatomic , copy) NSString *consigneeAddress;         //
@property (nonatomic , copy) NSString *consigneeName;            //
@property (nonatomic , copy) NSString *countryCode;              //
@property (nonatomic , copy) NSString *addressid;                       //
@property (nonatomic , copy) NSString *mobile;                   //
@property (nonatomic , copy) NSString *mobileCountry;            //
@property (nonatomic , copy) NSString *province;                 //
@property (nonatomic , copy) NSString *provinceCode;             //
@property (nonatomic , copy) NSString *status;                   //
@property (nonatomic , copy) NSString *street;                   //
@property (nonatomic , copy) NSString *streetCode;                //
@property (nonatomic , assign) BOOL isDefaultAdress;                //


@end
