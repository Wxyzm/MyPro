//
//  UserInfoChangePL.h
//  FyhNewProj
//
//  Created by yh f on 2017/4/25.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import <Foundation/Foundation.h>
@class UserInfoModel;

@interface UserInfoChangePL : NSObject

@property (nonatomic , strong) UserInfoModel *infoModel;


- (void)getUserInfoWithReturnBlock:(PLReturnValueBlock)returnBlock andErrorBlock:(PLErrorCodeBlock)errorBlock;



- (void)upuserInfoWithReturnBlock:(PLReturnValueBlock)returnBlock andErrorBlock:(PLErrorCodeBlock)errorBlock;





@end
