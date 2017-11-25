//
//  BussModel.h
//  FyhNewProj
//
//  Created by yh f on 2017/11/21.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BussModel : NSObject

@property (nonatomic,copy)NSString *corporateName;                              //公司名

@property (nonatomic,copy)NSString *legalPersonName;                            //法人名字

@property (nonatomic,copy)NSString *legalPersonIdentificationType;              //法人证件类型

@property (nonatomic,copy)NSString *legalPersonIdentificationNumber;            //法人证件号

@property (nonatomic,copy)NSString *businessLicenseNumber;                      //营业执照号

@property (nonatomic,copy)NSString *businessLicensePicUrl;                      //营业执照照片图片url，不带域名

@property (nonatomic,copy)NSString *legalPersonIdentificationHeadPicUrl;        //法人证件正面图片url，不带域名

@property (nonatomic,copy)NSString *legalPersonIdentificationBackPicUrl;        //法人证件反面图片url，不带域名

@property (nonatomic,copy)NSString *bankAccountName;                            //银行开户公司名

@property (nonatomic,copy)NSString *bankAccountNumber;                          //银行开户帐号

@property (nonatomic,copy)NSString *bankName;                                   //开户银行名

@property (nonatomic,copy)NSString *bankAddress;                                //开户银行所在地

@end
