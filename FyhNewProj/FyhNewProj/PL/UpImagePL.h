//
//  UpImagePL.h
//  FyhNewProj
//
//  Created by yh f on 2017/4/25.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UpImagePL : NSObject


/**
 上传头像

 @param image 头像
 @param returnBlock 成功
 @param errorBlock 失败
 */
- (void)updateImg:(UIImage*)image WithReturnBlock:(PLReturnValueBlock) returnBlock withErrorBlock:(PLErrorCodeBlock) errorBlock ;

/**
 上传用户采购需求的图片
 
 @param imageArr 图片数组
 @param returnBlock 成功
 @param errorBlock 失败
 */
- (void)updateToByGoodsImgArr:(NSArray*)imageArr WithReturnBlock:(PLReturnValueBlock) returnBlock withErrorBlock:(PLErrorCodeBlock) errorBlock ;

/**
 上传用户发布商品的图片
 
 @param imageArr 图片数组
 @param returnBlock 成功
 @param errorBlock 失败
 */
- (void)shopUpdateToByGoodsImgArr:(NSArray*)imageArr WithReturnBlock:(PLReturnValueBlock) returnBlock withErrorBlock:(PLErrorCodeBlock) errorBlock ;

@end
