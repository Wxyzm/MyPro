//
//  FabricUnitModel.m
//  FyhNewProj
//
//  Created by yh f on 2017/11/4.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import "FabricUnitModel.h"
#import "SampleColthModel.h"
#import "SampleCardModel.h"
@implementation FabricUnitModel

-(instancetype)init{
    
    self = [super init];
    if (self) {
        if (!_kindArr) {
            _kindArr = [NSMutableArray arrayWithCapacity:0];
        }
        if (!_statusArr) {
            _statusArr = [NSMutableArray arrayWithCapacity:0];
        }
        if (!_colorArr) {
            _colorArr = [NSMutableArray arrayWithCapacity:0];
        }
        if (!_cardModel) {
            _cardModel = [[SampleCardModel alloc]init];
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
        if (!_editType) {
            _editType = 0;
        }
    }
    
    return self;
    
}

-(void)setIsFirstEdit:(BOOL)isFirstEdit{
    
    _isFirstEdit = isFirstEdit;
    if (_isFirstEdit) {
         _kindArr = [NSMutableArray arrayWithCapacity:0];
        _statusArr = [NSMutableArray arrayWithCapacity:0];
        _colorArr = [NSMutableArray arrayWithCapacity:0];
        _cardModel = [[SampleCardModel alloc]init];
        _colthModel = [[SampleColthModel alloc]init];
        _dataArr = [NSMutableArray arrayWithCapacity:0];
        _photoArr = [NSMutableArray arrayWithCapacity:0];
        _mineImage = nil;
        _editType = 0;
    }
    
}

@end
