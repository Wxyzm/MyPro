//
//  ParaMeterSelectCell.m
//  FyhNewProj
//
//  Created by yh f on 2017/11/1.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import "ParaMeterSelectCell.h"
#import "ComponentCell.h"
#import "ParaMeterModel.h"
#import "ComponentModel.h"
@implementation ParaMeterSelectCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = UIColorFromRGB(WhiteColorValue);
        self.selectionStyle = UITableViewCellSeparatorStyleNone;
        [self setUP];
        
        
    }
    return self;
    
}

- (void)setUP{
    
    _nameLab  = [BaseViewFactory  labelWithFrame:CGRectMake(16, 0, 100, 48) textColor:UIColorFromRGB(BlackColorValue) font:APPFONT(15) textAligment:NSTextAlignmentLeft andtext:@""];
    [self.contentView addSubview:_nameLab];
  
    _valueLab  = [BaseViewFactory  labelWithFrame:CGRectMake(128, 0, ScreenWidth - 128-26-9, 48) textColor:UIColorFromRGB(PLAHColorValue) font:APPFONT(15) textAligment:NSTextAlignmentRight andtext:@"请选择"];
    [self.contentView addSubview:_valueLab];
    
    _rightImageView = [BaseViewFactory icomWithWidth:10 imagePath:@"right"];
    [self.contentView addSubview:_rightImageView];
    _rightImageView.frame = CGRectMake(ScreenWidth - 26, 16, 10, 16);
    
    UIView *line = [BaseViewFactory viewWithFrame:CGRectMake(0, 47.5, ScreenWidth, 0.5) color:UIColorFromRGB(PLAHColorValue)];
    [self.contentView addSubview:line];
    
  
}


- (void)setModel:(ParaMeterModel *)model{
    
    _model = model;
    
    if ([model.ParaKind isEqualToString:@"成分"]) {
        NSMutableArray *muStrArr = [[NSMutableArray alloc]init];
        for (NSMutableDictionary *dic in model.componentModel.chenfenArr) {
            if (IsEmptyStr(dic[COMPENTVALUE])) {
                
            }else{
                [muStrArr addObject:[NSString stringWithFormat:@"%@%%%@",dic[COMPENTVALUE],dic[COMPENTUNIT]]];
            }
        }
        if (muStrArr.count<=0) {
            _valueLab.text = @"请选择";
            _model.componentModel.upStr = @"";
        }else{
            _valueLab.text = [muStrArr componentsJoinedByString:@","];
             _model.componentModel.upStr =_valueLab.text;
        }
    }else{
        if (!model.ParaNameArr||model.ParaNameArr.count<=0) {
            _valueLab.text = @"请选择";
        }else{
            _valueLab.text = [model.ParaNameArr componentsJoinedByString:@","];
            
        }
    }
    
    _nameLab.text = model.ParaKind;
   

}


@end
