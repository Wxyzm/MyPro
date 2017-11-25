//
//  DIYGoodsMessage.h
//  FyhNewProj
//
//  Created by yh f on 2017/9/7.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import <RongIMLib/RongIMLib.h>

@interface DIYGoodsMessage : RCMessageContent<NSCoding,RCMessageContentView>


@property(nonatomic,strong)NSString *title;
@property(nonatomic,strong)NSString *imageUrl;
@property(nonatomic,strong)NSString *type;
@property(nonatomic,strong)NSString *proId;
@property(nonatomic,strong)NSString *price;


@property(nonatomic,strong)NSString *content;
@property(nonatomic, strong) NSString* extra;
+(instancetype)messageWithContent:(NSString *)content title:(NSString *)title imageUrl:(NSString *)imageUrl type:(NSString *)type proId:(NSString *)proId price:(NSString *)price;
@end
