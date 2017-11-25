//
//  CreateFlowerModel.m
//  FyhNewProj
//
//  Created by yh f on 2017/11/9.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import "CreateFlowerModel.h"
#import "SampleColthModel.h"

@implementation CreateFlowerModel

-(instancetype)init{
    
    self = [super init];
    if (self) {
        if (!_kindArr) {
            _kindArr = [NSMutableArray arrayWithCapacity:0];
        }
        if (!_statusArr) {
            _statusArr = [NSMutableArray arrayWithCapacity:0];
        }
      
        if (!_colthModel) {
            _colthModel = [[SampleColthModel alloc]init];
        }
        if (!_dataArr) {
            _dataArr = [NSMutableArray arrayWithCapacity:0];
        }
        if (!_photoArr) {
            _photoArr = [NSMutableArray arrayWithCapacity:0];
        }
    }
    
    return self;
    
}

-(void)setIsFirstEdit:(BOOL)isFirstEdit{
    _isFirstEdit = isFirstEdit;
    if (isFirstEdit) {
        _kindArr = [NSMutableArray arrayWithCapacity:0];
        _statusArr = [NSMutableArray arrayWithCapacity:0];
        _colthModel = [[SampleColthModel alloc]init];
        _dataArr = [NSMutableArray arrayWithCapacity:0];
        _photoArr = [NSMutableArray arrayWithCapacity:0];
        _mineImage = nil;
    }
    
}
@end
