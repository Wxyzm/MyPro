//
//  AlipayHanler.h
//  FyhNewProj
//
//  Created by yh f on 2017/4/25.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AlipayHanler;

@protocol AlipayHandlerDelegate <NSObject>

@required
- (void)finishedAlipayPaymentWithResult:(NSDictionary*)resultDic;

@end


@interface AlipayHanler : NSObject

@property(assign, nonatomic) id<AlipayHandlerDelegate>delegate;

- (void)payWithorderString:(NSString *)orderString;


@end
