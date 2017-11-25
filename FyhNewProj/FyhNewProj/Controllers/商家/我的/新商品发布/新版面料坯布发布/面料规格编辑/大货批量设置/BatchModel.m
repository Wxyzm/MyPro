//
//  BatchModel.m
//  FyhNewProj
//
//  Created by yh f on 2017/11/6.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import "BatchModel.h"

@implementation BatchModel

-(instancetype)init{
    
    self = [super init];
    if (self) {
        if (!_kind) {
            _kind = @"";
        }
        if (!_minePictureStr) {
            _minePictureStr = @"";
        }
        if (!_price) {
            _price = @"";
        }
        if (!_stock) {
            _stock = @"";
        }
        if (!_mineBuy) {
            _mineBuy = @"";
        }
       
        if (!_cndUrl) {
            _cndUrl = @"";
        }
        if (!_limitBuy) {
            _limitBuy = @"";
        }
    }
    return self;
    
}

@end
