//
//  HTTPClient.m
//  mry
//
//  Created by apple on 16/1/27.
//  Copyright © 2016年 mibao. All rights reserved.
//

#import "HTTPClient.h"

@implementation HTTPClient
{
    NSOperationQueue *_queue;
    NSString         *_baseUrl;
}

+ (NSString *)getUserSessiond
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:FYHSessionId];
}

+ (HTTPClient *)sharedHttpClient
{
    static HTTPClient *_sharedPHPHelper = nil;
    
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        _sharedPHPHelper = [[self alloc] initWithBaseUrl:kbaseUrl];
    });
    
    return _sharedPHPHelper;
}

- (instancetype)initWithBaseUrl:(NSString *)baseUrl
{
    self = [super init];
    if (self) {
        _baseUrl = baseUrl;
        _queue = [[NSOperationQueue alloc] init];
    }
    return self;
}

//获取request
- (void)setRequestWithInfo:(NSDictionary *)info url:(NSString *)urlStr method:(NSString *)method requset:(NSMutableURLRequest *)request
{
    NSURL *url;
    if ([method isEqualToString:@"GET"]) {
        if (info) {
            NSArray *keyArray = [info allKeys];
            NSMutableString *str = [NSMutableString string];
            [str appendString:@"?"];
            NSString *key = keyArray[0];
            [str appendString:[NSString stringWithFormat:@"%@=%@",key,[info objectForKey:key]]];
            for (int i = 1;i < keyArray.count;i++) {
                key = keyArray[i];
                if (key.length)
                    [str appendString:[NSString stringWithFormat:@"&%@=%@",key,[info objectForKey:key]]];
                

            }
            url = [NSURL URLWithString:[[NSString stringWithFormat:@"%@%@%@",_baseUrl,urlStr?urlStr:@"",str] stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding]];
        } else {
            url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",_baseUrl,urlStr?urlStr:@""]];
        }
    } else {
        NSString *URLWithString = [NSString stringWithFormat:@"%@%@",_baseUrl,urlStr?urlStr:@""];
        NSString *encodedString = (NSString *)
        
        CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                  
                                                                  (CFStringRef)URLWithString,
                                                                  
                                                                  (CFStringRef)@"!$&'()*+,-./:;=?@_~%#[]",
                                                                  
                                                                  NULL,
                                                                  
                                                                  kCFStringEncodingUTF8));
        url = [NSURL URLWithString:[encodedString stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding]];
      //  url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",_baseUrl,urlStr?urlStr:@""]];
    }

    [request setURL:url];
    [request setCachePolicy:NSURLRequestUseProtocolCachePolicy];
    [request setTimeoutInterval:NET_TIME_OUT];
    [request setHTTPMethod:method];
    
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    NSString *timeString = [NSString stringWithFormat:@"%.0f", a];
//    [request setValue:@"FYHIOS" forHTTPHeaderField:@"FYH-App-Key"];
    [request setValue:@"iOS_52" forHTTPHeaderField:@"FYH-App-Key"];
    [request setValue:@"zh_CN" forHTTPHeaderField:@"accept-Language"];

    [request setValue:timeString forHTTPHeaderField:@"FYH-App-Timestamp"];
    //用的是测试的
    [request setValue:@"oIkBLWG4OUHTgYmN" forHTTPHeaderField:@"FYH-App-Signature"];
    //需要在登录后获取 存于本地  注意在用户登出时清掉
    if ([HTTPClient getUserSessiond].length >0) {
        [request setValue:[HTTPClient getUserSessiond] forHTTPHeaderField:@"FYH-Session-Id"];
    }else{
        [request setValue:@"xxx" forHTTPHeaderField:@"FYH-Session-Id"];

    }
    
    if ([method isEqualToString:@"POST"]) {
        NSArray *keyArray = [info allKeys];
        if (keyArray.count >0) {
            NSMutableString *sendStr = [NSMutableString string];
            NSString *key = keyArray[0];
            [sendStr appendString:[NSString stringWithFormat:@"%@=%@",key,[info objectForKey:key]]];
            for (int i = 1;i < keyArray.count;i++) {
                key = keyArray[i];
                if (key.length)
                    [sendStr appendString:[NSString stringWithFormat:@"&%@=%@",key,[info objectForKey:key]]];
            }
            NSData *data = [sendStr dataUsingEncoding:NSUTF8StringEncoding];
            [request setHTTPBody:data];
        }else{
            NSData *data = [@"" dataUsingEncoding:NSUTF8StringEncoding];
            [request setHTTPBody:data];
        }
    }
}


//cbc368b915a1e5585410f28381dc0d5d

//get方式获取
- (void)GET:(NSString *)url
       dict:(NSDictionary *)dict
    success:(void(^)(NSDictionary *))successBlock
    failure:(void(^)(AFHTTPRequestOperation *operation, NSError *error))failureBlock
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [self setRequestWithInfo:dict url:url method:@"GET" requset:request];
   
    AFHTTPRequestOperation * operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             NSDictionary *jsonDic = [NSJSONSerialization  JSONObjectWithData:responseObject options:0 error:nil];
             successBlock(jsonDic);
         });
     }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         failureBlock(operation,error);
     }];
    
    [_queue addOperation:operation];
}

- (void)GET:(NSString *)url
       dict:(NSDictionary *)dict
htmlSuccess:(void(^)(id))successBlock
    failure:(void(^)(AFHTTPRequestOperation *operation, NSError *error))failureBlock
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [self setRequestWithInfo:dict url:url method:@"GET" requset:request];
    
    AFHTTPRequestOperation * operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             successBlock(operation.responseString);
         });
     }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         failureBlock(operation,error);
     }];
    
    [_queue addOperation:operation];
}

//post方式获取
- (void)POST:(NSString *)url
        dict:(NSDictionary *)dict
     success:(void(^)(NSDictionary *))successBlock
     failure:(void(^)(AFHTTPRequestOperation *operation, NSError *error))failureBlock
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [self setRequestWithInfo:dict url:url method:@"POST" requset:request];

    AFHTTPRequestOperation * operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             NSDictionary *resultDic = [NSJSONSerialization  JSONObjectWithData:responseObject options:0 error:nil];
             successBlock(resultDic);
         });
     }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         failureBlock(operation,error);
     }];
    
    [_queue addOperation:operation];
}
//post方式获取
- (void)ImagePOST:(NSString *)url
        dict:(NSData *)Imagedata
     success:(void(^)(NSString *))successBlock
     failure:(void(^)(AFHTTPRequestOperation *operation, NSError *error))failureBlock
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    NSURL *  urlStr = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",_baseUrl,url?url:@""]];
    [request setURL:urlStr];
    [request setCachePolicy:NSURLRequestUseProtocolCachePolicy];
    [request setTimeoutInterval:NET_TIME_OUT];
    [request setHTTPMethod:@"POST"];
    
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    NSString *timeString = [NSString stringWithFormat:@"%.0f", a];
    [request setValue:@"FYHIOS" forHTTPHeaderField:@"FYH-App-Key"];
    [request setValue:timeString forHTTPHeaderField:@"FYH-App-Timestamp"];
    [request setValue:@"multipart/form-data" forHTTPHeaderField:@"Content-Type"];
    //用的是测试的
    [request setValue:@"oIkBLWG4OUHTgYmN" forHTTPHeaderField:@"FYH-App-Signature"];
    //需要在登录后获取 存于本地  注意在用户登出时清掉
    if ([HTTPClient getUserSessiond]) {
        [request setValue:[HTTPClient getUserSessiond] forHTTPHeaderField:@"FYH-Session-Id"];
    }
    
    
            [request setHTTPBody:Imagedata];
    
    AFHTTPRequestOperation * operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             NSString *resultDic = [NSJSONSerialization  JSONObjectWithData:responseObject options:0 error:nil];
             successBlock(resultDic);
         });
     }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         failureBlock(operation,error);
     }];
    
    [_queue addOperation:operation];
}


//json解析
+ (id)valueWithJsonString:(NSString *)jsonString {
    
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    
    id value = [NSJSONSerialization JSONObjectWithData:jsonData
                                               options:NSJSONReadingMutableContainers
                                                 error:&err];
    if(err) {
        return nil;
    }
    
    return value;
}


#pragma mark - 查看当前session登陆状态
- (void)lookUserLoginStatuswithReturnBlock:(PLReturnValueBlock)ReturnBlock
                             andErrorBlock:(PLErrorCodeBlock)errorCodeBlock{
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [self setRequestWithInfo:nil url:UserStatusURL method:@"GET" requset:request];
    
    AFHTTPRequestOperation * operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             NSString *str = operation.responseString;
             ReturnBlock(str);
         });
     }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         errorCodeBlock(@"网络错误");
     }];
    
    [_queue addOperation:operation];




}


