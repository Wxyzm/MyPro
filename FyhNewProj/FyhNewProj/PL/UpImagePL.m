//
//  UpImagePL.m
//  FyhNewProj
//
//  Created by yh f on 2017/4/25.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import "UpImagePL.h"

@implementation UpImagePL

- (void)updateImg:(UIImage*)image WithReturnBlock:(PLReturnValueBlock) returnBlock withErrorBlock:(PLErrorCodeBlock) errorBlock {

    MBProgressHUD *progressHUD = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    progressHUD.label.text = @"正在上传";
    if (!image) {
        return;
    }
    __block int timeNum = 0;
    [[[RACSignal createSignal:^RACDisposable *(id subscriber){
        timeNum ++;
        if (timeNum > 3) {//调用超过3次就不继续循环调用
            errorBlock(@"网络不给力啊!");
        }
        
        if (timeNum % 2 == 1) {
            
            NSData * imageData = [self scaleImage:image toKb:1024];
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = @"yyyyMMddHHmmss";
            NSString *str = [formatter stringFromDate:[NSDate date]];
            NSString *fileName = [NSString stringWithFormat:@"%@.png", str];
            NSDictionary *dataDict = @{@"image":imageData};
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
            
            
            NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
            NSTimeInterval a=[dat timeIntervalSince1970];
            NSString *timeString = [NSString stringWithFormat:@"%.0f", a];
            [manager.requestSerializer setValue:@"FYHIOS" forHTTPHeaderField:@"FYH-App-Key"];
            [manager.requestSerializer setValue:@"FYH-App-Key" forHTTPHeaderField:@"iOS_51"];
            
            [manager.requestSerializer setValue:timeString forHTTPHeaderField:@"FYH-App-Timestamp"];
            [manager.requestSerializer setValue:@"multipart/form-data" forHTTPHeaderField:@"Content-Type"];
            
            //用的是测试的
            [manager.requestSerializer setValue:@"oIkBLWG4OUHTgYmN" forHTTPHeaderField:@"FYH-App-Signature"];
            //需要在登录后获取 存于本地  注意在用户登出时清掉
            if ([HTTPClient getUserSessiond]) {
                [manager.requestSerializer setValue:[HTTPClient getUserSessiond] forHTTPHeaderField:@"FYH-Session-Id"];
            }
            
            
            
            [manager POST:[NSString stringWithFormat:@"%@/user/upload-images?imageType=",kbaseUrl] parameters:dataDict constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                
                [formData appendPartWithFileData:imageData name:@"image" fileName:fileName mimeType:@"image/png"];
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
                
                NSDictionary  *jsonDic = [NSJSONSerialization  JSONObjectWithData:responseObject options:0 error:nil];
                NSArray *returnArr = jsonDic[@"data"];
                NSError *parseError = nil;
                NSData *jsonData = [NSJSONSerialization dataWithJSONObject:returnArr options:NSJSONWritingPrettyPrinted error:&parseError];
                NSString *jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                NSDictionary *jsDic = [HTTPClient valueWithJsonString:jsonStr];
                
                returnBlock(jsDic);
                
                [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow  animated:YES];
                
            } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
                [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow  animated:YES];
                if (timeNum > 1) {
                    errorBlock(@"图片上传失败");
                } else {
                    [subscriber sendError:nil];
                }
            }];
            
        } else {
            [[UserPL shareManager] setUserData:[[UserPL shareManager] getLoginUser]];
            [[UserPL shareManager] userLoginWithReturnBlock:^(id returnValue) {
                [subscriber sendError:nil];
            } withErrorBlock:^(NSString *msg) {
                [subscriber sendError:nil];
                
            }];
            
        }
        
        return nil;
    }] retry] subscribeNext:^(id x) {
        
    }];
    

    
}

