//
//  MyNeedsNetModel.m
//  FyhNewProj
//
//  Created by yh f on 2017/5/15.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import "MyNeedsNetModel.h"

@implementation MyNeedsNetModel

-(instancetype)init{

    self = [super init];
    if (self) {
        if (!_pageNum) {
            _pageNum = 1;
        }
        if (!_title) {
            _title = @"";
        }
        if (!_categoryId) {
            _categoryId = @"";
        }
        if (!_sort) {
            _sort = @"";
        }
    }
    
    return self;
}


@end
