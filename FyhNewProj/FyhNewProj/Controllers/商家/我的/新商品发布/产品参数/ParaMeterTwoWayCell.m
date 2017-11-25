//
//  ParaMeterTwoWayCell.m
//  FyhNewProj
//
//  Created by yh f on 2017/11/1.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import "ParaMeterTwoWayCell.h"
#import "TwoUnitSelectedController.h"
#import "ParaMeterModel.h"


@interface ParaMeterTwoWayCell ()<UITextFieldDelegate>


@end
@implementation ParaMeterTwoWayCell





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
    
    UIImageView *rightImageView = [BaseViewFactory icomWithWidth:8 imagePath:@"ParaMeter_Down"];
    [self.contentView addSubview:rightImageView];
    rightImageView.frame = CGRectMake(ScreenWidth - 24, 20.5, 8, 7);
    
   
    
    _unitLab = [BaseViewFactory  labelWithFrame:CGRectMake(ScreenWidth - 102, 0, 72, 48) textColor:UIColorFromRGB(BlackColorValue) font:APPFONT(15) textAligment:NSTextAlignmentRight andtext:@""];
    [self.contentView addSubview:_unitLab];
    
    UIView *line = [BaseViewFactory viewWithFrame:CGRectMake(ScreenWidth - 102, 13, 0.5, 22) color:UIColorFromRGB(0xccd1d9)];
    [self.contentView addSubview:line];
    
    _valueTxt = [BaseViewFactory textFieldWithFrame:CGRectMake(128, 0, ScreenWidth - 128-102 -18, 48) font:APPFONT(15) placeholder:@"请输入数值" textColor:UIColorFromRGB(PLAHColorValue) placeholderColor:UIColorFromRGB(PLAHColorValue) delegate:self];
    _valueTxt.textAlignment = NSTextAlignmentRight;
    _valueTxt.keyboardType = UIKeyboardTypeNumberPad;
    [self.contentView addSubview:_valueTxt];
    
    
    UIView *lineView = [BaseViewFactory viewWithFrame:CGRectMake(0, 47.5, ScreenWidth, 0.5) color:UIColorFromRGB(PLAHColorValue)];
    [self.contentView addSubview:lineView];
    
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:btn];
    btn.frame = CGRectMake(ScreenWidth - 102, 0, 102, 48);
    [btn addTarget:self action:@selector(unitBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    
}


- (void)setModel:(ParaMeterModel *)model{
    
    _model = model;
    _nameLab.text = model.ParaKind;
   
    //没有model.twoUnit
    if (!model.twoUnit||model.twoUnit.length<=0) {
        if ([model.ParaKind isEqualToString:@"克重"]) {
            _unitLab.text = @"克/㎡";
            model.twoUnit = @"克/㎡";
        }else if ([model.ParaKind isEqualToString:@"门幅"]){
            model.twoUnit = @"厘米";
            _unitLab.text = @"厘米";
        }else if ([model.ParaKind isEqualToString:@"分辨率"]){
            model.twoUnit = @"dpi";
            _unitLab.text = @"dpi";
        }
    }else{
        _unitLab.text = model.twoUnit;
    }
   
    _valueTxt.text = model.twoValue;
    
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    
    if (textField == _valueTxt) {
        _model.twoValue = _valueTxt.text;
    }
    
    
}

/**
 换单位
 */
-(void)unitBtnClick{
    
    TwoUnitSelectedController *unVc = [[TwoUnitSelectedController alloc]init];
    unVc.model = _model;
    [[GlobalMethod getCurrentVC].navigationController pushViewController:unVc animated:YES];
    
    
    
}




@end