- (void)updateToByGoodsImgArr:(NSArray*)imageArr WithReturnBlock:(PLReturnValueBlock) returnBlock withErrorBlock:(PLErrorCodeBlock) errorBlock{

    MBProgressHUD *progressHUD = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    progressHUD.label.text = @"正在上传";
    
    //    HTTPClient *client = [HTTPClient sharedHttpClient];
    if (imageArr.count<=0) {
        return;
    }
    __block int timeNum = 0;
    [[[RACSignal createSignal:^RACDisposable *(id subscriber){
        timeNum ++;
        if (timeNum > 3) {//调用超过3次就不继续循环调用
            errorBlock(@"网络不给力啊!");
        }
        
        if (timeNum % 2 == 1) {
            
            
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
            
            
            NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
            NSTimeInterval a=[dat timeIntervalSince1970];
            NSString *timeString = [NSString stringWithFormat:@"%.0f", a];
            [manager.requestSerializer setValue:@"FYHIOS" forHTTPHeaderField:@"FYH-App-Key"];
            [manager.requestSerializer setValue:@"FYH-App-Key" forHTTPHeaderField:@"iOS_51"];
            
            [manager.requestSerializer setValue:timeString forHTTPHeaderField:@"FYH-App-Timestamp"];
            [manager.requestSerializer setValue:@"multipart/form-data" forHTTPHeaderField:@"Content-Type"];
            
            //用的是测试的
            [manager.requestSerializer setValue:@"oIkBLWG4OUHTgYmN" forHTTPHeaderField:@"FYH-App-Signature"];
            //需要在登录后获取 存于本地  注意在用户登出时清掉
            if ([HTTPClient getUserSessiond]) {
                [manager.requestSerializer setValue:[HTTPClient getUserSessiond] forHTTPHeaderField:@"FYH-Session-Id"];
            }
            
            
            
            [manager POST:[NSString stringWithFormat:@"%@/user/upload-images?imageType=4",kbaseUrl] parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                
                for (NSInteger i = 0; i < imageArr.count; i ++) {
                    UIImage *images = imageArr[i];
                    NSData *picData = [self scaleImage:images toKb:500];
                    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                    formatter.dateFormat = @"yyyyMMddHHmmss";
                    NSString *fileName = [NSString stringWithFormat:@"%@%ld.png", [formatter stringFromDate:[NSDate date]], (long)i];
                    [formData appendPartWithFileData:picData name:[NSString stringWithFormat:@"File%ld",(long)i] fileName:fileName mimeType:@"image/png"];
                }
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
                
                NSDictionary  *jsonDic = [NSJSONSerialization  JSONObjectWithData:responseObject options:0 error:nil];
                NSArray *returnArr = jsonDic[@"data"];
                NSError *parseError = nil;
                NSData *jsonData = [NSJSONSerialization dataWithJSONObject:returnArr options:NSJSONWritingPrettyPrinted error:&parseError];
                NSString *jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                NSDictionary *jsDic = [HTTPClient valueWithJsonString:jsonStr];
                [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow  animated:YES];

                returnBlock(jsDic);
                
                
            } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
                [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow  animated:YES];
                if (timeNum > 1) {
                    errorBlock(@"上传失败");
                } else {
                    [subscriber sendError:nil];
                }
            }];
            
        } else {
            [[UserPL shareManager] setUserData:[[UserPL shareManager] getLoginUser]];
            [[UserPL shareManager] userLoginWithReturnBlock:^(id returnValue) {
                [subscriber sendError:nil];
            } withErrorBlock:^(NSString *msg) {
                [subscriber sendError:nil];
                
            }];
            
        }
        
        return nil;
    }] retry] subscribeNext:^(id x) {
        
    }];
    

    
    

}