#pragma mark - 用户登录
- (void)userLoginName:(NSString *)loginName
             Password:(NSString *)password
      withReturnBlock:(PLReturnValueBlock)ReturnBlock
        andErrorBlock:(PLErrorCodeBlock)errorCodeBlock{

    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:0];
    dict[@"_username"] = [NSString stringWithFormat:@"CN_%@",loginName]; 
    dict[@"_password"] = password;
    [self setRequestWithInfo:dict url:UserLoginURL method:@"POST" requset:request];
    
    AFHTTPRequestOperation * operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             NSString *str = operation.responseString;
             ReturnBlock(str);
         });
     }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         errorCodeBlock(@"网络错误");
     }];
    
    [_queue addOperation:operation];

}


#pragma mark - 用户登出
- (void)userLogoutwithReturnBlock:(PLReturnValueBlock)ReturnBlock
                    andErrorBlock:(PLErrorCodeBlock)errorCodeBlock{

    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [self setRequestWithInfo:nil url:UserLogoutURL method:@"GET" requset:request];
    
    AFHTTPRequestOperation * operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             NSString *str = operation.responseString;
             ReturnBlock(str);
         });
     }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         errorCodeBlock(@"网络错误");
     }];
    
    [_queue addOperation:operation];


}

#pragma mark - 用户注册前获取subSession
- (void)getUserSubSessionwithReturnBlock:(PLReturnValueBlock)ReturnBlock
                           andErrorBlock:(PLErrorCodeBlock)errorCodeBlock{

    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [self setRequestWithInfo:nil url:UserGetRegrestSubSessionURL method:@"GET" requset:request];
    
    AFHTTPRequestOperation * operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             NSString *str = operation.responseString;
             ReturnBlock(str);
         });
     }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         errorCodeBlock(@"网络错误");
     }];
    
    [_queue addOperation:operation];

}


#pragma mark - 发送注册的短信
- (void)sendRegisterSMSWuthInfoDic:(NSDictionary *)infoDic
                   withReturnBlock:(PLReturnValueBlock)ReturnBlock
                     andErrorBlock:(PLErrorCodeBlock)errorCodeBlock{


    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    NSMutableDictionary *dict = [infoDic mutableCopy];
   
    [self setRequestWithInfo:dict url:UserRegistSMSURL method:@"POST" requset:request];
    
    AFHTTPRequestOperation * operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             NSString *str = operation.responseString;
             ReturnBlock(str);
         });
     }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         errorCodeBlock(@"网络错误");
     }];
    
    [_queue addOperation:operation];
}


#pragma mark - 注册
- (void)UserRegisterWithInfoDic:(NSDictionary *)infoDic
                withReturnBlock:(PLReturnValueBlock)ReturnBlock
                  andErrorBlock:(PLErrorCodeBlock)errorCodeBlock{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    NSMutableDictionary *dict = [infoDic mutableCopy];
    
    [self setRequestWithInfo:dict url:UserRegistURL method:@"POST" requset:request];
    
    AFHTTPRequestOperation * operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             NSString *str = operation.responseString;
             ReturnBlock(str);
         });
     }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         errorCodeBlock(@"网络错误");
     }];
    
    [_queue addOperation:operation];


}

#pragma mark - 获取重置密码的subSession
- (void)getUserRetrievePasswordSubSessionwithReturnBlock:(PLReturnValueBlock)ReturnBlock
                                           andErrorBlock:(PLErrorCodeBlock)errorCodeBlock{
  
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [self setRequestWithInfo:nil url:UserGetRePassWordSubSessionURL method:@"GET" requset:request];
    
    AFHTTPRequestOperation * operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             NSString *str = operation.responseString;
             ReturnBlock(str);
         });
     }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         errorCodeBlock(@"网络错误");
     }];
    
    [_queue addOperation:operation];
}

#pragma mark - 发送重置密码的短信
- (void)sendRetrievePasswordSMSWuthInfoDic:(NSDictionary *)infoDic
                           withReturnBlock:(PLReturnValueBlock)ReturnBlock
                             andErrorBlock:(PLErrorCodeBlock)errorCodeBlock{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    NSMutableDictionary *dict = [infoDic mutableCopy];
    
    [self setRequestWithInfo:dict url:UserRePasswordSMSURL method:@"POST" requset:request];
    
    AFHTTPRequestOperation * operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             NSString *str = operation.responseString;
             ReturnBlock(str);
         });
     }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         errorCodeBlock(@"网络错误");
     }];
    
    [_queue addOperation:operation];


}


#pragma mark - 重置密码
- (void)userRetrievePasswordWuthInfoDic:(NSDictionary *)infoDic
                        withReturnBlock:(PLReturnValueBlock)ReturnBlock
                          andErrorBlock:(PLErrorCodeBlock)errorCodeBlock{
  
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    NSMutableDictionary *dict = [infoDic mutableCopy];
    
    [self setRequestWithInfo:dict url:UserRePasswordURL method:@"POST" requset:request];
    
    AFHTTPRequestOperation * operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             NSString *str = operation.responseString;
             ReturnBlock(str);
         });
     }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         errorCodeBlock(@"网络错误");
     }];
    
    [_queue addOperation:operation];




}

#pragma mark - 获取用户轮廓信息
- (void)getUserInfowithReturnBlock:(PLReturnValueBlock)ReturnBlock
                     andErrorBlock:(PLErrorCodeBlock)errorCodeBlock{

    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [self setRequestWithInfo:nil url:@"/user/profile" method:@"GET" requset:request];
    
    AFHTTPRequestOperation * operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             NSString *str = operation.responseString;
             ReturnBlock(str);
         });
     }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         errorCodeBlock(@"网络错误");
     }];
    
    [_queue addOperation:operation];


}
#pragma mark - 设置更新轮廓信息

- (void)refreshUserInfoWithInfoDic:(NSDictionary *)infoDic withReturnBlock:(PLReturnValueBlock)ReturnBlock
                     andErrorBlock:(PLErrorCodeBlock)errorCodeBlock{

    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    NSMutableDictionary *dict = [infoDic mutableCopy];
    
    [self setRequestWithInfo:dict url:@"/user/profile" method:@"POST" requset:request];
    
    AFHTTPRequestOperation * operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             NSString *str = operation.responseString;
             ReturnBlock(str);
         });
     }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         errorCodeBlock(@"网络错误");
     }];
    
    [_queue addOperation:operation];
    
}


#pragma mark - 创建收货地址

- (void)usersetUpAcceptAdressWithDic:(NSDictionary *)infoDic withReturnBlock:(PLReturnValueBlock)ReturnBlock
                   andErrorBlock:(PLErrorCodeBlock)errorCodeBlock{

    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [self setRequestWithInfo:infoDic url:@"/user/address/new" method:@"POST" requset:request];
    
    AFHTTPRequestOperation * operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             NSString *str = operation.responseString;
             ReturnBlock(str);
         });
     }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         errorCodeBlock(@"网络错误");
     }];
    
    [_queue addOperation:operation];
