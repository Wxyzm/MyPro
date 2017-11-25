//
//  UpEncodedImageStrPL.h
//  FyhNewProj
//
//  Created by yh f on 2017/3/10.
//  Copyright © 2017年 fyh. All rights reserved.
//

//按图片base64搜索商品

#import <Foundation/Foundation.h>

@interface UpEncodedImageStrPL : NSObject

-(void)searchItemsByJpegBase64Str:(NSData *)data withReturnBlock:(PLReturnValueBlock)returnBlock anderrorBlock:(PLErrorCodeBlock)errorBlock;


@end
