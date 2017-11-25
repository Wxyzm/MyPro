//
//  WithdrawalListModel.h
//  FyhNewProj
//
//  Created by yh f on 2017/9/18.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WithdrawalListModel : NSObject

@property (nonatomic , copy) NSString *accountId;

@property (nonatomic , copy) NSString *amount;

@property (nonatomic , copy) NSString *bankCardId;

@property (nonatomic , copy) NSString *createTime;

@property (nonatomic , copy) NSString *listId;

@property (nonatomic , copy) NSString *memo;

@property (nonatomic , copy) NSString *resultTime;

@property (nonatomic , assign) NSInteger status;

@end