//    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
//    NSMutableDictionary *dict = [infoDic mutableCopy];
//    
//    [self setRequestWithInfo:dict url:@"/user/address/new" method:@"POST" requset:request];
//    
//    AFHTTPRequestOperation * operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
//    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
//     {
//         dispatch_async(dispatch_get_main_queue(), ^{
//             NSString *str = operation.responseString;
//             ReturnBlock(str);
//         });
//     }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//         errorCodeBlock(@"网络错误");
//     }];
//    
//    [_queue addOperation:operation];
}
#pragma mark - 获取商品类目数据
- (void)getGoodsCategorywithReturnBlock:(PLReturnValueBlock)ReturnBlock
                          andErrorBlock:(PLErrorCodeBlock)errorCodeBlock{

    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [self setRequestWithInfo:nil url:@"/index-category" method:@"GET" requset:request];
    
    AFHTTPRequestOperation * operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             NSString *str = operation.responseString;
             ReturnBlock(str);
         });
     }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         errorCodeBlock(@"网络错误");
     }];
    
    [_queue addOperation:operation];

}
#pragma mark - 获取发布商品类目数据
- (void)getFabuGoodsCategorywithReturnBlock:(PLReturnValueBlock)ReturnBlock
                          andErrorBlock:(PLErrorCodeBlock)errorCodeBlock{
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [self setRequestWithInfo:nil url:@"/category" method:@"GET" requset:request];
    
    AFHTTPRequestOperation * operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             NSString *str = operation.responseString;
             ReturnBlock(str);
         });
     }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         errorCodeBlock(@"网络错误");
     }];
    
    [_queue addOperation:operation];
    
}
#pragma mark - 获取采购需求的类目
- (void)getpurchasingneedcategorylistwithReturnBlock:(PLReturnValueBlock)ReturnBlock
                                       andErrorBlock:(PLErrorCodeBlock)errorCodeBlock{

    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [self setRequestWithInfo:nil url:@"/purchasing-need/category-list" method:@"GET" requset:request];
    
    AFHTTPRequestOperation * operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             NSString *str = operation.responseString;
             ReturnBlock(str);
         });
     }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         errorCodeBlock(@"网络错误");
     }];
    
    [_queue addOperation:operation];
}
#pragma mark - 用户创建采购需求
- (void)userUpGoodwithDic:(NSDictionary *)infoDic ReturnBlock:(PLReturnValueBlock)ReturnBlock
            andErrorBlock:(PLErrorCodeBlock)errorCodeBlock{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    NSMutableDictionary *dict = [infoDic mutableCopy];
    
    [self setRequestWithInfo:dict url:@"/user/purchasing-need/new" method:@"POST" requset:request];
    
    AFHTTPRequestOperation * operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             NSString *str = operation.responseString;
             ReturnBlock(str);
         });
     }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         errorCodeBlock(@"网络错误");
     }];
    
    [_queue addOperation:operation];


}
#pragma mark - 用户查看他创建的采购
- (void)userLookHisNeedwithDic:(NSDictionary *)infoDic WithReturnBlock:(PLReturnValueBlock)ReturnBlock
                 andErrorBlock:(PLErrorCodeBlock)errorCodeBlock{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    NSMutableDictionary *dict = [infoDic mutableCopy];
    
    [self setRequestWithInfo:dict url:@"/user/purchasing-need/list" method:@"GET" requset:request];
    
    AFHTTPRequestOperation * operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    
       
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             NSString *str = operation.responseString;
             ReturnBlock(str);
         });
     }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         errorCodeBlock(@"网络错误");
     }];
    
    [_queue addOperation:operation];

}
#pragma mark - 用户删除他的采购需求
- (void)userDeletePurchasingNeedWithNeedId:(NSString *)needId WithReturnBlock:(PLReturnValueBlock)ReturnBlock
                             andErrorBlock:(PLErrorCodeBlock)errorCodeBlock{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    [self setRequestWithInfo:nil url:[NSString stringWithFormat:@"/user/purchasing-need/%@/delete",needId] method:@"POST" requset:request];
    
    AFHTTPRequestOperation * operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             NSString *str = operation.responseString;
             ReturnBlock(str);
         });
     }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         errorCodeBlock(@"网络错误");
     }];
    
    [_queue addOperation:operation];
    
    
}
#pragma mark - 用户编辑采购需求
- (void)userEditPurchasingNeedWithNeedId:(NSString *)needId andDic:(NSDictionary *)dic WithReturnBlock:(PLReturnValueBlock)ReturnBlock
                           andErrorBlock:(PLErrorCodeBlock)errorCodeBlock{

    {
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
         NSMutableDictionary *dict = [dic mutableCopy];
        [self setRequestWithInfo:dict url:[NSString stringWithFormat:@"/user/purchasing-need/%@/edit",needId] method:@"POST" requset:request];
        
        AFHTTPRequestOperation * operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             dispatch_async(dispatch_get_main_queue(), ^{
                 NSString *str = operation.responseString;
                 ReturnBlock(str);
             });
         }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             errorCodeBlock(@"网络错误");
         }];
        
        [_queue addOperation:operation];
        
        
    }

}
#pragma mark - 用户获取被编辑采购需求的数据
- (void)userGetPurchasingNeedWithNeedId:(NSString *)needId WithReturnBlock:(PLReturnValueBlock)ReturnBlock
                          andErrorBlock:(PLErrorCodeBlock)errorCodeBlock{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [self setRequestWithInfo:nil url:[NSString stringWithFormat:@"/user/purchasing-need/%@/edit",needId] method:@"GET" requset:request];
    
    AFHTTPRequestOperation * operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             NSString *str = operation.responseString;
             ReturnBlock(str);
         });
     }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         errorCodeBlock(@"网络错误");
     }];
    
    [_queue addOperation:operation];


}

#pragma mark - 公共页面查看采购需求
- (void)PublicGetPurchasingNeedListWithDic:(NSDictionary *)dic andReturnBlock:(PLReturnValueBlock)ReturnBlock
                             andErrorBlock:(PLErrorCodeBlock)errorCodeBlock{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    NSMutableDictionary  *infodic = [dic mutableCopy];
    [self setRequestWithInfo:infodic url:@"/purchasing-need/list" method:@"GET" requset:request];
    
    AFHTTPRequestOperation * operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             NSString *str = operation.responseString;
             ReturnBlock(str);
         });
     }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         errorCodeBlock(@"网络错误");
     }];
    
    [_queue addOperation:operation];

}
#pragma mark - 公共页面查看采购需求详情
- (void)PublicGetPurchasingNeedDetailithDic:(NSString   *)needId andReturnBlock:(PLReturnValueBlock)ReturnBlock
                              andErrorBlock:(PLErrorCodeBlock)errorCodeBlock{

    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [self setRequestWithInfo:nil url:[NSString stringWithFormat:@"/purchasing-need/%@",needId] method:@"GET" requset:request];
    
    AFHTTPRequestOperation * operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             NSString *str = operation.responseString;
             ReturnBlock(str);
         });
     }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         errorCodeBlock(@"网络错误");
     }];
    
    [_queue addOperation:operation];



}
#pragma mark - 供应商创建报价
- (void)PublicSellerSubmitPriceWithneedDic:(NSDictionary *)dic ReturnBlock:(PLReturnValueBlock)ReturnBlock andErrorBlock:(PLErrorCodeBlock)errorCodeBlock{

    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    NSMutableDictionary *dict = [dic mutableCopy];
    
    [self setRequestWithInfo:dict url:@"/user/quotation/submit" method:@"POST" requset:request];
    
    AFHTTPRequestOperation * operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             NSString *str = operation.responseString;
             ReturnBlock(str);
         });
     }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         errorCodeBlock(@"网络错误");
     }];
    
    [_queue addOperation:operation];

}

#pragma mark - 公共页面获取已经上架的商品
- (void)GETGoodsIetmsWithDic:(NSDictionary *)dic ReturnBlock:(PLReturnValueBlock)ReturnBlock andErrorBlock:(PLErrorCodeBlock)errorCodeBlock{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    NSMutableDictionary *dict = [dic mutableCopy];
    
    [self setRequestWithInfo:dict url:@"/items" method:@"GET" requset:request];
    
    AFHTTPRequestOperation * operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             NSString *str = operation.responseString;
             ReturnBlock(str);
         });
     }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         errorCodeBlock(@"网络错误");
     }];
    
    [_queue addOperation:operation];
}

#pragma mark - 公共页面获取某个的商品数据

- (void)clientgetGoodsdetailwithGoodsId:(NSString *)GoodsId  ReturnBlock:(PLReturnValueBlock)ReturnBlock
                          andErrorBlock:(PLErrorCodeBlock)errorCodeBlock{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    [self setRequestWithInfo:nil url:[NSString stringWithFormat:@"/item/%@",GoodsId] method:@"GET" requset:request];
    
    AFHTTPRequestOperation * operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             NSString *str = operation.responseString;
             ReturnBlock(str);
         });
     }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         errorCodeBlock(@"网络错误");
     }];
    
    [_queue addOperation:operation];



}

#pragma mark - 添加一个商品到购物车
- (void)UserAddGoodsIetmsIntoBuyCaryWithGoodsNumber:(NSString *)number andid:(NSString *)goodsid ReturnBlock:(PLReturnValueBlock)ReturnBlock andErrorBlock:(PLErrorCodeBlock)errorCodeBlock{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    NSDictionary *dict = @{@"quantity":number};

    [self setRequestWithInfo:dict url:[NSString stringWithFormat:@"/user/cart/item/%@/add",goodsid] method:@"POST" requset:request];
    
    AFHTTPRequestOperation * operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             NSString *str = operation.responseString;
             ReturnBlock(str);
         });
     }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         errorCodeBlock(@"网络错误");
     }];
    
    [_queue addOperation:operation];

}
#pragma mark - 批量创建规格
- (void)batchSomeSpecificationwithinfoDic:(NSDictionary *)infodic
                              ReturnBlock:(PLReturnValueBlock)ReturnBlock
                            andErrorBlock:(PLErrorCodeBlock)errorCodeBlock{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    NSMutableDictionary *dict = [infodic mutableCopy];
    
    [self setRequestWithInfo:dict url:@"/user/specification/batch-new" method:@"POST" requset:request];
    
    AFHTTPRequestOperation * operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             NSString *str = operation.responseString;
             ReturnBlock(str);
         });
     }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         errorCodeBlock(@"网络错误");
     }];
    
    [_queue addOperation:operation];
}