- (void)shopUpdateToByGoodsImgArr:(NSArray*)imageArr WithReturnBlock:(PLReturnValueBlock) returnBlock withErrorBlock:(PLErrorCodeBlock) errorBlock{
    
//    MBProgressHUD *progressHUD = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
//    progressHUD.label.text = @"正在上传";
    
    //    HTTPClient *client = [HTTPClient sharedHttpClient];
    if (imageArr.count<=0) {
        return;
    }
    __block int timeNum = 0;
    [[[RACSignal createSignal:^RACDisposable *(id subscriber){
        timeNum ++;
        if (timeNum > 3) {//调用超过3次就不继续循环调用
            errorBlock(@"网络不给力啊!");
        }
        
        if (timeNum % 2 == 1) {
            
            
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
            
            
            NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
            NSTimeInterval a=[dat timeIntervalSince1970];
            NSString *timeString = [NSString stringWithFormat:@"%.0f", a];
            [manager.requestSerializer setValue:@"FYHIOS" forHTTPHeaderField:@"FYH-App-Key"];
            [manager.requestSerializer setValue:@"FYH-App-Key" forHTTPHeaderField:@"iOS_51"];
            
            [manager.requestSerializer setValue:timeString forHTTPHeaderField:@"FYH-App-Timestamp"];
            [manager.requestSerializer setValue:@"multipart/form-data" forHTTPHeaderField:@"Content-Type"];
            
            //用的是测试的
            [manager.requestSerializer setValue:@"oIkBLWG4OUHTgYmN" forHTTPHeaderField:@"FYH-App-Signature"];
            //需要在登录后获取 存于本地  注意在用户登出时清掉
            if ([HTTPClient getUserSessiond]) {
                [manager.requestSerializer setValue:[HTTPClient getUserSessiond] forHTTPHeaderField:@"FYH-Session-Id"];
            }
            
            
            
            [manager POST:[NSString stringWithFormat:@"%@/user/upload-images?imageType=2",kbaseUrl] parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                
                for (NSInteger i = 0; i < imageArr.count; i ++) {
                    UIImage *images = imageArr[i];
                    NSData *picData = [self scaleImage:images toKb:500];
                    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                    formatter.dateFormat = @"yyyyMMddHHmmss";
                    NSString *fileName = [NSString stringWithFormat:@"%@%ld.png", [formatter stringFromDate:[NSDate date]], (long)i];
                    [formData appendPartWithFileData:picData name:[NSString stringWithFormat:@"File%ld",(long)i] fileName:fileName mimeType:@"image/png"];
                }
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
                
                NSDictionary  *jsonDic = [NSJSONSerialization  JSONObjectWithData:responseObject options:0 error:nil];
                NSArray *returnArr = jsonDic[@"data"];
                NSError *parseError = nil;
                NSData *jsonData = [NSJSONSerialization dataWithJSONObject:returnArr options:NSJSONWritingPrettyPrinted error:&parseError];
                NSString *jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                NSDictionary *jsDic = [HTTPClient valueWithJsonString:jsonStr];
              //  [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow  animated:YES];
                
                returnBlock(jsDic);
                
                
            } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
             //   [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow  animated:YES];
                if (timeNum > 1) {
                    errorBlock(@"上传失败");
                } else {
                    [subscriber sendError:nil];
                }
            }];
            
        } else {
            [[UserPL shareManager] setUserData:[[UserPL shareManager] getLoginUser]];
            [[UserPL shareManager] userLoginWithReturnBlock:^(id returnValue) {
                [subscriber sendError:nil];
            } withErrorBlock:^(NSString *msg) {
                [subscriber sendError:nil];
                
            }];
            
        }
        
        return nil;
    }] retry] subscribeNext:^(id x) {
        
    }];
    
    
    
    
    
}


#pragma mark ===== 图片压缩至1m


/**
 压缩图片返回data
 @param image 传入图片
 @param kb 压缩至1M（1024kb）
 @return 压缩后的图片转化的base64编码
 */
- (NSData *)scaleImage:(UIImage *)image toKb:(NSInteger)kb{
    
    kb*=400;
    CGFloat compression = 0.9f;
    CGFloat maxCompression = 0.1f;
    NSData *imageData = UIImageJPEGRepresentation(image, compression);
    NSLog(@"原始大小:%fkb",(float)[imageData length]/1024.0f);
    while ([imageData length] > kb && compression > maxCompression) {
        compression -= 0.1;
        imageData = UIImageJPEGRepresentation(image, compression);
    }
    NSLog(@"当前大小:%fkb",(float)[imageData length]/1024.0f);
    //    UIImage *compressedImage = [UIImage imageWithData:imageData];
    return imageData;
}

@end
