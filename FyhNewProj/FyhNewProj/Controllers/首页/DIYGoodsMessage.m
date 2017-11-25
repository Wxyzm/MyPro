//
//  DIYGoodsMessage.m
//  FyhNewProj
//
//  Created by yh f on 2017/9/7.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import "DIYGoodsMessage.h"


@implementation DIYGoodsMessage
+(instancetype)messageWithContent:(NSString *)content title:(NSString *)title imageUrl:(NSString *)imageUrl type:(NSString *)type proId:(NSString *)proId price:(NSString *)price{
    DIYGoodsMessage *msg = [[DIYGoodsMessage alloc] init];
    if (msg) {
        msg.content = content;
    }
    if (msg) {
        msg.title = title;
    }
    if (msg) {
        msg.imageUrl = imageUrl;
    }
    if (msg) {
        msg.type = type;
    }
    if (msg) {
        msg.proId = proId;
    }
    if (msg) {
        msg.price = price;
    }
    
    return msg;
}

+(RCMessagePersistent)persistentFlag {
    return (MessagePersistent_ISPERSISTED | MessagePersistent_ISCOUNTED);
}

#pragma mark – NSCoding protocol methods
#define KEY_TXTMSG_CONTENT @"content"
#define KEY_TXTMSG_EXTRA @"extra"


/*@property(nonatomic,strong)NSString *title;
 @property(nonatomic, strong)NSString* imageUrl;
 @property(nonatomic,strong)NSString *content;
 @property(nonatomic,strong)NSString *type;
 @property(nonatomic,strong)NSString *proId;*/
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        self.content = [aDecoder decodeObjectForKey:KEY_TXTMSG_CONTENT];
        self.title = [aDecoder decodeObjectForKey:@"title"];
        self.imageUrl = [aDecoder decodeObjectForKey:@"imageUrl"];
        self.type = [aDecoder decodeObjectForKey:@"type"];
        self.proId = [aDecoder decodeObjectForKey:@"proId"];
        self.price = [aDecoder decodeObjectForKey:@"price"];

        self.extra = [aDecoder decodeObjectForKey:KEY_TXTMSG_EXTRA];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.content forKey:KEY_TXTMSG_CONTENT];
    [aCoder encodeObject:self.extra forKey:KEY_TXTMSG_EXTRA];
    [aCoder encodeObject:self.title forKey:@"title"];
    [aCoder encodeObject:self.imageUrl forKey:@"imageUrl"];
    [aCoder encodeObject:self.type forKey:@"type"];
    [aCoder encodeObject:self.proId forKey:@"proId"];
    [aCoder encodeObject:self.price forKey:@"price"];



}

#pragma mark – RCMessageCoding delegate methods

-(NSData *)encode {
    
    NSMutableDictionary *dataDict=[NSMutableDictionary dictionary];
    [dataDict setObject:self.content forKey:@"content"];
    [dataDict setObject:self.title forKey:@"title"];
    [dataDict setObject:self.imageUrl forKey:@"imageUrl"];
    [dataDict setObject:self.type forKey:@"type"];
    [dataDict setObject:self.proId forKey:@"proId"];
    [dataDict setObject:self.price forKey:@"price"];

    if (self.extra) {
        [dataDict setObject:self.extra forKey:@"extra"];
    }
    
    if (self.senderUserInfo) {
        NSMutableDictionary *__dic=[[NSMutableDictionary alloc]init];
        if (self.senderUserInfo.name) {
            [__dic setObject:self.senderUserInfo.name forKeyedSubscript:@"name"];
        }
        if (self.senderUserInfo.portraitUri) {
            [__dic setObject:self.senderUserInfo.portraitUri forKeyedSubscript:@"icon"];
        }
        if (self.senderUserInfo.userId) {
            [__dic setObject:self.senderUserInfo.userId forKeyedSubscript:@"id"];
        }
        [dataDict setObject:__dic forKey:@"user"];
    }
    
    //NSDictionary* dataDict = [NSDictionary dictionaryWithObjectsAndKeys:self.content, @"content", nil];
    NSData *data = [NSJSONSerialization dataWithJSONObject:dataDict
                                                   options:kNilOptions
                                                     error:nil];
    return data;
}

-(void)decodeWithData:(NSData *)data {
    __autoreleasing NSError* __error = nil;
    if (!data) {
        return;
    }
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data
                                                         options:kNilOptions
                                                           error:&__error];
    if (dictionary) {
        if (IsEmptyStr(dictionary[@"content"])) {
            self.content = @"";
        }else{
            self.content = dictionary[@"content"];
            
        }
        self.extra = dictionary[@"extra"];
        self.title = dictionary[@"title"];
        self.imageUrl = dictionary[@"imageUrl"];
        self.type = dictionary[@"type"];
        self.proId = dictionary[@"proId"];
        self.price = dictionary[@"price"];

        NSDictionary *userinfoDic = dictionary[@"user"];
        [self decodeUserInfo:userinfoDic];
    }
}



- (NSString *)conversationDigest
{
    return @"会话列表要显示的内容";
}
+(NSString *)getObjectName {
    return @"app:FYH";
}
#if ! __has_feature(objc_arc)
-(void)dealloc
{
    [super dealloc];
}
#endif//__has_feature(objc_arc)

@end