#pragma mark - 创建产品
- (void)newProductwithInfoDic:(NSDictionary *)infodic
                  ReturnBlock:(PLReturnValueBlock)ReturnBlock
                andErrorBlock:(PLErrorCodeBlock)errorCodeBlock{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    NSMutableDictionary *dict = [infodic mutableCopy];
    
    [self setRequestWithInfo:dict url:@"/user/product/new" method:@"POST" requset:request];
    
    AFHTTPRequestOperation * operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             NSString *str = operation.responseString;
             ReturnBlock(str);
         });
     }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         errorCodeBlock(@"网络错误");
     }];
    
    [_queue addOperation:operation];
}

#pragma mark - 从产品根据规格组合批量创建商品
- (void)generateProductitemswithInfoDic:(NSDictionary *)infodic
                            ReturnBlock:(PLReturnValueBlock)ReturnBlock
                          andErrorBlock:(PLErrorCodeBlock)errorCodeBlock{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    NSMutableDictionary *dict = [infodic mutableCopy];
    
    [self setRequestWithInfo:dict url:@"/user/items/generate" method:@"POST" requset:request];
    
    AFHTTPRequestOperation * operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             NSString *str = operation.responseString;
             ReturnBlock(str);
         });
     }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         errorCodeBlock(@"网络错误");
     }];
    
    [_queue addOperation:operation];
}

#pragma mark 获取手机App首页配置数据
- (void)getHomePageDataswithReturnBlock:(PLReturnValueBlock)ReturnBlock andErrorBlock:(PLErrorCodeBlock)errorCodeBlock{

    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    [self setRequestWithInfo:nil url:@"/mobile-app-homepage-config" method:@"GET" requset:request];
    
    AFHTTPRequestOperation * operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             NSString *str = operation.responseString;
             ReturnBlock(str);
         });
     }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         errorCodeBlock(@"网络错误");
     }];
    
    [_queue addOperation:operation];


}

#pragma mark - 获取购物车数据
- (void)userGetShopCartDatasWithReturnBlock:(PLReturnValueBlock)ReturnBlock andErrorBlock:(PLErrorCodeBlock)errorCodeBlock{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    [self setRequestWithInfo:nil url:@"/user/cart" method:@"GET" requset:request];
    
    AFHTTPRequestOperation * operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             NSString *str = operation.responseString;
             ReturnBlock(str);
         });
     }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         errorCodeBlock(@"网络错误");
     }];
    
    [_queue addOperation:operation];
}
#pragma mark - 删除购物车里的某个商品
- (void)deleteShopCartItemWithId:(NSString *)itemId
                  andReturnBlock:(PLReturnValueBlock)ReturnBlock
                   andErrorBlock:(PLErrorCodeBlock)errorCodeBlock{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    
    [self setRequestWithInfo:nil url:[NSString stringWithFormat:@"/user/cart/cart-item/%@/delete",itemId] method:@"POST" requset:request];
    
    AFHTTPRequestOperation * operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             NSString *str = operation.responseString;
             ReturnBlock(str);
         });
     }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         errorCodeBlock(@"网络错误");
     }];
    
    [_queue addOperation:operation];


}
#pragma mark - 批量修改购物车商品数量与勾选

- (void)changeShopCartItemWithId:(NSString *)itemStr
                  andReturnBlock:(PLReturnValueBlock)ReturnBlock
                   andErrorBlock:(PLErrorCodeBlock)errorCodeBlock{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    NSDictionary *infoDic = @{@"cartItemList":itemStr};
    [self setRequestWithInfo:infoDic url:@"/user/cart/cart-item/batch-update" method:@"POST" requset:request];
    
    AFHTTPRequestOperation * operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             NSString *str = operation.responseString;
             ReturnBlock(str);
         });
     }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         errorCodeBlock(@"网络错误");
     }];
    
    [_queue addOperation:operation];
    
    
}

#pragma mark - 获取用户所有收货地址
- (void)getUserAllAdressWithReturnBlock:(PLReturnValueBlock)ReturnBlock
                          andErrorBlock:(PLErrorCodeBlock)errorCodeBlock{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    
    [self setRequestWithInfo:nil url:@"/user/address" method:@"GET" requset:request];
    
    AFHTTPRequestOperation * operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             NSString *str = operation.responseString;
             ReturnBlock(str);
         });
     }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         errorCodeBlock(@"网络错误");
     }];
    
    [_queue addOperation:operation];
}


#pragma mark - 设置某个地址为默认地址
- (void)userSetdefaultAdressWithAdressId:(NSString *)adressID
                         WithReturnBlock:(PLReturnValueBlock)ReturnBlock
                           andErrorBlock:(PLErrorCodeBlock)errorCodeBlock{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    
    [self setRequestWithInfo:nil url:[NSString stringWithFormat:@"/user/address/%@/default",adressID] method:@"POST" requset:request];
    
    AFHTTPRequestOperation * operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             NSString *str = operation.responseString;
             ReturnBlock(str);
         });
     }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         errorCodeBlock(@"网络错误");
     }];
    
    [_queue addOperation:operation];
}

#pragma mark - 删除某收货地址
- (void)userdeleteAdressWithAdressId:(NSString *)adressID
                     WithReturnBlock:(PLReturnValueBlock)ReturnBlock
                       andErrorBlock:(PLErrorCodeBlock)errorCodeBlock{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    
    [self setRequestWithInfo:nil url:[NSString stringWithFormat:@"/user/address/%@/delete",adressID] method:@"POST" requset:request];
    
    AFHTTPRequestOperation * operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             NSString *str = operation.responseString;
             ReturnBlock(str);
         });
     }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         errorCodeBlock(@"网络错误");
     }];
    
    [_queue addOperation:operation];
}
#pragma mark - 更新收货地址
- (void)userEditAdressWithAdressId:(NSString *)adressID
                        andInfoDic:(NSDictionary *)dic
                   WithReturnBlock:(PLReturnValueBlock)ReturnBlock
                     andErrorBlock:(PLErrorCodeBlock)errorCodeBlock{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    
    [self setRequestWithInfo:dic url:[NSString stringWithFormat:@"/user/address/%@/edit",adressID] method:@"POST" requset:request];
    
    AFHTTPRequestOperation * operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             NSString *str = operation.responseString;
             ReturnBlock(str);
         });
     }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         errorCodeBlock(@"网络错误");
     }];
    
    [_queue addOperation:operation];
}

#pragma mark - 从购物车开始结算创建订单
- (void)settlementMoneyWithdic:(NSDictionary*)dic andReturnBlock:(PLReturnValueBlock)returnBlock andErrorBlock:(PLErrorCodeBlock)errorBlock{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    
    [self setRequestWithInfo:dic url:@"/user/checkout/create-order-from-cart" method:@"POST" requset:request];
    
    AFHTTPRequestOperation * operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             NSString *str = operation.responseString;
             returnBlock(str);
         });
     }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         errorBlock(@"网络错误");
     }];
    
    [_queue addOperation:operation];
}


#pragma mark - 获取调用支付宝APP支付SDK需要用到的orderStr参数
- (void)getAilPayOrderStrWithOrderId:(NSString *)orderStr andReturnBlock:(PLReturnValueBlock)returnBlock andErrorBlock:(PLErrorCodeBlock)errorBlock{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    
    [self setRequestWithInfo:nil url:[NSString stringWithFormat:@"/payment-channel/ali_app/user-order/%@",orderStr] method:@"GET" requset:request];
    
    AFHTTPRequestOperation * operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             NSString *str = operation.responseString;
             returnBlock(str);
         });
     }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         errorBlock(@"网络错误");
     }];
    
    [_queue addOperation:operation];
}
#pragma mark - 获取调用微信APP支付SDK需要用到的参数
- (void)getWeixinPayOrderStrWithOrderId:(NSString *)orderStr andReturnBlock:(PLReturnValueBlock)returnBlock andErrorBlock:(PLErrorCodeBlock)errorBlock{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    
    [self setRequestWithInfo:nil url:[NSString stringWithFormat:@"/payment-channel/wx_app/user-order/%@",orderStr] method:@"GET" requset:request];
    
    AFHTTPRequestOperation * operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             NSString *str = operation.responseString;
             returnBlock(str);
         });
     }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         errorBlock(@"网络错误");
     }];
    
    [_queue addOperation:operation];
}
#pragma mark - 买家查看店铺信息
- (void)getShopInfoWiId:(NSString *)shopid andDic:(NSDictionary *)dic andReturnBlock:(PLReturnValueBlock)ReturnBlock andErrorBlock:(PLErrorCodeBlock)errorCodeBlock{

    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [self setRequestWithInfo:dic url:[NSString stringWithFormat:@"/shop/%@",shopid] method:@"GET" requset:request];
    
    AFHTTPRequestOperation * operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             NSString *str = operation.responseString;
             ReturnBlock(str);
         });
     }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         errorCodeBlock(@"网络错误");
     }];
    
    [_queue addOperation:operation];
}
#pragma mark - 收藏某个店铺
- (void)userCollectShopWithShopDic:(NSDictionary *)dic
                       ReturnBlock:(PLReturnValueBlock)ReturnBlock
                     andErrorBlock:(PLErrorCodeBlock)errorCodeBlock{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [self setRequestWithInfo:dic url:@"/user/shop-collection/collect" method:@"POST" requset:request];
    
    AFHTTPRequestOperation * operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             NSString *str = operation.responseString;
             ReturnBlock(str);
         });
     }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         errorCodeBlock(@"网络错误");
     }];
    
    [_queue addOperation:operation];
}

