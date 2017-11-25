//
//  BankCardModel.h
//  FyhNewProj
//
//  Created by yh f on 2017/9/14.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BankCardModel : NSObject


@property (nonatomic , copy) NSString *accountId;               //卡主人id

@property (nonatomic , copy) NSString *bankAccountName;         //卡主人名称

@property (nonatomic , copy) NSString *bankAccountNumber;       //银行卡号码

@property (nonatomic , copy) NSString *bankAddress;             //银行地址

@property (nonatomic , copy) NSString *bankName;                //银行名称

@property (nonatomic , copy) NSString *cardId;                  //银行卡id

@property (nonatomic , assign) BOOL isFromCertification;        //取false

@property (nonatomic , assign) NSInteger type;

@property (nonatomic , assign) BOOL selected;



@end
