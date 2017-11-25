//
//  GShopModel.h
//  FyhNewProj
//
//  Created by yh f on 2017/5/23.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GShopModel : NSObject

@property (nonatomic , copy) NSString *shopId;

@property (nonatomic , copy) NSString *shopAddress;

@property (nonatomic , copy) NSString *shopArea;

@property (nonatomic , copy) NSString *shopCertificationStatus;

@property (nonatomic , assign) NSInteger shopCertificationType;

@property (nonatomic , copy) NSString *shopDescription;

@property (nonatomic , copy) NSString *shopFacadeImageUrl;

@property (nonatomic , copy) NSString *shopLogoImageUrl;

@property (nonatomic , copy) NSString *shopName;

@property (nonatomic , copy) NSString *sellerInfo;



@end