#pragma mark - 取消收藏某个店铺
- (void)userCancelCollectShopWithShopDic:(NSDictionary *)dic
                             ReturnBlock:(PLReturnValueBlock)ReturnBlock
                           andErrorBlock:(PLErrorCodeBlock)errorCodeBlock{

    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [self setRequestWithInfo:dic url:@"/user/shop-collection/cancel-collect" method:@"POST" requset:request];
    
    AFHTTPRequestOperation * operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             NSString *str = operation.responseString;
             ReturnBlock(str);
         });
     }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         errorCodeBlock(@"网络错误");
     }];
    
    [_queue addOperation:operation];
}

#pragma mark - 收藏某个商品
- (void)userColectGoodsWithId:(NSString *)goodId
                  ReturnBlock:(PLReturnValueBlock)ReturnBlock
                andErrorBlock:(PLErrorCodeBlock)errorCodeBlock{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [self setRequestWithInfo:nil url:[NSString stringWithFormat:@"/user/item-collection/collect/item/%@",goodId] method:@"POST" requset:request];
    
    AFHTTPRequestOperation * operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             NSString *str = operation.responseString;
             ReturnBlock(str);
         });
     }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         errorCodeBlock(@"网络错误");
     }];
    
    [_queue addOperation:operation];
}



#pragma mark - 删除某个收藏
- (void)useracancleColectGoodsWithId:(NSString *)goodId
                         ReturnBlock:(PLReturnValueBlock)ReturnBlock
                       andErrorBlock:(PLErrorCodeBlock)errorCodeBlock{

    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [self setRequestWithInfo:nil url:[NSString stringWithFormat:@"/user/item-collection/cancel-collect/item/%@",goodId] method:@"POST" requset:request];
    
    AFHTTPRequestOperation * operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             NSString *str = operation.responseString;
             ReturnBlock(str);
         });
     }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         errorCodeBlock(@"网络错误");
     }];
    
    [_queue addOperation:operation];

}
#pragma mark - 获取当前店铺的设置信息
- (void)getUserShopInfoWithReturnBlock:(PLReturnValueBlock)ReturnBlock
                         andErrorBlock:(PLErrorCodeBlock)errorCodeBlock{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [self setRequestWithInfo:nil url:@"/user/shop-setting" method:@"GET" requset:request];
    
    AFHTTPRequestOperation * operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             NSString *str = operation.responseString;
             ReturnBlock(str);
         });
     }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         errorCodeBlock(@"网络错误");
     }];
    
    [_queue addOperation:operation];
    
}
#pragma mark - 批量设置店铺信息
- (void)userSettingShopInfoWithinfoDic:(NSDictionary *)infoDic ReturnBlock:(PLReturnValueBlock)ReturnBlock
                         andErrorBlock:(PLErrorCodeBlock)errorCodeBlock{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [self setRequestWithInfo:infoDic url:@"/user/shop-setting/batch" method:@"POST" requset:request];
    
    AFHTTPRequestOperation * operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             NSString *str = operation.responseString;
             ReturnBlock(str);
         });
     }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         errorCodeBlock(@"网络错误");
     }];
    
    [_queue addOperation:operation];
}

#pragma mark - 获取用户id
- (void)usergetIdwithReturnBlock:(PLReturnValueBlock)ReturnBlock
                   andErrorBlock:(PLErrorCodeBlock)errorCodeBlock{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [self setRequestWithInfo:nil url:@"/user/my-id" method:@"POST" requset:request];
    
    AFHTTPRequestOperation * operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             NSString *str = operation.responseString;
             ReturnBlock(str);
         });
     }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         errorCodeBlock(@"网络错误");
     }];
    
    [_queue addOperation:operation];}

#pragma mark - 获取用户创建的商品
- (void)userGetHisGoodsWithDic:(NSDictionary *)dic ReturnBlock:(PLReturnValueBlock)ReturnBlock andErrorBlock:(PLErrorCodeBlock)errorCodeBlock{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [self setRequestWithInfo:dic url:@"/user/items" method:@"GET" requset:request];
    
    AFHTTPRequestOperation * operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             NSString *str = operation.responseString;
             ReturnBlock(str);
         });
     }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         errorCodeBlock(@"网络错误");
     }];
    
    [_queue addOperation:operation];



}
#pragma mark - 删除创建的商品
- (void)userDeleteHisGoodsWithGoodsid:(NSString *)goodsId ReturnBlock:(PLReturnValueBlock)returnBlock andErrorBlock:(PLErrorCodeBlock)errorBlock{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [self setRequestWithInfo:nil url:[NSString stringWithFormat:@"/user/items/%@/delete",goodsId] method:@"POST" requset:request];
    
    AFHTTPRequestOperation * operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             NSString *str = operation.responseString;
             returnBlock(str);
         });
     }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         errorBlock(@"网络错误");
     }];
    
    [_queue addOperation:operation];
}

#pragma mark - 修改商品上架
- (void)userUpHisGoodsWithGoodsid:(NSString *)goodsId ReturnBlock:(PLReturnValueBlock)returnBlock andErrorBlock:(PLErrorCodeBlock)errorBlock{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [self setRequestWithInfo:nil url:[NSString stringWithFormat:@"/user/items/%@/on-sale",goodsId] method:@"POST" requset:request];
    
    AFHTTPRequestOperation * operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             NSString *str = operation.responseString;
             returnBlock(str);
         });
     }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         errorBlock(@"网络错误");
     }];
    
    [_queue addOperation:operation];
}


#pragma mark - 修改商品下架
- (void)userDownHisGoodsWithGoodsid:(NSString *)goodsId ReturnBlock:(PLReturnValueBlock)returnBlock andErrorBlock:(PLErrorCodeBlock)errorBlock{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [self setRequestWithInfo:nil url:[NSString stringWithFormat:@"/user/items/%@/not-sale",goodsId] method:@"POST" requset:request];
    
    AFHTTPRequestOperation * operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             NSString *str = operation.responseString;
             returnBlock(str);
         });
     }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         errorBlock(@"网络错误");
     }];
    
    [_queue addOperation:operation];
}

#pragma mark - 获取要被修改更新的商品数据
- (void)userGetEditGoodsInfoWithId:(NSString *)itemId
                       ReturnBlock:(PLReturnValueBlock)ReturnBlock
                     andErrorBlock:(PLErrorCodeBlock)errorCodeBlock{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [self setRequestWithInfo:nil url:[NSString stringWithFormat:@"/user/items/%@/edit",itemId] method:@"GET" requset:request];
    
    AFHTTPRequestOperation * operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             NSString *str = operation.responseString;
             ReturnBlock(str);
         });
     }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         errorCodeBlock(@"网络错误");
     }];
    
    [_queue addOperation:operation];
}


#pragma mark - 修改更新商品数据
- (void)userupdataGoodsInfoId:(NSString *)itemId
                     Withinfo:(NSDictionary *)infoDic
                  ReturnBlock:(PLReturnValueBlock)ReturnBlock
                andErrorBlock:(PLErrorCodeBlock)errorCodeBlock{

    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [self setRequestWithInfo:infoDic url:[NSString stringWithFormat:@"/user/items/%@/edit",itemId] method:@"POST" requset:request];
    
    AFHTTPRequestOperation * operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             NSString *str = operation.responseString;
             ReturnBlock(str);
         });
     }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         errorCodeBlock(@"网络错误");
     }];
    
    [_queue addOperation:operation];



}


