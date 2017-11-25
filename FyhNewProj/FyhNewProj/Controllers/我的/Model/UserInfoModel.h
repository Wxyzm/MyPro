//
//  UserInfoModel.h
//  FyhNewProj
//
//  Created by yh f on 2017/4/24.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfoModel : NSObject


@property (nonatomic , copy) NSString  *nickname;            //昵称

@property (nonatomic , copy) NSString  *accountId;           //id

@property (nonatomic , copy) NSString  *avatarUrl;           //头像地址

@property (nonatomic , copy) NSString  *loginIp;             //ip

@property (nonatomic , copy) NSString  *loginTime;           //时间

@property (nonatomic , copy) NSString  *gender;              //性别 1表示男，2表示女

@property (nonatomic , copy) NSString  *birthday;            //生日

@property (nonatomic , copy) NSString  *upUrl;            //生日

@property (nonatomic , copy) NSString  *relativeAvatarUrl;

@end
