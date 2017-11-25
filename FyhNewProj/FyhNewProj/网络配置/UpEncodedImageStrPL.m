//
//  UpEncodedImageStrPL.m
//  FyhNewProj
//
//  Created by yh f on 2017/3/10.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import "UpEncodedImageStrPL.h"

@implementation UpEncodedImageStrPL

-(void)searchItemsByJpegBase64Str:(NSData *)data withReturnBlock:(PLReturnValueBlock)returnBlock anderrorBlock:(PLErrorCodeBlock)errorBlock{
    HTTPClient *client = [HTTPClient sharedHttpClient];
    [client POST:@"/gateway?api=searchItemsByImageFile" dict:@{@"image":data} success:^(NSDictionary *resultDic) {
        NSLog(@"图片的base64编码字符串接口调用成功%@",resultDic[@"data"]);
        if ([resultDic[@"code"] intValue]==0) {
            
            returnBlock(resultDic[@"data"]);
        }else{
            errorBlock(resultDic[@"message"]);
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        errorBlock(@"网络错误请稍后再试");
    }];



    


}

@end