#pragma mark - 编辑产品
- (void)userChangeProductwithInfoDic:(NSDictionary *)infodic
                           andItemId:(NSString *)itemId
                         ReturnBlock:(PLReturnValueBlock)ReturnBlock
                       andErrorBlock:(PLErrorCodeBlock)errorCodeBlock{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [self setRequestWithInfo:infodic url:[NSString stringWithFormat:@"/user/product/%@/edit",itemId] method:@"POST" requset:request];
    
    AFHTTPRequestOperation * operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             NSString *str = operation.responseString;
             ReturnBlock(str);
         });
     }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         errorCodeBlock(@"网络错误");
     }];
    
    [_queue addOperation:operation];
}
#pragma mark - 买家获取他的ItemOrder
- (void)buyersGetHisItemOrderwithInfoDic:(NSDictionary *)dic
                          andReturnBlock:(PLReturnValueBlock)ReturnBlock
                           andErrorBlock:(PLErrorCodeBlock)errorCodeBlock{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [self setRequestWithInfo:dic url:@"/user/buyer-item-orders" method:@"POST" requset:request];
    
    AFHTTPRequestOperation * operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             NSString *str = operation.responseString;
             ReturnBlock(str);
         });
     }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         errorCodeBlock(@"网络错误");
     }];
    
    [_queue addOperation:operation];
}
#pragma mark - 买家获取他的UserOrder
- (void)buyersGetHisUserOrderwithInfoDic:(NSDictionary *)dic
                          andReturnBlock:(PLReturnValueBlock)ReturnBlock
                           andErrorBlock:(PLErrorCodeBlock)errorCodeBlock{

    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [self setRequestWithInfo:dic url:@"/user/user-orders" method:@"GET" requset:request];
    
    AFHTTPRequestOperation * operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             NSString *str = operation.responseString;
             ReturnBlock(str);
         });
     }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         errorCodeBlock(@"网络错误");
     }];
    
    [_queue addOperation:operation];
}

#pragma mark - 卖家获取分组后的商品订单
- (void)SellersGetHisGroupItemOrderwithInfoDic:(NSDictionary *)dic
                                andReturnBlock:(PLReturnValueBlock)ReturnBlock
                                 andErrorBlock:(PLErrorCodeBlock)errorCodeBlock{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [self setRequestWithInfo:dic url:@"/user/seller-group-item-orders" method:@"GET" requset:request];
    
    AFHTTPRequestOperation * operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             NSString *str = operation.responseString;
             ReturnBlock(str);
         });
     }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         errorCodeBlock(@"网络错误");
     }];
    
    [_queue addOperation:operation];
}

#pragma mark - 卖家批量添加物流信息并发货
- (void)SellersupdatelogisticswithInfoDic:(NSDictionary *)dic
                           andReturnBlock:(PLReturnValueBlock)ReturnBlock
                            andErrorBlock:(PLErrorCodeBlock)errorCodeBlock
{

    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [self setRequestWithInfo:dic url:@"/user/item-order/batch-update-logistics" method:@"POST" requset:request];
    
    AFHTTPRequestOperation * operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             NSString *str = operation.responseString;
             ReturnBlock(str);
         });
     }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         errorCodeBlock(@"网络错误");
     }];
    
    [_queue addOperation:operation];

}
#pragma mark - 买家批量确认收货
- (void)buyersmakeSureAcceptedGoodsWithinfoDic:(NSDictionary *)infoDic
                                   ReturnBlock:(PLReturnValueBlock)returnBlock
                                 andErrorBlock:(PLErrorCodeBlock)errorBlick{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [self setRequestWithInfo:infoDic url:@"/user/item-order/batch-receive" method:@"POST" requset:request];
    
    AFHTTPRequestOperation * operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             NSString *str = operation.responseString;
             returnBlock(str);
         });
     }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         errorBlick(@"网络错误");
     }];
    
    [_queue addOperation:operation];
}
#pragma mark - 买家取消某个UserOrder
- (void)buyersCancleUserOrderwithorderID:(NSString *)orderId
                          andReturnBlock:(PLReturnValueBlock)ReturnBlock
                           andErrorBlock:(PLErrorCodeBlock)errorCodeBlock{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [self setRequestWithInfo:nil url:[NSString stringWithFormat:@"/user/user-order/%@/cancel",orderId] method:@"POST" requset:request];
    
    AFHTTPRequestOperation * operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             NSString *str = operation.responseString;
             ReturnBlock(str);
         });
     }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         errorCodeBlock(@"网络错误");
     }];
    
    [_queue addOperation:operation];
}

#pragma mark - 买家获取他按照卖家分组后的ItemOrder
- (void)buyersGetHisgroupItemOrderswithInfoDic:(NSDictionary *)dic
                                andReturnBlock:(PLReturnValueBlock)ReturnBlock
                                 andErrorBlock:(PLErrorCodeBlock)errorCodeBlock{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [self setRequestWithInfo:dic url:@"/user/buyer-group-item-orders" method:@"GET" requset:request];
    
    AFHTTPRequestOperation * operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             NSString *str = operation.responseString;
             ReturnBlock(str);
         });
     }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         errorCodeBlock(@"网络错误");
     }];
    
    [_queue addOperation:operation];
}

#pragma mark - 获取用户的商品收藏
- (void)getUserGoodsCollecteShopWithDic:(NSDictionary *)dic andReturnBlock:(PLReturnValueBlock)returnBlock andErrorBlock:(PLErrorCodeBlock)errorBlick{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [self setRequestWithInfo:dic url:@"/user/item-collection/list" method:@"GET" requset:request];
    
    AFHTTPRequestOperation * operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             NSString *str = operation.responseString;
             returnBlock(str);
         });
     }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         errorBlick(@"网络错误");
     }];
    
    [_queue addOperation:operation];
}
#pragma mark - 获取用户收藏的店铺
- (void)getUserShopsCollecteShopWithDic:(NSDictionary *)dic andReturnBlock:(PLReturnValueBlock)returnBlock andErrorBlock:(PLErrorCodeBlock)errorBlick{

    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [self setRequestWithInfo:dic url:@"/user/shop-collection/list" method:@"GET" requset:request];
    
    AFHTTPRequestOperation * operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             NSString *str = operation.responseString;
             returnBlock(str);
         });
     }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         errorBlick(@"网络错误");
     }];
    
    [_queue addOperation:operation];
}
#pragma mark - 买家获取相关商品订单数目数据
- (void)buyersGetordercountsWithReturnBlock:(PLReturnValueBlock)returnBlock
                              andErrorBlock:(PLErrorCodeBlock)errorBlick{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [self setRequestWithInfo:nil url:@"/user/buyer-order-count" method:@"POST" requset:request];
    
    AFHTTPRequestOperation * operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             NSString *str = operation.responseString;
             returnBlock(str);
         });
     }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         errorBlick(@"网络错误");
     }];
    
    [_queue addOperation:operation];
}


#pragma mark - 卖家获取相关商品订单数目数据
- (void)sellersGetordercountsWithReturnBlock:(PLReturnValueBlock)returnBlock
                               andErrorBlock:(PLErrorCodeBlock)errorBlick{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [self setRequestWithInfo:nil url:@"/user/seller-order-count" method:@"POST" requset:request];
    
    AFHTTPRequestOperation * operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             NSString *str = operation.responseString;
             returnBlock(str);
         });
     }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         errorBlick(@"网络错误");
     }];
    
    [_queue addOperation:operation];
}
#pragma mark - 用户查看采购需求详情包括供应商的报价
- (void)userLookHisNeedwithPricewithId:(NSString *)needId
                       WithReturnBlock:(PLReturnValueBlock)ReturnBlock
                         andErrorBlock:(PLErrorCodeBlock)errorCodeBlock{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [self setRequestWithInfo:nil url:[NSString stringWithFormat:@"/user/purchasing-need/%@",needId] method:@"GET" requset:request];
    
    AFHTTPRequestOperation * operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             NSString *str = operation.responseString;
             ReturnBlock(str);
         });
     }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         errorCodeBlock(@"网络错误");
     }];
    
    [_queue addOperation:operation];
}


#pragma mark - 采购者接受供应商的报价
- (void)userAcceptNeedwithPricewithId:(NSString *)needId
                      WithReturnBlock:(PLReturnValueBlock)ReturnBlock
                        andErrorBlock:(PLErrorCodeBlock)errorCodeBlock{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [self setRequestWithInfo:nil url:[NSString stringWithFormat:@"/user/quotation/%@/accept",needId] method:@"POST" requset:request];
    
    AFHTTPRequestOperation * operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             NSString *str = operation.responseString;
             ReturnBlock(str);
         });
     }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         errorCodeBlock(@"网络错误");
     }];
    
    [_queue addOperation:operation];


}

#pragma mark - 供应商获取他报过的价
- (void)sellerLookHisNeedwithPricewithDic:(NSDictionary *)infoDic
                          WithReturnBlock:(PLReturnValueBlock)ReturnBlock
                            andErrorBlock:(PLErrorCodeBlock)errorCodeBlock{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [self setRequestWithInfo:infoDic url:@"/user/quotation/list" method:@"GET" requset:request];
    
    AFHTTPRequestOperation * operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             NSString *str = operation.responseString;
             ReturnBlock(str);
         });
     }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         errorCodeBlock(@"网络错误");
     }];
    
    [_queue addOperation:operation];
}


#pragma mark - 供应商获取他某个报价详情
- (void)sellerGetHisNeedDetailwithDic:(NSString *)needId
                      WithReturnBlock:(PLReturnValueBlock)ReturnBlock
                        andErrorBlock:(PLErrorCodeBlock)errorCodeBlock{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [self setRequestWithInfo:nil url:[NSString stringWithFormat:@"/user/quotation/%@/detail",needId] method:@"GET" requset:request];
    
    AFHTTPRequestOperation * operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             NSString *str = operation.responseString;
             ReturnBlock(str);
         });
     }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         errorCodeBlock(@"网络错误");
     }];
    
    [_queue addOperation:operation];
}

#pragma mark - 供应商删掉他已经被接受的报价
- (void)sellerDeleteHisNeedwithPricewithDic:(NSString *)needId
                            WithReturnBlock:(PLReturnValueBlock)ReturnBlock
                              andErrorBlock:(PLErrorCodeBlock)errorCodeBlock{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [self setRequestWithInfo:nil url:[NSString stringWithFormat:@"/user/quotation/%@/hide-accepted",needId] method:@"POST" requset:request];
    
    AFHTTPRequestOperation * operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             NSString *str = operation.responseString;
             ReturnBlock(str);
         });
     }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         errorCodeBlock(@"网络错误");
     }];
    
    [_queue addOperation:operation];
}

- (void)userPayAtOnceWithId:(NSString *)proId andDic:(NSDictionary *)dic andReturnBlock:(PLReturnValueBlock)returnBlock andErrorBlock:(PLErrorCodeBlock)errorBlick{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [self setRequestWithInfo:dic url:[NSString stringWithFormat:@"/user/checkout/item/%@/create-order",proId] method:@"POST" requset:request];
    
    AFHTTPRequestOperation * operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             NSString *str = operation.responseString;
             returnBlock(str);
         });
     }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         errorBlick(@"网络错误");
     }];
    
    [_queue addOperation:operation];
}
#pragma mark - 获取实名认证状态
- (void)userGetcertifiCationStatusReturnBlock:(PLReturnValueBlock)returnBlock
                                andErrorBlock:(PLErrorCodeBlock)errorBlick{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [self setRequestWithInfo:nil url:@"/user/product/check-if-need-to-certificate-shop" method:@"POST" requset:request];
    
    AFHTTPRequestOperation * operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             NSString *str = operation.responseString;
             returnBlock(str);
         });
     }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         errorBlick(@"网络错误");
     }];
    
    [_queue addOperation:operation];
}
#pragma mark - 获取实名认证状态
- (void)bussuserGetcertifiCationStatusReturnBlock:(PLReturnValueBlock)returnBlock
                                andErrorBlock:(PLErrorCodeBlock)errorBlick{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [self setRequestWithInfo:nil url:@"/user/certification" method:@"GET" requset:request];
    
    AFHTTPRequestOperation * operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             NSString *str = operation.responseString;
             returnBlock(str);
         });
     }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         errorBlick(@"网络错误");
     }];
    
    [_queue addOperation:operation];
}
#pragma mark 融云token

- (void)getRcTokenwithReturnBlock:(PLReturnValueBlock)ReturnBlock andErrorBlock:(PLErrorCodeBlock)errorCodeBlock{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [self setRequestWithInfo:nil url:@"/user/im/rongcloud/token" method:@"POST" requset:request];
    
    AFHTTPRequestOperation * operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             NSString *str = operation.responseString;
             ReturnBlock(str);
         });
     }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         errorCodeBlock(@"网络错误");
     }];
    
    [_queue addOperation:operation];

}

- (void)getRcsellersinfogetRcsellersinfoWithdic:(NSDictionary *)dic  withReturnBlock:(PLReturnValueBlock)ReturnBlock andErrorBlock:(PLErrorCodeBlock)errorCodeBlock{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [self setRequestWithInfo:dic url:@"/user/im/get-sellers-info" method:@"POST" requset:request];
    
    AFHTTPRequestOperation * operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             NSString *str = operation.responseString;
             ReturnBlock(str);
         });
     }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         errorCodeBlock(@"网络错误");
     }];
    
    [_queue addOperation:operation];
}
#pragma mark 获取用户的银行卡
- (void)usergethisBankCardWithReturnBlock:(PLReturnValueBlock)returnBlock
                            andErrorBlock:(PLErrorCodeBlock)errorCodeBlock{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [self setRequestWithInfo:nil url:@"/user/bank-card/list" method:@"GET" requset:request];
    
    AFHTTPRequestOperation * operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             NSString *str = operation.responseString;
             returnBlock(str);
         });
     }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         errorCodeBlock(@"网络错误");
     }];
    
    [_queue addOperation:operation];
}



#pragma mark 添加银行卡
- (void)userAddbankcardwithInfoDic:(NSDictionary *)dic
                   WithReturnBlock:(PLReturnValueBlock)returnBlock
                     andErrorBlock:(PLErrorCodeBlock)errorCodeBlock{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [self setRequestWithInfo:dic url:@"/user/bank-card/add" method:@"POST" requset:request];
    
    AFHTTPRequestOperation * operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             NSString *str = operation.responseString;
             returnBlock(str);
         });
     }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         errorCodeBlock(@"网络错误");
     }];
    
    [_queue addOperation:operation];
}
#pragma mark 删除银行卡
- (void)userDeletehisBankCardWithCardId:(NSString *)cardId WithReturnBlock:(PLReturnValueBlock)returnBlock andErrorBlock:(PLErrorCodeBlock)errorBlcok{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [self setRequestWithInfo:nil url:[NSString stringWithFormat:@"/user/bank-card/%@/delete",cardId] method:@"POST" requset:request];
    
    AFHTTPRequestOperation * operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             NSString *str = operation.responseString;
             returnBlock(str);
         });
     }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         errorBlcok(@"网络错误");
     }];
    
    [_queue addOperation:operation];}

#pragma mark 用户发起提现请求
- (void)userdrawalrequestWithDic:(NSDictionary *)dic withReturnBlock:(PLReturnValueBlock)returnBlock andErrorBlock:(PLErrorCodeBlock)errorBlcok{

    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [self setRequestWithInfo:dic url:@"/user/withdrawal-request/create" method:@"POST" requset:request];
    
    AFHTTPRequestOperation * operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             NSString *str = operation.responseString;
             returnBlock(str);
         });
     }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         errorBlcok(@"网络错误");
     }];
    
    [_queue addOperation:operation];


}

#pragma mark 用户查看提现请求记录
- (void)usercheckdrawalrequestListWithDic:(NSDictionary *)dic withReturnBlock:(PLReturnValueBlock)returnBlock andErrorBlock:(PLErrorCodeBlock)errorBlcok{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [self setRequestWithInfo:dic url:@"/user/withdrawal-request/list" method:@"GET" requset:request];
    
    AFHTTPRequestOperation * operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             NSString *str = operation.responseString;
             returnBlock(str);
         });
     }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         errorBlcok(@"网络错误");
     }];
    
    [_queue addOperation:operation];


}
#pragma mark - ⭐️ ⭐️ ⭐️ ⭐️ ⭐️余额相关⭐️ ⭐️ ⭐️ ⭐️ ⭐️

#pragma mark 获取账单
- (void)usergetbillrecordwithInfoDic:(NSDictionary *)dic
                     WithReturnBlock:(PLReturnValueBlock)returnBlock
                       andErrorBlock:(PLErrorCodeBlock)errorCodeBlock{

    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [self setRequestWithInfo:dic url:@"/user/bill-record" method:@"GET" requset:request];
    
    AFHTTPRequestOperation * operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             NSString *str = operation.responseString;
             returnBlock(str);
         });
     }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         errorCodeBlock(@"网络错误");
     }];
    
    [_queue addOperation:operation];


}



#pragma mark 获取余额
- (void)usergetbalanceWithReturnBlock:(PLReturnValueBlock)returnBlock
                        andErrorBlock:(PLErrorCodeBlock)errorCodeBlock{

    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [self setRequestWithInfo:nil url:@"/user/bill-record/balance" method:@"GET" requset:request];
    
    AFHTTPRequestOperation * operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             NSString *str = operation.responseString;
             returnBlock(str);
         });
     }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         errorCodeBlock(@"网络错误");
     }];
    
    [_queue addOperation:operation];
}

#pragma mark - 买家删除某个UserOrder
- (void)buyersDeleteHisUserOrderwithOrderId:(NSString *)orderId
                             andReturnBlock:(PLReturnValueBlock)ReturnBlock
                              andErrorBlock:(PLErrorCodeBlock)errorCodeBlock{
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [self setRequestWithInfo:nil url:[NSString stringWithFormat:@"/user/user-order/%@/hide",orderId] method:@"POST" requset:request];
    
    AFHTTPRequestOperation * operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             NSString *str = operation.responseString;
             ReturnBlock(str);
         });
     }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         errorCodeBlock(@"网络错误");
     }];
    
    [_queue addOperation:operation];
    
}

#pragma mark - 收藏某个采购需求
- (void)userCollectNeedWithDic:(NSDictionary *)dic
               WithReturnBlock:(PLReturnValueBlock)ReturnBlock
                 andErrorBlock:(PLErrorCodeBlock)errorCodeBlock{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [self setRequestWithInfo:dic url:@"/user/purchasing-need-collection/collect" method:@"POST" requset:request];
    
    AFHTTPRequestOperation * operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             NSString *str = operation.responseString;
             ReturnBlock(str);
         });
     }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         errorCodeBlock(@"网络错误");
     }];
    
    [_queue addOperation:operation];
}
#pragma mark - 取消收藏某个采购需求
- (void)userCancleCollectNeedWithDic:(NSDictionary *)dic
                     WithReturnBlock:(PLReturnValueBlock)ReturnBlock
                       andErrorBlock:(PLErrorCodeBlock)errorCodeBlock{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [self setRequestWithInfo:dic url:@"/user/purchasing-need-collection/cancel-collect" method:@"POST" requset:request];
    
    AFHTTPRequestOperation * operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             NSString *str = operation.responseString;
             ReturnBlock(str);
         });
     }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         errorCodeBlock(@"网络错误");
     }];
    
    [_queue addOperation:operation];
}
#pragma mark - 获取用户收藏的采购需求
- (void)getUserCollectNeedsWithDic:(NSDictionary *)dic
                   WithReturnBlock:(PLReturnValueBlock)ReturnBlock
                     andErrorBlock:(PLErrorCodeBlock)errorCodeBlock;{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [self setRequestWithInfo:dic url:@"/user/purchasing-need-collection/list" method:@"GET" requset:request];
    
    AFHTTPRequestOperation * operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             NSString *str = operation.responseString;
             ReturnBlock(str);
         });
     }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         errorCodeBlock(@"网络错误");
     }];
    
    [_queue addOperation:operation];
}

#pragma mark - 获取用户创建的产品
- (void)userGetMasterProductwithInfoDic:(NSDictionary *)infodic
                            ReturnBlock:(PLReturnValueBlock)ReturnBlock
                          andErrorBlock:(PLErrorCodeBlock)errorCodeBlock{
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [self setRequestWithInfo:infodic url:@"/user/product" method:@"GET" requset:request];
    
    AFHTTPRequestOperation * operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             NSString *str = operation.responseString;
             ReturnBlock(str);
         });
     }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         errorCodeBlock(@"网络错误");
     }];
    
    [_queue addOperation:operation];
}
#pragma mark - 获取库存警报的产品
- (void)userGetInventoryAlertProductwithInfoDic:(NSDictionary *)infodic
                                    ReturnBlock:(PLReturnValueBlock)ReturnBlock
                                  andErrorBlock:(PLErrorCodeBlock)errorCodeBlock{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [self setRequestWithInfo:infodic url:@"/user/product/warning" method:@"GET" requset:request];
    
    AFHTTPRequestOperation * operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             NSString *str = operation.responseString;
             ReturnBlock(str);
         });
     }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         errorCodeBlock(@"网络错误");
     }];
    
    [_queue addOperation:operation];
}
#pragma mark - 设置自定义数据
- (void)UserSetCustomInfoWithInfoDic:(NSDictionary *)infoDic
                     withReturnBlock:(PLReturnValueBlock)ReturnBlock
                       andErrorBlock:(PLErrorCodeBlock)errorCodeBlock{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [self setRequestWithInfo:infoDic url:@"/user/shop-setting/set-custom-data" method:@"POST" requset:request];
    
    AFHTTPRequestOperation * operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             NSString *str = operation.responseString;
             ReturnBlock(str);
         });
     }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         errorCodeBlock(@"网络错误");
     }];
    
    [_queue addOperation:operation];
    
}


#pragma mark - 获取自定义数据
- (void)UserGetustomInfoWithInfoDic:(NSDictionary *)infoDic
                    withReturnBlock:(PLReturnValueBlock)ReturnBlock
                      andErrorBlock:(PLErrorCodeBlock)errorCodeBlock{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [self setRequestWithInfo:infoDic url:@"/user/shop-setting/get-custom-data" method:@"POST" requset:request];
    
    AFHTTPRequestOperation * operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             NSString *str = operation.responseString;
             ReturnBlock(str);
         });
     }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         errorCodeBlock(@"网络错误");
     }];
    
    [_queue addOperation:operation];
    
}
#pragma mark - 产品上架
- (void)userUpProductwithProId:(NSString *)proId
                   ReturnBlock:(PLReturnValueBlock)ReturnBlock
                 andErrorBlock:(PLErrorCodeBlock)errorCodeBlock{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [self setRequestWithInfo:nil url:[NSString stringWithFormat:@"/user/product/%@/on-sale",proId] method:@"POST" requset:request];
    
    AFHTTPRequestOperation * operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             NSString *str = operation.responseString;
             ReturnBlock(str);
         });
     }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         errorCodeBlock(@"网络错误");
     }];
    
    [_queue addOperation:operation];
}

#pragma mark - 产品下架
- (void)userDownProductwithProId:(NSString *)proId
                     ReturnBlock:(PLReturnValueBlock)ReturnBlock
                   andErrorBlock:(PLErrorCodeBlock)errorCodeBlock{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [self setRequestWithInfo:nil url:[NSString stringWithFormat:@"/user/product/%@/not-sale",proId] method:@"POST" requset:request];
    
    AFHTTPRequestOperation * operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             NSString *str = operation.responseString;
             ReturnBlock(str);
         });
     }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         errorCodeBlock(@"网络错误");
     }];
    
    [_queue addOperation:operation];
}
#pragma mark - 产品删除
- (void)userDeleteProductwithProId:(NSString *)proId
                       ReturnBlock:(PLReturnValueBlock)ReturnBlock
                     andErrorBlock:(PLErrorCodeBlock)errorCodeBlock{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [self setRequestWithInfo:nil url:[NSString stringWithFormat:@"/user/product/%@/delete",proId] method:@"POST" requset:request];
    
    AFHTTPRequestOperation * operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             NSString *str = operation.responseString;
             ReturnBlock(str);
         });
     }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         errorCodeBlock(@"网络错误");
     }];
    
    [_queue addOperation:operation];
}

#pragma mark - 批量产品加入样品间
- (void)probatchsetissamplewithInfoDic:(NSDictionary *)infodic
                           ReturnBlock:(PLReturnValueBlock)ReturnBlock
                         andErrorBlock:(PLErrorCodeBlock)errorCodeBlock{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [self setRequestWithInfo:infodic url:@"/user/product/batch-set-is-sample" method:@"POST" requset:request];
    
    AFHTTPRequestOperation * operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             NSString *str = operation.responseString;
             ReturnBlock(str);
         });
     }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         errorCodeBlock(@"网络错误");
     }];
    
    [_queue addOperation:operation];
    
}

#pragma mark - 批量产品移出样品间
- (void)probatchsetnotsamplewithInfoDic:(NSDictionary *)infodic
                            ReturnBlock:(PLReturnValueBlock)ReturnBlock
                          andErrorBlock:(PLErrorCodeBlock)errorCodeBlock{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [self setRequestWithInfo:infodic url:@"/user/product/batch-set-not-sample" method:@"POST" requset:request];
    
    AFHTTPRequestOperation * operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             NSString *str = operation.responseString;
             ReturnBlock(str);
         });
     }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         errorCodeBlock(@"网络错误");
     }];
    
    [_queue addOperation:operation];
    
}
#pragma mark - 获取某个产品信息
- (void)userGetMasterProductDetailwithProId:(NSString *)proId
                                ReturnBlock:(PLReturnValueBlock)ReturnBlock
                              andErrorBlock:(PLErrorCodeBlock)errorCodeBlock{
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [self setRequestWithInfo:nil url:[NSString stringWithFormat:@"/user/product/%@",proId] method:@"GET" requset:request];
    
    AFHTTPRequestOperation * operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             NSString *str = operation.responseString;
             ReturnBlock(str);
         });
     }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         errorCodeBlock(@"网络错误");
     }];
    
    [_queue addOperation:operation];
}

@end
